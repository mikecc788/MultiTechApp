//
//  BluetoothManager.swift
//  iBreath-X
//
//  Created by app on 2024/9/4.
//

import CoreBluetooth
class BluetoothManager: NSObject,CBCentralManagerDelegate,CBPeripheralDelegate,ObservableObject {
    @Published var isBluetoothEnabled = false
    @Published var discoveredPeripherals = [DiscoveredPeripheral]()
    @Published var connectedUUID :UUID?
    @Published var isConnecting = false
    private var centralManager: CBCentralManager!
    let peripheralsManager = PeripheralsManager.shared
    
    /** 也可以使用shared方法 操作更简单
     
     */
    static let shared = BluetoothManager()
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScanning() {
        print("startScanning")
        isConnecting = false
        if centralManager.state == .poweredOn {
            discoveredPeripherals.removeAll()
//            centralManager.scanForPeripherals(withServices: [CBUUID(string: "YOUR_SERVICE_UUID")])
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
        
    }
    
    func stopScanning(){
        print("stopScanning")
        centralManager.stopScan()
    }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            case .unknown, .resetting, .unsupported, .unauthorized, .poweredOff:
                stopScanning()
                isBluetoothEnabled = false
            case .poweredOn:
                isBluetoothEnabled = true
                startScanning()
            @unknown default:
                print("central.state is unknown")
        }
    
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
       if peripheral == peripheralsManager.connectedPeripheral?.peripheral {
           peripheralsManager.disconnect()
           //Logic method
//           stopUpdatingSensorData()
           print("Disconnected from \(peripheral.name ?? "Unknown Device")")
           startScanning()
       }
   }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let advertisedData = advertisementData.map { "\($0): \($1)" }.sorted(by: { $0 < $1 }).joined(separator: "\n")
        let newPer = DiscoveredPeripheral(peripheral: peripheral, advertisedData: advertisedData)
        
        if !discoveredPeripherals.contains(where: {$0.peripheral == peripheral}) {
           if let name = peripheral.name,!name.isEmpty {
               discoveredPeripherals.append(newPer)
           }
           
        }
    }
    
    func connect(to peripheral:CBPeripheral){
        isConnecting = true
        centralManager.stopScan()
        centralManager.connect(peripheral,options: nil)
    }
    
    func disconnectFromPeripheral() {
       guard let peripheral = peripheralsManager.connectedPeripheral?.peripheral else { return }
       centralManager.cancelPeripheralConnection(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
        peripheral.readRSSI()
        peripheral.delegate = self
        peripheralsManager.connectedPeripheral = discoveredPeripherals.first(where: { $0.peripheral == peripheral })
        isConnecting = false
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else { return }
        if let services = peripheral.services{
            for service in services{
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        guard error == nil else { return }
        for characteristic in service.characteristics! {
            if characteristic.uuid == CBUUID(string: "BEEF") {
                
//                startUpdatingSensorData()
            }
            if characteristic.uuid == CBUUID(string: "CAFE") {
                peripheralsManager.connectedPeripheral?.locationCharacteristic = characteristic
            }
            if characteristic.uuid == CBUUID(string: "1001") {
                peripheralsManager.connectedPeripheral?.atomizerCha = characteristic
//                startUpdatingSensorData()
            }
         }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        if let error = error {
            print("Failed to write value: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.peripheralsManager.connectedPeripheral?.writeSuccess = false
            }
        } else {
            print("Successfully wrote value to characteristic \(characteristic.uuid)")
            DispatchQueue.main.async {
                self.peripheralsManager.connectedPeripheral?.writeSuccess = true
            }
         }
        peripheralsManager.connectedPeripheral?.isWritePending = false
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else { return }
        if characteristic == peripheralsManager.connectedPeripheral?.atomizerCha,
           let data = characteristic.value {
//            let sensorData = parseSensorData(data)
            print("data=\(data)")
            DispatchQueue.main.async {
//                self.peripheralsManager.connectedPeripheral?.atomizerCha = sensorData
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: (any Error)?) {
        guard error == nil else {
            print("Error reading RSSI: \(error!.localizedDescription)")
            return
        }
        DispatchQueue.main.async {
            self.peripheralsManager.connectedPeripheral?.rssi = Int(truncating: RSSI)
        }
        print("RSSI: \(RSSI)")
    }
    
    func toggleBluetooth() {
        if centralManager.state == .poweredOn {
            centralManager.stopScan()
            centralManager = nil
        } else {
            centralManager = CBCentralManager(delegate: self, queue: nil)
        }
    }
    
    func sendData(to peripheral: CBPeripheral, data: Data) {
//        peripheral.writeValue(data, for: CBCharacteristicUUID(string: "YOUR_CHARACTERISTIC_UUID"), type: .withoutResponse)
    }
    
    
}
