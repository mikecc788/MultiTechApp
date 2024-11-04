//
//  BLEManager.swift
//  SwiftDemo
//
//  Created by app on 2022/3/3.
//

import Foundation
import CoreBluetooth

class BLEManager:NSObject{
    // MARK: - Singleton
    static let shared = BLEManager()
    
    // MARK: - Properties
    private var centralManager : CBCentralManager!
    weak var delegate : BLEManagerDelegate?{
        didSet {
                print("Delegate set to: \(String(describing: delegate))")
            }
    }
    private var connectedPeripheral : CBPeripheral?
    private var characteristics: [CBUUID: CBCharacteristic] = [:]
    private var scanTimer: Timer?
    
    private(set) var connected = false
    
    // 配置
    private let scanTimeout: TimeInterval = 10.0
    private var shouldScanAfterPoweredOn = false
    private var isScanning = false
    
    private let serviceUUID = CBUUID(string: "AE00")
    private let characteristicUUIDs = [
           CBUUID(string: "AE01"),
           CBUUID(string: "AE02"),
           CBUUID(string: "1001"),
           CBUUID(string: "1002")
    ]
    // 已发现的设备缓存
    private var discoveredDevices: [UUID: BLEDeviceModel] = [:]
    private let deviceUpdateThreshold: TimeInterval = 5.0 // 设备更新阈值
    
    // 连接配置
    private let connectionTimeout: TimeInterval = 5.0
    private var connectionTimer: Timer?
    
    private var isConnecting = false
    private(set) var connectedServices : [CBService]?
    
    // MARK: - Initialization
    private override init() {
        super.init()
        initCBCentralManager()
    }
    
    func initCBCentralManager() {
        centralManager = CBCentralManager(delegate: self, queue: nil,options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }
    
    // MARK: - Public Methods
    func startScanning(withServices services: [CBUUID]? = nil) {
        guard centralManager.state == .poweredOn else {
            shouldScanAfterPoweredOn = true
            return
        }
        
        if isScanning {
            stopScanning()
        }
        discoveredDevices.removeAll()
        isScanning = true
        let options: [String: Any] = [
            CBCentralManagerScanOptionAllowDuplicatesKey: true
        ]
        centralManager.scanForPeripherals(
            withServices: services,
            options: options
        )
        if let delegate = delegate {
            print("Delegate exists, calling didStartScan")
            delegate.bleManagerDidStartScan?()
        } else {
            print("No delegate set")
        }
        
        setupScanTimer() // 设置扫描超时
       
    }
    private func setupScanTimer() {
       
        scanTimer?.invalidate()
        scanTimer = Timer.scheduledTimer(withTimeInterval: scanTimeout, repeats: false) { [weak self] _ in
            self?.stopScanning()
        }
    }
    private func setupConnectionTimer() {
        connectionTimer?.invalidate()
        connectionTimer = Timer.scheduledTimer(withTimeInterval: connectionTimeout, repeats: false) { [weak self] _ in
            if let peripheral = self?.connectedPeripheral {
                self?.centralManager.cancelPeripheralConnection(peripheral)
            }
        }
    }
    
    private func updateDevice(_ peripheral: CBPeripheral, advertisementData: [String: Any], rssi: NSNumber) {
           let device = BLEDeviceModel(
               peripheral: peripheral,
               advertisementData: advertisementData,
               rssi: rssi,
               lastUpdatedTime: Date()
           )
           
           // 更新设备信息
           if let existingDevice = discoveredDevices[peripheral.identifier] {
               // 仅在信号强度变化超过阈值或超过更新时间时更新
               let timeSinceLastUpdate = device.lastUpdatedTime.timeIntervalSince(existingDevice.lastUpdatedTime)
               let rssiDifference = abs(existingDevice.rssi.intValue - rssi.intValue)
               
               if timeSinceLastUpdate >= deviceUpdateThreshold || rssiDifference >= 5 {
                   discoveredDevices[peripheral.identifier] = device
                   delegate?.bleManagerDidUpdateDevices?(discoveredDevicesList)
               }
           } else {
               // 新设备直接添加
               discoveredDevices[peripheral.identifier] = device
               delegate?.bleManagerDidUpdateDevices?(discoveredDevicesList)
           }
       }
    
    
    /**
     The method provides for stopping scan near by peripheral
     */
    func stopScanning() {
        guard isScanning else {
            return
        }
        centralManager?.stopScan()
        scanTimer?.invalidate()
        scanTimer = nil
        isScanning = false
        shouldScanAfterPoweredOn = false
        delegate?.bleManagerDidStopScan?()
    }
    /// 刷新扫描
    func refreshScan() {
        startScanning()
    }
  
    /// 连接设备
    func connect(_ peripheral: CBPeripheral) {
        // 如果正在扫描，停止扫描
        stopScanning()
        connectedPeripheral = peripheral
        centralManager.connect(peripheral, options: nil)
        setupConnectionTimer()
    }
    
    /// 断开连接
    func disconnect() {
        guard let peripheral = connectedPeripheral else { return }
        centralManager.cancelPeripheralConnection(peripheral)
    }
    /// 发现服务
   func discoverServices(_ services: [CBUUID]? = nil) {
       connectedPeripheral?.discoverServices(services)
   }
    /// 发现特征
    func discoverCharacteristics(_ characteristics: [CBUUID]? = nil, for service: CBService) {
        connectedPeripheral?.discoverCharacteristics(characteristics, for: service)
    }
    
    /// 写入数据
    func writeData(_ data: Data, for characteristic: CBCharacteristic,type: CBCharacteristicWriteType = .withResponse) {
        connectedPeripheral?.writeValue(data, for: characteristic, type: type)
    }
    /// 读取数据
    func readValue(from characteristicUUID: CBUUID) {
        guard let characteristic = characteristics[characteristicUUID] else { return }
        connectedPeripheral?.readValue(for: characteristic)
    }
    
    /// 订阅通知
    func setNotifyValue(_ enabled: Bool, for characteristic: CBCharacteristic) {
        connectedPeripheral?.setNotifyValue(enabled, for: characteristic)
    }
    
    /// 取消订阅
    func unsubscribe(from characteristicUUID: CBUUID) {
        guard let characteristic = characteristics[characteristicUUID] else { return }
        connectedPeripheral?.setNotifyValue(false, for: characteristic)
    }
    
    /// 检查是否正在扫描
    var isCurrentlyScanning: Bool {
        return isScanning
    }
    
    /// 检查蓝牙是否可用
    var isBluetoothAvailable: Bool {
        return centralManager.state == .poweredOn
    }
    
    // MARK: - Status Methods
    var discoveredDevicesList: [BLEDeviceModel] {
        Array(discoveredDevices.values).sorted { $0.rssi.intValue > $1.rssi.intValue }
    }
    /// 获取当前连接的设备
    var currentDevice: CBPeripheral? {
        return connectedPeripheral
    }
}
extension BLEManager:CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if #available(iOS 10.0, *) {
            
