//
//  File.swift
//  BluetoothKit
//
//  Created by app on 2025/8/4.
//

import CoreBluetooth

extension CBPeripheral {
    var readableName: String {
        name ?? "Unknown Device"
    }
}
