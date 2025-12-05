//
//  BlePublic.swift
//  BleToolsKit
//
//  Created by app on 2025/10/20.
//

import Foundation
import CoreBluetooth

// 内部数据结构，不对外暴露
internal struct BleDevice: Hashable {
    let peripheral: CBPeripheral
    let name: String
    let identifier: String
    let rssi: Int
    let macAddress: String?

    init(peripheral: CBPeripheral, rssi: Int, macAddress: String? = nil) {
        self.peripheral = peripheral
        self.name = peripheral.name ?? "Unknown"
        self.identifier = peripheral.identifier.uuidString
        self.rssi = rssi
        self.macAddress = macAddress
    }
}

internal struct BleFilter {
    /// 指定要扫描的 Service（一般建议填你的主服务 UUID），nil 则不过滤
    let serviceUUIDs: [CBUUID]?
    /// 是否允许重复回调（默认 false：同一设备只回一次）
    let allowDuplicates: Bool

    init(serviceUUIDs: [CBUUID]? = nil, allowDuplicates: Bool = false) {
        self.serviceUUIDs = serviceUUIDs
        self.allowDuplicates = allowDuplicates
    }
}

internal protocol ScanToken { func stop() }

internal enum BleError: LocalizedError {
    case unsupported, unauthorized, poweredOff, timeout, disconnected, unknown
    var errorDescription: String? {
        switch self {
        case .unsupported: return "This device does not support Bluetooth LE."
        case .unauthorized: return "Bluetooth permission not granted."
        case .poweredOff:  return "Bluetooth is powered off."
        case .timeout:     return "Operation timed out."
        case .disconnected:return "Peripheral disconnected."
        case .unknown:     return "Unknown BLE error."
        }
    }
}

