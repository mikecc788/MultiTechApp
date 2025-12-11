//
//  BleDevice.swift
//  BleToolsDemo
//
//  Created by app on 2025/12/10.
//

import Foundation

/// 蓝牙设备模型
struct BleDevice: Hashable {
    let deviceId: String
    let deviceName: String
    var rssi: Int
    
    var displayName: String {
        return deviceName.isEmpty ? "未知设备" : deviceName
    }
    
    /// 是否是系统已连接的设备（RSSI 为 0）
    var isSystemConnected: Bool {
        return rssi == 0
    }
    
    var signalStrength: String {
        if isSystemConnected {
            return "🔗"
        }
        
        if rssi >= -50 {
            return "📶📶📶📶"
        } else if rssi >= -70 {
            return "📶📶📶"
        } else if rssi >= -85 {
            return "📶📶"
        } else {
            return "📶"
        }
    }
    
    var rssiDisplayText: String {
        if isSystemConnected {
            return "已连接"
        }
        return "RSSI: \(rssi) dBm"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(deviceId)
    }
    
    static func == (lhs: BleDevice, rhs: BleDevice) -> Bool {
        return lhs.deviceId == rhs.deviceId
    }
}

