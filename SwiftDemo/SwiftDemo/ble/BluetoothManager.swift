//
//  BluetoothManager.swift
//  SwiftDemo
//
//  Created by app on 2025/8/11.
//

import Foundation
import CoreBluetooth
import Combine

public final class BluetoothManager: NSObject {
    // Singleton
    public static let shared = BluetoothManager()
    // 1) 在类里新增一个开关（默认关闭，避免崩溃）
    public var allowStateRestoration: Bool = true
    // Delegate
    public weak var delegate: BluetoothManagerDelegate?
    // Config
    public var scanFilter = BLEScanFilter()
    public var timeouts = BLETimeouts()
    public var autoReconnect = true
    public var restoreIdentifier = "com.ble.combine.delegate.restore"
    // State
    public private(set) var central: CBCentralManager!
    public private(set) var connectedPeripheral: CBPeripheral?
    @Published public private(set) var isScanning = false
    
    // Cache
    private var discoveredCache = [UUID: CBPeripheral]()
    private let defaults = UserDefaults.standard
    private let savedKey = "BluetoothManager.saved.peripheral"
    
    // Timers
    private var connectTimer: Timer?
    private var interrogateTimer: Timer?
    
    // Queue
    private let centralQueue = DispatchQueue(label: "com.ble.combine.delegate.central")
    
    // Check for Info.plist support
    private var isBackgroundRestoreSupported: Bool {
        guard let backgroundModes = Bundle.main.infoDictionary?["UIBackgroundModes"] as? [String] else { return false }
        return backgroundModes.contains("bluetooth-central")
    }
    // MARK: Combine Publishers（新项目可用）
    
    public let statePublisher = CurrentValueSubject<CBManagerState, Never>(.unknown)            /// 中心状态流
    public let discoveredPublisher = PassthroughSubject<DiscoveredPeripheral, Never>()          /// 发现外设流
    public let connectedPublisher = PassthroughSubject<CBPeripheral, Never>()                   /// 连接成功流
    public let failedToConnectPublisher = PassthroughSubject<(CBPeripheral, Error?), Never>()   /// 连接失败流
    public let disconnectedPublisher = PassthroughSubject<(CBPeripheral, Error?), Never>()      /// 断开连接流
    public let restoredPublisher = PassthroughSubject<[CBPeripheral], Never>()                  /// 状态恢复流
    
    public let servicesDiscoveredPublisher = PassthroughSubject<CBPeripheral, Never>()          /// 服务发现完成流
    public let characteristicsDiscoveredPublisher = PassthroughSubject<CBService, Never>()      /// 特征发现完成流
    public let valueUpdatePublisher = PassthroughSubject<(CBCharacteristic, Error?), Never>()   /// 特征值更新/通知流
    public let writeAckPublisher = PassthroughSubject<(CBCharacteristic, Error?), Never>()      /// 写入回执流
    public let notifyUpdatePublisher = PassthroughSubject<(CBCharacteristic, Error?), Never>()  /// 通知状态变更流
    ///
    /// // Lifecycle
    private override init() {
        super.init()
        var options: [String: Any] = [
            CBCentralManagerOptionShowPowerAlertKey: true
        ]
        if allowStateRestoration && isBackgroundRestoreSupported {
            options[CBCentralManagerOptionRestoreIdentifierKey] = restoreIdentifier
        }
        central = CBCentralManager(delegate: self, queue: centralQueue, options: options)
    }
    
    
    // 4) （可选）提供一个在运行期切换的入口（若需要动态开启，再重建 central）
    public func enableStateRestoration(_ enabled: Bool) {
        allowStateRestoration = enabled
        var options: [String: Any] = [CBCentralManagerOptionShowPowerAlertKey: true]
        if enabled && isBackgroundRestoreSupported { options[CBCentralManagerOptionRestoreIdentifierKey] = restoreIdentifier }
        central = CBCentralManager(delegate: self, queue: centralQueue, options: options)
    }
    
    // MARK: Scan
    
