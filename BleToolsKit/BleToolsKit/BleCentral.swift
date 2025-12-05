//
//  BleCentral.swift
//  BleToolsKit
//
//  Created by app on 2025/10/20.
//

import Foundation
import CoreBluetooth

// 内部类，不对外暴露
internal final class BleCentral: NSObject {

    // MARK: Singleton（也可自行实例化）
    internal static let shared = BleCentral()
    private override init() {
        queue = DispatchQueue(label: "ble.central.queue")
        super.init()
        central = CBCentralManager(delegate: self, queue: queue)
        loadDeviceMacMapping()
    }

    // MARK: Private state
    private let queue: DispatchQueue
    private var central: CBCentralManager!
    private var seen = Set<UUID>()
    private var onFound: ((BleDevice) -> Void)?
    private var onScanError: ((Error) -> Void)?
    private var scanFilter: BleFilter = .init()

    // 连接态
    private var connectContinuations: [UUID: (Result<CBPeripheral, Error>) -> Void] = [:]
    private var notifyHandlers: [CBUUID: (String) -> Void] = [:]
    private var valueHandlers:  [CBUUID: (Result<String, Error>) -> Void] = [:]
    
    // 特征缓存
    private var writeCharacteristic: CBCharacteristic?
    private var notifyCharacteristic: CBCharacteristic?
    
    // MAC 地址映射：设备 UUID -> MAC 地址
    private var deviceMacMapping: [String: String] = [:]
    
    // 当前设备的 MAC 地址（全局变量，供其他地方使用）
    internal var macAddress: String?
    
    // 密钥池索引（用于加密通信）
    internal var poolIndex: Int = 0
    
    // 目标 UUID 常量
    private let targetServiceUUID = CBUUID(string: BleConstants.ServiceUUIDs.targetService)
    private let writeCharUUID = CBUUID(string: BleConstants.CharacteristicUUIDs.write)
    private let notifyCharUUID = CBUUID(string: BleConstants.CharacteristicUUIDs.notify)

    // MARK: Scanning
    @discardableResult
    internal func startScan(
        filter: BleFilter = .init(),
        onFound: @escaping (BleDevice) -> Void,
        onError: @escaping (Error) -> Void
    ) -> ScanToken {
        self.scanFilter = filter
        self.onFound = onFound
        self.onScanError = onError

        if central.state == .poweredOn {
            beginScan()
        } else {
            reportStateErrorIfNeeded()
        }

        return Token { [weak self] in self?.stopScan() }
    }

    internal func stopAllScans() { stopScan() }

    // MARK: Connect
    /// 超时（秒）可选，默认 10 秒
    internal func connect(
        _ device: BleDevice,
        timeout: TimeInterval = 10,
        onReady: @escaping (CBPeripheral) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        let p = device.peripheral
        p.delegate = self
        connectContinuations[p.identifier] = { result in
            switch result {
            case .success(let per): onReady(per)
            case .failure(let e):   onError(e)
            }
        }

        queue.async { [weak self] in
            guard let self else { return }
            self.central.connect(p, options: nil)
            // 超时逻辑
            self.queue.asyncAfter(deadline: .now() + timeout) { [weak self] in
                guard let self else { return }
                if self.connectContinuations[p.identifier] != nil {
                    self.central.cancelPeripheralConnection(p)
                    self.finishConnect(p, with: .failure(BleError.timeout))
                }
            }
        }
    }

    internal func disconnect(_ peripheral: CBPeripheral) {
        queue.async { [weak self] in self?.central.cancelPeripheralConnection(peripheral) }
    }

    // MARK: Discover services/chars
    /// 连接后发现服务与特征
    internal func discoverCharacteristics(
        for peripheral: CBPeripheral,
        serviceUUIDs: [CBUUID],
        characteristicUUIDs: [CBUUID],
        onReady: @escaping ([CBCharacteristic]) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        peripheral.delegate = self
        peripheral.discoverServices(serviceUUIDs)

        // 暂存一个一次性的完成回调：发现所有特征后返回
        // 简化：我们在 didDiscoverCharacteristicsFor 每次累计，全部找到后回调
        DiscoverContext.shared.setExpectation(
            periph: peripheral,
            targetServiceUUIDs: Set(serviceUUIDs),
            targetCharUUIDs: Set(characteristicUUIDs),
            onReady: onReady, onError: onError
        )
    }

