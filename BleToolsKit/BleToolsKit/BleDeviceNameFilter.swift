//
//  BleDeviceNameFilter.swift
//  BleToolsKit
//
//  Created by app on 2025/12/04.
//

import Foundation
import CoreBluetooth

/// 设备名称过滤工具类
internal final class BleDeviceNameFilter {
    
    // MARK: - Singleton
    static let shared = BleDeviceNameFilter()
    
    private init() {}
    
    // MARK: - Public Properties
    
    /// 目标设备名称
    private let targetDeviceName = "Air Smart Extra"
    
    // MARK: - Public Methods
    
    /// 判断设备名称是否匹配目标设备
    /// - Parameter deviceName: 设备名称
    /// - Returns: true 表示匹配，false 表示不匹配
    func isTargetDevice(deviceName: String?) -> Bool {
        guard let name = deviceName else {
            return false
        }
        return name.contains(targetDeviceName)
    }
    
    /// 判断蓝牙外设是否为目标设备
    /// - Parameter peripheral: 蓝牙外设
    /// - Returns: true 表示匹配，false 表示不匹配
    func isTargetDevice(peripheral: CBPeripheral) -> Bool {
        return isTargetDevice(deviceName: peripheral.name)
    }
}