    public func startScan(filter: BLEScanFilter? = nil) {
        guard central.state == .poweredOn else { return }
        let f = filter ?? scanFilter
        let opts: [String: Any] = [CBCentralManagerScanOptionAllowDuplicatesKey: f.allowDuplicates]
        central.scanForPeripherals(withServices: f.services, options: opts)
        isScanning = true
        main { self.delegate?.didStartScanning() }
    }
    
    public func stopScan() {
        central.stopScan()
        isScanning = false
        main { self.delegate?.didStopScanning() }
    }
    
    // MARK: Connect / Disconnect
    
    public func connect(_ peripheral: CBPeripheral, timeout: TimeInterval? = nil) {
        guard central.state == .poweredOn else { return }
        central.connect(peripheral, options: [CBConnectPeripheralOptionNotifyOnDisconnectionKey: true])
        scheduleConnectTimeout(peripheral, timeout ?? timeouts.connect)
    }
    
    public func connect(identifiedBy uuid: UUID, timeout: TimeInterval? = nil) {
        let known = central.retrievePeripherals(withIdentifiers: [uuid])
        if let p = known.first { connect(p, timeout: timeout); return }
        if let services = scanFilter.services, !services.isEmpty {
            let connected = central.retrieveConnectedPeripherals(withServices: services)
            if let p = connected.first(where: { $0.identifier == uuid }) { connect(p, timeout: timeout) }
        }
    }
    
    public func disconnect() {
        guard let p = connectedPeripheral else { return }
        central.cancelPeripheralConnection(p)
    }
    
    public func saveCurrentPeripheralForAutoReconnect() {
        if let id = connectedPeripheral?.identifier { defaults.set(id.uuidString, forKey: savedKey) }
    }
    
    public func clearSavedPeripheral() { defaults.removeObject(forKey: savedKey) }
    
    // MARK: Discovery
    
    public func discoverServices(_ services: [CBUUID]? = nil) throws {
        guard let p = connectedPeripheral else { throw BLEError.noPeripheral }
        p.discoverServices(services)
        scheduleInterrogateTimeout(p, timeouts.interrogate)
    }
    
    public func discoverCharacteristics(_ characteristicUUIDs: [CBUUID]? = nil, for serviceUUID: CBUUID) throws {
        guard let p = connectedPeripheral else { throw BLEError.noPeripheral }
        guard let srv = p.service(serviceUUID) else { throw BLEError.serviceNotFound(serviceUUID) }
        p.discoverCharacteristics(characteristicUUIDs, for: srv)
    }
    
    // MARK: Read / Write / Notify
    
    public func readValue(for characteristicUUID: CBUUID, in serviceUUID: CBUUID) throws {
        guard let p = connectedPeripheral else { throw BLEError.noPeripheral }
        guard let ch = p.characteristic(characteristicUUID, in: serviceUUID) else {
            throw BLEError.characteristicNotFound(characteristicUUID)
        }
        p.readValue(for: ch)
    }
    
    public func write(_ data: Data,
                      to characteristicUUID: CBUUID,
                      in serviceUUID: CBUUID,
                      type: CBCharacteristicWriteType = .withResponse) throws {
        guard let p = connectedPeripheral else { throw BLEError.noPeripheral }
        guard let ch = p.characteristic(characteristicUUID, in: serviceUUID) else {
            throw BLEError.characteristicNotFound(characteristicUUID)
        }
        let maxLen = p.maximumWriteValueLength(for: type)
        guard data.count <= maxLen else { throw BLEError.writeTooLong(maxLen) }
        p.writeValue(data, for: ch, type: type)
    }
    
    public func setNotify(_ enabled: Bool,
                          for characteristicUUID: CBUUID,
                          in serviceUUID: CBUUID) throws {
        guard let p = connectedPeripheral else { throw BLEError.noPeripheral }
        guard let ch = p.characteristic(characteristicUUID, in: serviceUUID) else {
            throw BLEError.characteristicNotFound(characteristicUUID)
        }
        p.setNotifyValue(enabled, for: ch)
    }
    
    public func maximumWriteLength(withResponse: Bool) throws -> Int {
        guard let p = connectedPeripheral else { throw BLEError.noPeripheral }
        return p.maximumWriteValueLength(for: withResponse ? .withResponse : .withoutResponse)
    }
    