            switch central.state {
            case .poweredOff:
                stopScanning()
                if let peripheral = connectedPeripheral {
                    centralManager.cancelPeripheralConnection(peripheral)
                }
            case .poweredOn:
                if shouldScanAfterPoweredOn {
                    startScanning()
                }
            case .resetting:
                print("State : Resetting")
            case .unauthorized:
                print("State : Unauthorized")
            case .unknown:
                print("State : Unknown")
            case .unsupported:
                print("State : Unsupported")
            @unknown default:
                print("fail")
            }
            delegate?.bleManagerDidUpdateState?(central.state)
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Bluetooth Manager --> didDiscoverPeripheral, RSSI:\(RSSI)")
        updateDevice(peripheral, advertisementData: advertisementData, rssi: RSSI)
//        delegate?.bleManagerDidUpdateDevices?(discoveredDevices)
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectionTimer?.invalidate()
        connectionTimer = nil
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        delegate?.bleManagerDidConnect?(peripheral)
       }
       
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
       characteristics.removeAll()
       connectedPeripheral = nil
        delegate?.bleManagerDidDisconnect?(peripheral, error: error)
    }
   
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        connectionTimer?.invalidate()
        connectionTimer = nil
        connectedPeripheral = nil
        delegate?.bleManagerDidFailToConnect?(peripheral, error: error!)
    }
    
    
}
// MARK: - CBPeripheralDelegate
extension BLEManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil, let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(characteristicUUIDs, for: service)
            delegate?.bleManagerDidDiscoverServices?(services)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil, let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            self.characteristics[characteristic.uuid] = characteristic
            delegate?.bleManagerDidDiscoverCharacteristics?(characteristics, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil, let data = characteristic.value else { return }
        delegate?.bleManagerDidUpdateValue?(data, for: characteristic)
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        delegate?.bleManagerDidWriteValue?(for: characteristic, error: error)
    }
}