    // MARK: Write / Read / Notify
    internal func write(
        data: Data,
        to characteristic: CBCharacteristic,
        onError: @escaping (Error) -> Void
    ) {
        guard let p = characteristic.service?.peripheral else {
            onError(BleError.unknown); return
        }
        // 优先使用 withResponse
        let props = characteristic.properties
        let type: CBCharacteristicWriteType = props.contains(.write) ? .withResponse : .withoutResponse
        p.writeValue(data, for: characteristic, type: type)
        // 若需要回执/错误，可在 peripheral:didWriteValueFor 捕获错误
        WriteContext.shared.remember(char: characteristic, onError: onError)
    }

    internal func setNotify(
        _ enabled: Bool,
        for characteristic: CBCharacteristic,
        onUpdate: ((String) -> Void)?,
        onError: @escaping (Error) -> Void
    ) {
        guard let p = characteristic.service?.peripheral else { onError(BleError.unknown); return }
        notifyHandlers[characteristic.uuid] = onUpdate
        p.setNotifyValue(enabled, for: characteristic)
        // 成功与否在 didUpdateNotificationStateFor 回调
        NotifyContext.shared.remember(char: characteristic, onError: onError)
    }

    internal func readValue(
        for characteristic: CBCharacteristic,
        onValue: @escaping (Result<String, Error>) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        guard let p = characteristic.service?.peripheral else { onError(BleError.unknown); return }
        valueHandlers[characteristic.uuid] = onValue
        p.readValue(for: characteristic)
        // 结果见 didUpdateValueFor
    }

    // MARK: Internal helpers
    private func beginScan() {
        seen.removeAll()
        let opts: [String: Any] = [
            CBCentralManagerScanOptionAllowDuplicatesKey: scanFilter.allowDuplicates
        ]
        central.scanForPeripherals(withServices: scanFilter.serviceUUIDs, options: opts)
    }

    private func stopScan() {
        central.stopScan()
        seen.removeAll()
    }

    private func finishConnect(_ p: CBPeripheral, with result: Result<CBPeripheral, Error>) {
        let key = p.identifier
        let cont = connectContinuations.removeValue(forKey: key)
        cont?(result)
    }

    private func reportStateErrorIfNeeded() {
        switch central.state {
        case .poweredOn: break
        case .unsupported: onScanError?(BleError.unsupported)
        case .unauthorized: onScanError?(BleError.unauthorized)
        case .poweredOff:  onScanError?(BleError.poweredOff)
        default: break
        }
    }
    
    // MARK: - MAC 地址映射管理
    /// 加载已保存的设备 MAC 地址映射
    private func loadDeviceMacMapping() {
        deviceMacMapping = BleStorage.shared.loadDeviceMacMapping()
        #if DEBUG
        if deviceMacMapping.isEmpty {
            print("没有找到已保存的设备MAC映射")
        } else {
            print("加载已保存的设备MAC映射，共 \(deviceMacMapping.count) 条记录")
        }
        #endif
    }
    
    // MARK: - 发送绑定指令
    private func sendBindCommand() {
        guard let writeChar = writeCharacteristic,
              let peripheral = writeChar.service?.peripheral else {
            #if DEBUG
            print("写特征未准备好，无法发送绑定指令")
            #endif
            return
        }
        
        // 构建指令
        let commandString = "88dd1E00000000000000000000000000000000"
        
        // 计算 CRC 校验值
        let crc = DataConverter.calculateCRC(from: commandString)
        
        // 完整指令
        let fullCommand = commandString + crc
        
        // 转换为 Data
        let commandData = DataConverter.dataWithHexString(fullCommand)
        
        #if DEBUG
        print("发送绑定指令: \(fullCommand)")
        print("指令数据: \(commandData as NSData)")
        #endif
        
        // 写入数据
        peripheral.writeValue(commandData, for: writeChar, type: .withResponse)
    }
    
