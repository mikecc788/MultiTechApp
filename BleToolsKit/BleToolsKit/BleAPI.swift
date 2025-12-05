//
//  BleAPI.swift
//  BleToolsKit
//
//  蓝牙SDK - 极简API接口（仅暴露3个方法）
//

import Foundation
import CoreBluetooth

/// 蓝牙SDK - 仅对外暴露3个核心接口
public final class BleAPI {
    
    // MARK: - 单例
    public static let shared = BleAPI()
    
    // MARK: - 配置（使用前设置）
    
    /// 连接超时时间（秒），默认10秒
    public var timeout: TimeInterval = 10
    
    // MARK: - 回调（使用前设置）
    
    /// 扫描到设备回调 (设备ID, 设备名, 信号强度)
    public var onDeviceFound: ((String, String, Int) -> Void)?
    
    /// 连接成功回调
    public var onConnected: (() -> Void)?
    
    /// 收到数据回调 (十六进制字符串)
    public var onDataReceived: ((String) -> Void)?
    
    /// 错误回调
    public var onError: ((String) -> Void)?
    
    // MARK: - 内部状态（外部不可见）
    private let central = BleCentral.shared
    private var scanToken: ScanToken?
    private var scannedDevices: [String: BleDevice] = [:]
    private var currentDeviceId: String?
    private var currentPeripheral: CBPeripheral?
    private var characteristics: [CBCharacteristic] = []
    
    private init() {}
    
    // MARK: - ⭐️ 对外公开的三个核心接口 ⭐️
    
    /// 1️⃣ 扫描设备
    public func scan() {
        scanToken?.stop()
        scannedDevices.removeAll()
        
        let filter = BleFilter(serviceUUIDs: nil, allowDuplicates: false)
        
        scanToken = central.startScan(filter: filter) { [weak self] device in
            guard let self = self else { return }
            self.scannedDevices[device.identifier] = device
            self.onDeviceFound?(device.identifier, device.name, device.rssi)
        } onError: { [weak self] error in
            self?.onError?(error.localizedDescription)
        }
    }
    
    /// 2️⃣ 连接设备（传入扫描回调中的设备ID）
    public func connect(deviceId: String) {
        guard let device = scannedDevices[deviceId] else {
            onError?("设备未找到，请先扫描")
            return
        }
        
        scanToken?.stop()
        currentDeviceId = deviceId
        
        // 使用硬编码的服务和特征 UUID: "1000", "1001", "1002"
        let services = [CBUUID(string: "1000")]
        let chars = [CBUUID(string: "1001"), CBUUID(string: "1002")]
        
        central.connect(device, timeout: timeout) { [weak self] peripheral in
            guard let self = self else { return }
            self.currentPeripheral = peripheral
            
            self.central.discoverCharacteristics(
                for: peripheral,
                serviceUUIDs: services,
                characteristicUUIDs: chars
            ) { [weak self] foundChars in
                guard let self = self else { return }
                self.characteristics = foundChars
                
                // 自动订阅所有支持通知的特征
                for char in foundChars where char.properties.contains(.notify) {
                    self.central.setNotify(true, for: char, onUpdate: { [weak self] hexString in
                        self?.onDataReceived?(hexString)
                    }, onError: { _ in })
                }
                
                self.onConnected?()
            } onError: { [weak self] error in
                self?.onError?("发现服务失败: \(error.localizedDescription)")
            }
        } onError: { [weak self] error in
            self?.onError?("连接失败: \(error.localizedDescription)")
        }
    }
    
    /// 3️⃣ 发送数据（十六进制字符串，如 "0102FF"）
    public func send(_ hexString: String) {
        guard !characteristics.isEmpty else {
            onError?("未连接或未发现特征")
            return
        }
        
        guard let data = BleDataConverter.hexStringToData(hexString) else {
            onError?("数据格式错误")
            return
        }
        
        guard let writeChar = characteristics.first(where: {
            $0.properties.contains(.write) || $0.properties.contains(.writeWithoutResponse)
        }) else {
            onError?("未找到可写特征")
            return
        }
        
        central.write(data: data, to: writeChar) { [weak self] error in
            self?.onError?("发送失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 辅助方法（外部不可见）
    
    /// 停止扫描（可选暴露）
    public func stopScan() {
        scanToken?.stop()
    }
    
    /// 断开连接（可选暴露）
    public func disconnect() {
        if let peripheral = currentPeripheral {
            central.disconnect(peripheral)
        }
        currentPeripheral = nil
        currentDeviceId = nil
        characteristics.removeAll()
    }
}

// MARK: - 内部工具扩展（保持向后兼容，已移至 BleDataConverter）
