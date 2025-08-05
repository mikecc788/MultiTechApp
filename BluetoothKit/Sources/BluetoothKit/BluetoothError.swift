//
//  File.swift
//  BluetoothKit
//
//  Created by app on 2025/8/4.
//

public enum BluetoothError: Error {
    case bluetoothNotPoweredOn
    case connectionFailed(String)
    case characteristicNotFound
}