    // MARK: - 测试方法（fvc, vc, mvv）
    
    /// FVC 测试方法
    /// - Parameter onError: 错误回调
    internal func fvc(onError: @escaping (Error) -> Void) {
        sendTestCommand(command: "fvc", onError: onError)
    }
    
    /// VC 测试方法
    /// - Parameter onError: 错误回调
    internal func vc(onError: @escaping (Error) -> Void) {
        sendTestCommand(command: "vc", onError: onError)
    }
    
    /// MVV 测试方法
    /// - Parameter onError: 错误回调
    internal func mvv(onError: @escaping (Error) -> Void) {
        sendTestCommand(command: "mvv", onError: onError)
    }
    
    /// 发送测试命令的通用方法
    /// - Parameters:
    ///   - command: 命令字符串（如 "fvc", "vc", "mvv"）
    ///   - onError: 错误回调
    private func sendTestCommand(command: String, onError: @escaping (Error) -> Void) {
        guard let writeChar = writeCharacteristic else {
            onError(BleError.unknown)
            return
        }
        
        // 构建原始命令（这里需要根据实际协议调整）
        let commandHex = command.data(using: .utf8)?.map { String(format: "%02x", $0) }.joined() ?? ""
        
        // 发送命令（测试阶段使用固定密钥）
        sendCommandWithCrc(origin: commandHex, usePool: false, to: writeChar, onError: onError)
    }
    
    // MARK: - 发送命令（带 CRC 和加密）
    
    /// 发送带 CRC 的命令（支持加密）- 内部方法
    /// - Parameters:
    ///   - origin: 原始十六进制字符串
    ///   - usePool: 是否使用密钥池加密
    ///   - characteristic: 写入特征
    ///   - onError: 错误回调
    private func sendCommandWithCrc(origin: String, usePool: Bool, to characteristic: CBCharacteristic, onError: @escaping (Error) -> Void) {
        guard !origin.isEmpty else {
            onError(BleError.unknown)
            return
        }
        
        let payload = origin
        var cipher: String?
        
        if usePool {
            // 使用密钥池加密
            cipher = AESCBCUtil.encryptHexStringZeroPadding(payload, keyIndex: poolIndex)
            #if DEBUG
            print("发送密钥池加密命令: \(cipher ?? "加密失败")")
            #endif
        } else {
            // 测试阶段：先加 CRC，再固定密钥加密
            let payloadWithCRC = payload + DataConverter.calculateCRCFromHexString(payload)
            cipher = AESCBCUtil.encryptHexStringWithFixedKey(payloadWithCRC)
            #if DEBUG
            print("发送固定密钥命令: \(cipher ?? "加密失败")")
            #endif
        }
        
        guard let encryptedHex = cipher, !encryptedHex.isEmpty else {
            onError(BleError.unknown)
            return
        }
        
        // 转换为 Data
        let commandData = DataConverter.data(from: encryptedHex)
        
        // 写入数据
        write(data: commandData, to: characteristic, onError: onError)
    }
}

// MARK: Token
private final class Token: ScanToken {
    private var stopped = false
    private let stopper: () -> Void
    init(_ s: @escaping () -> Void) { stopper = s }
    func stop() {
        guard !stopped else { return }
        stopped = true; stopper()
    }
}

