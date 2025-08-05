//
//  File.swift
//  BluetoothKit
//
//  Created by app on 2025/8/4.
//

import CoreBluetooth

public protocol BluetoothManagerDelegate: AnyObject {
    func bluetoothManager(_ manager: BluetoothManager, didDiscover device: BluetoothDevice)
    func bluetoothManager(_ manager: BluetoothManager, didChangeState state: CBManagerState)
    func bluetoothManager(_ manager: BluetoothManager, didConnect device: BluetoothDevice)
    func bluetoothManager(_ manager: BluetoothManager, didFailWith error: BluetoothError)
}

public class BluetoothManager: NSObject {
    private var centralManager: CBCentralManager!
    private var discoveredDevices: [BluetoothDevice] = []
    public weak var delegate: BluetoothManagerDelegate?

    public override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }

    public func startScanning() {
        guard centralManager.state == .poweredOn else {
            delegate?.bluetoothManager(self, didFailWith: .bluetoothNotPoweredOn)
            return
        }
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }

    public func stopScanning() {
        centralManager.stopScan()
    }

    public func connect(to device: BluetoothDevice) {
        guard let peripheral = device.peripheral else { return }
        centralManager.connect(peripheral, options: nil)
    }

    public func disconnect(_ device: BluetoothDevice) {
        guard let peripheral = device.peripheral else { return }
        centralManager.cancelPeripheralConnection(peripheral)
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        delegate?.bluetoothManager(self, didChangeState: central.state)
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        let device = BluetoothDevice(peripheral: peripheral, rssi: RSSI)
        discoveredDevices.append(device)
        delegate?.bluetoothManager(self, didDiscover: device)
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if let device = discoveredDevices.first(where: { $0.peripheral == peripheral }) {
            delegate?.bluetoothManager(self, didConnect: device)
        }
    }

    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        delegate?.bluetoothManager(self, didFailWith: .connectionFailed(error?.localizedDescription ?? "Unknown error"))
    }
}