    // MARK: Utilities
    
    public func peripheral(for identifier: UUID) -> CBPeripheral? {
        discoveredCache[identifier] ?? central.retrievePeripherals(withIdentifiers: [identifier]).first
    }
    
    public func allDiscoveredPeripherals() -> [CBPeripheral] { Array(discoveredCache.values) }
    
    public func reset() {
        stopScan()
        if let p = connectedPeripheral { central.cancelPeripheralConnection(p) }
        connectedPeripheral = nil
        discoveredCache.removeAll()
        invalidate(&connectTimer)
        invalidate(&interrogateTimer)
    }
    
    // MARK: Private
    
    private func scheduleConnectTimeout(_ peripheral: CBPeripheral, _ interval: TimeInterval) {
        main {
            self.invalidate(&self.connectTimer)
            self.connectTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
                guard let self else { return }
                self.central.cancelPeripheralConnection(peripheral)
                self.connectedPublisher.send(completion: .finished) // 结束可能的上层等待
                self.delegate?.didTimeoutConnect(peripheral) /// 连接超时回调
            }
        }
    }
    
    private func scheduleInterrogateTimeout(_ peripheral: CBPeripheral, _ interval: TimeInterval) {
        main {
            self.invalidate(&self.interrogateTimer)
            self.interrogateTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
                guard let self else { return }
                self.central.cancelPeripheralConnection(peripheral)
                self.delegate?.didTimeoutInterrogate(peripheral) /// 探测超时回调
            }
        }
    }
    
    private func invalidate(_ timer: inout Timer?) {
        timer?.invalidate()
        timer = nil
    }
    
    private func tryAutoReconnect() {
        guard autoReconnect,
              let saved = defaults.string(forKey: savedKey),
              let uuid = UUID(uuidString: saved) else { return }
        connect(identifiedBy: uuid, timeout: timeouts.connect)
    }
    
    private func main(_ block: @escaping () -> Void) {
        if Thread.isMainThread { block() } else { DispatchQueue.main.async { block() } }
    }
}



// MARK: - CBCentralManagerDelegate

extension BluetoothManager: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        statePublisher.send(central.state)
        main { self.delegate?.didUpdateState(central.state) } /// 中心状态变更
        if central.state == .poweredOn {
            tryAutoReconnect()
        } else {
            stopScan()
        }
    }
    
    public func centralManager(_ central: CBCentralManager,
                               willRestoreState dict: [String : Any]) {
        guard allowStateRestoration else { return }
        let peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral] ?? []
        peripherals.forEach { p in
            discoveredCache[p.identifier] = p
            p.delegate = self
        }
        restoredPublisher.send(peripherals)
        main { self.delegate?.didRestore(peripherals) } /// 状态恢复
    }
    
    public func centralManager(_ central: CBCentralManager,
                               didDiscover peripheral: CBPeripheral,
                               advertisementData: [String : Any],
                               rssi RSSI: NSNumber) {
        discoveredCache[peripheral.identifier] = peripheral
        
        // 更新后的过滤逻辑
        if let prefix = scanFilter.namePrefix {
            // 如果设置了名称过滤器（即使是空字符串），也要求设备必须有非空名称
            guard let name = peripheral.name, !name.isEmpty else {
                return
            }
            // 如果前缀不是空字符串，则进一步要求名称必须以此为前缀
            if !prefix.isEmpty && !name.hasPrefix(prefix) {
                return
            }
        }
        
        if let min = scanFilter.rssiMin,
           RSSI.intValue < min { return }
        // 创建 DiscoveredPeripheral 实例
        var discovered = DiscoveredPeripheral(peripheral: peripheral, adv: advertisementData, rssi: RSSI)
        // 检查此设备是否为当前已连接的设备
        if peripheral.identifier == self.connectedPeripheral?.identifier {
            discovered.isConnected = true
        }
        // [!BUG修复!] 之前这里创建了新的实例，导致 isConnected 状态丢失
        discoveredPublisher.send(discovered)
        main { self.delegate?.didDiscover(peripheral, adv: advertisementData, rssi: RSSI) } /// 发现外设
    }
    
    public func centralManager(_ central: CBCentralManager,
                               didConnect peripheral: CBPeripheral) {
        invalidate(&connectTimer)
        connectedPeripheral = peripheral
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        scheduleInterrogateTimeout(peripheral, timeouts.interrogate)
        stopScan()
        connectedPublisher.send(peripheral)
        main {
            self.delegate?.didConnect(peripheral) /// 已连接
            self.saveCurrentPeripheralForAutoReconnect()
        }
    }
    
    public func centralManager(_ central: CBCentralManager,
                               didFailToConnect peripheral: CBPeripheral,
                               error: Error?) {
        invalidate(&connectTimer)
        failedToConnectPublisher.send((peripheral, error))
        main { self.delegate?.didFailToConnect(peripheral, error: error) } /// 连接失败
    }
    
    public func centralManager(_ central: CBCentralManager,
                               didDisconnectPeripheral peripheral: CBPeripheral,
                               error: Error?) {
        invalidate(&interrogateTimer)
        if connectedPeripheral?.identifier == peripheral.identifier {
            connectedPeripheral = nil
        }
        disconnectedPublisher.send((peripheral, error))
        main { self.delegate?.didDisconnect(peripheral, error: error) } /// 断开连接
        if autoReconnect { tryAutoReconnect() }
    }
    
    @available(iOS 13.0, *)
    public func centralManager(_ central: CBCentralManager,
                               didUpdateANCSAuthorizationFor peripheral: CBPeripheral) {
        // iOS 13+ ANCS 授权变化（可按需上抛）
    }
}
// MARK: - CBPeripheralDelegate