// MARK: CBCentralManagerDelegate
extension BleCentral: CBCentralManagerDelegate {
    internal func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn { beginScan() }
        else { reportStateErrorIfNeeded() }
    }

    internal func centralManager(_ central: CBCentralManager,
                               didDiscover peripheral: CBPeripheral,
                               advertisementData: [String : Any],
                               rssi RSSI: NSNumber) {
        if !scanFilter.allowDuplicates {
            guard !seen.contains(peripheral.identifier) else { return }
            seen.insert(peripheral.identifier)
        }
        
        // 判断设备名称是否为目标设备
        if BleDeviceNameFilter.shared.isTargetDevice(peripheral: peripheral) {
            #if DEBUG
            print("发现目标设备: \(peripheral.name ?? "nil")")
            #endif
            
            // 提取并保存 MAC 地址
            let deviceUUID = peripheral.identifier.uuidString
            
            // 先检查是否已有保存的 MAC 地址
            if let existingMacAddress = BleStorage.shared.getMacAddress(for: deviceUUID) {
                self.macAddress = existingMacAddress
                // 同步到本地缓存
                deviceMacMapping[deviceUUID] = existingMacAddress
                #if DEBUG
                print("使用已保存的MAC地址映射: \(deviceUUID) -> \(existingMacAddress)")
                #endif
            } else if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data {
                // 提取新的 MAC 地址
                self.macAddress = DataConverter.reversedHexString(from: manufacturerData)
                
                // 保存新的 MAC 地址映射
                if let mac = self.macAddress, !mac.isEmpty {
                    deviceMacMapping[deviceUUID] = mac
                    BleStorage.shared.saveMacAddress(mac, for: deviceUUID)
                    #if DEBUG
                    print("保存新的MAC地址映射: \(deviceUUID) -> \(mac)")
                    #endif
                }
            }
            
            onFound?(BleDevice(peripheral: peripheral, rssi: RSSI.intValue, macAddress: self.macAddress))
        }
    }

    internal func centralManager(_ central: CBCentralManager,
                               didConnect peripheral: CBPeripheral) {
        finishConnect(peripheral, with: .success(peripheral))
    }

    internal func centralManager(_ central: CBCentralManager,
                               didFailToConnect peripheral: CBPeripheral,
                               error: Error?) {
        finishConnect(peripheral, with: .failure(error ?? BleError.unknown))
    }

    internal func centralManager(_ central: CBCentralManager,
                               didDisconnectPeripheral peripheral: CBPeripheral,
                               error: Error?) {
        // 广播通知或回调给上层也行，这里简单处理
    }
}

// MARK: CBPeripheralDelegate
extension BleCentral: CBPeripheralDelegate {
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            #if DEBUG
            print("发现服务失败: \(error.localizedDescription)")
            #endif
            DiscoverContext.shared.handleDidDiscoverServices(peripheral, error: error)
            return
        }
        
        // 过滤目标服务 UUID "1000"
        guard let services = peripheral.services,
              let targetService = services.first(where: { $0.uuid == targetServiceUUID }) else {
            #if DEBUG
            print("未找到目标服务 UUID: 1000")
            #endif
            DiscoverContext.shared.handleDidDiscoverServices(peripheral, error: BleError.unknown)
            return
        }
        
        #if DEBUG
        print("找到目标服务: \(targetService.uuid)")
        #endif
        
        // 发现特征
        peripheral.discoverCharacteristics([writeCharUUID, notifyCharUUID], for: targetService)
        
        DiscoverContext.shared.handleDidDiscoverServices(peripheral, error: error)
    }

    internal func peripheral(_ peripheral: CBPeripheral,
                           didDiscoverCharacteristicsFor service: CBService,
                           error: Error?) {
        if let error = error {
            #if DEBUG
            print("发现特征失败: \(error.localizedDescription)")
            #endif
            DiscoverContext.shared.handleDidDiscoverChars(peripheral, service: service, error: error)
            return
        }
        
        guard let characteristics = service.characteristics else {
            DiscoverContext.shared.handleDidDiscoverChars(peripheral, service: service, error: error)
            return
        }
        
        // 查找写特征 "1001" 和通知特征 "1002"
        for characteristic in characteristics {
            if characteristic.uuid == writeCharUUID {
                writeCharacteristic = characteristic
                #if DEBUG
                print("找到写特征: \(characteristic.uuid)")
                #endif
            } else if characteristic.uuid == notifyCharUUID &&
                      characteristic.properties.contains(.notify) {
                notifyCharacteristic = characteristic
                #if DEBUG
                print("找到通知特征: \(characteristic.uuid)")
                #endif
                
                // 启用通知
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
        
        // 延迟 0.2 秒发送绑定指令
        if writeCharacteristic != nil {
            queue.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.sendBindCommand()
            }
        }
        
        DiscoverContext.shared.handleDidDiscoverChars(peripheral, service: service, error: error)
    }

    internal func peripheral(_ peripheral: CBPeripheral,
                           didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        WriteContext.shared.handleDidWrite(char: characteristic, error: error)
    }

    internal func peripheral(_ peripheral: CBPeripheral,
                           didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        NotifyContext.shared.handleDidSetNotify(char: characteristic, error: error)
    }

    internal func peripheral(_ peripheral: CBPeripheral,
                           didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            valueHandlers[characteristic.uuid]?(.failure(error))
            valueHandlers[characteristic.uuid] = nil
            return
        }
        guard let data = characteristic.value else { return }
        
        // 先将 data 转为 string
        let dataString = (data as NSData).hexString()
        
        // 主动 read 的回调
        if let handler = valueHandlers[characteristic.uuid] {
            handler(.success(dataString))
            valueHandlers[characteristic.uuid] = nil
        }
        // 通知（notify）回调
        if let handler = notifyHandlers[characteristic.uuid] {
            handler(dataString)
        }
    }
}

