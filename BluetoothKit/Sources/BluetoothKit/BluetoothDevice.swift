//
//  File.swift
//  BluetoothKit
//
//  Created by app on 2025/8/4.
//

import CoreBluetooth

public struct BluetoothDevice {
    public let peripheral: CBPeripheral?
    public let rssi: NSNumber
    public var name: String? { peripheral?.name }
    public var identifier: UUID { peripheral?.identifier ?? UUID() }
}