extension BluetoothManager: CBPeripheralDelegate {
    public func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        // 外设名称变更（可按需上抛）
    }
    
    public func peripheral(_ peripheral: CBPeripheral,
                           didDiscoverServices error: Error?) {
        if error == nil { invalidate(&interrogateTimer) }
        servicesDiscoveredPublisher.send(peripheral)
        main { self.delegate?.didDiscoverServices(peripheral) } /// 服务发现完成
    }
    
    public func peripheral(_ peripheral: CBPeripheral,
                           didDiscoverCharacteristicsFor service: CBService,
                           error: Error?) {
        characteristicsDiscoveredPublisher.send(service)
        main { self.delegate?.didDiscoverCharacteristics(service) } /// 特征发现完成
    }
    
    public func peripheral(_ peripheral: CBPeripheral,
                           didUpdateValueFor characteristic: CBCharacteristic,
                           error: Error?) {
        valueUpdatePublisher.send((characteristic, error))
        main { self.delegate?.didUpdateValue(characteristic, error: error) } /// 收到特征值
    }
    
    public func peripheral(_ peripheral: CBPeripheral,
                           didWriteValueFor characteristic: CBCharacteristic,
                           error: Error?) {
        writeAckPublisher.send((characteristic, error))
        main { self.delegate?.didWriteValue(characteristic, error: error) } /// 写入回执
    }
    
    public func peripheral(_ peripheral: CBPeripheral,
                           didUpdateNotificationStateFor characteristic: CBCharacteristic,
                           error: Error?) {
        notifyUpdatePublisher.send((characteristic, error))
        main { self.delegate?.didUpdateNotification(characteristic, error: error) } /// 通知状态变更
    }
    
    public func peripheral(_ peripheral: CBPeripheral,
                           didDiscoverDescriptorsFor characteristic: CBCharacteristic,
                           error: Error?) {
        // 发现描述符（可按需上抛）
    }
    
    public func peripheral(_ peripheral: CBPeripheral,
                           didUpdateValueFor descriptor: CBDescriptor,
                           error: Error?) {
        // 描述符值更新（可按需上抛）
    }
    
    @available(iOS 11.0, *)
    public func peripheral(_ peripheral: CBPeripheral,
                           didOpen channel: CBL2CAPChannel?,
                           error: Error?) {
        // L2CAP 打开（可按需上抛）
    }
}