// MARK: Small Context Helpers
private final class DiscoverContext {
    static let shared = DiscoverContext()
    private struct Expect {
        var wantServices: Set<CBUUID>
        var wantChars: Set<CBUUID>
        var foundChars: [CBCharacteristic] = []
        var onReady: ([CBCharacteristic]) -> Void
        var onError: (Error) -> Void
    }
    private var map: [UUID: Expect] = [:]

    func setExpectation(periph: CBPeripheral,
                        targetServiceUUIDs: Set<CBUUID>,
                        targetCharUUIDs: Set<CBUUID>,
                        onReady: @escaping ([CBCharacteristic]) -> Void,
                        onError: @escaping (Error) -> Void) {
        map[periph.identifier] = Expect(wantServices: targetServiceUUIDs,
                                        wantChars: targetCharUUIDs,
                                        foundChars: [],
                                        onReady: onReady, onError: onError)
    }

    func handleDidDiscoverServices(_ p: CBPeripheral, error: Error?) {
        guard var exp = map[p.identifier] else { return }
        if let error = error { exp.onError(error); map[p.identifier] = nil; return }

        let target = exp.wantServices
        for s in p.services ?? [] where target.isEmpty || target.contains(s.uuid) {
            p.discoverCharacteristics(Array(exp.wantChars), for: s)
        }
        map[p.identifier] = exp
    }

    func handleDidDiscoverChars(_ p: CBPeripheral, service: CBService, error: Error?) {
        guard var exp = map[p.identifier] else { return }
        if let error = error { exp.onError(error); map[p.identifier] = nil; return }

        let chars = service.characteristics ?? []
        for c in chars where exp.wantChars.isEmpty || exp.wantChars.contains(c.uuid) {
            exp.foundChars.append(c)
        }
        // 当已找到目标特征数量达到目标集合大小时回调
        if !exp.wantChars.isEmpty && Set(exp.foundChars.map { $0.uuid }).isSuperset(of: exp.wantChars) {
            exp.onReady(exp.foundChars)
            map[p.identifier] = nil
        } else if exp.wantChars.isEmpty {
            // 没指定特征则直接全部返回
            exp.onReady(chars)
            map[p.identifier] = nil
        } else {
            map[p.identifier] = exp
        }
    }
}

private final class WriteContext {
    static let shared = WriteContext()
    private var map: [CBUUID: (Error) -> Void] = [:]
    func remember(char: CBCharacteristic, onError: @escaping (Error) -> Void) { map[char.uuid] = onError }
    func handleDidWrite(char: CBCharacteristic, error: Error?) {
        if let error = error { map[char.uuid]?(error) }
        map[char.uuid] = nil
    }
}

private final class NotifyContext {
    static let shared = NotifyContext()
    private var map: [CBUUID: (Error) -> Void] = [:]
    func remember(char: CBCharacteristic, onError: @escaping (Error) -> Void) { map[char.uuid] = onError }
    func handleDidSetNotify(char: CBCharacteristic, error: Error?) {
        if let error = error { map[char.uuid]?(error) }
        map[char.uuid] = nil
    }
}
