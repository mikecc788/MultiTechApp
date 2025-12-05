//
//  BleStorage.swift
//  BleToolsKit
//
//  Created by app on 2025/11/5.
//

import Foundation

/// 蓝牙工具包数据存储管理类
internal final class BleStorage {
    
    // MARK: - Singleton
    static let shared = BleStorage()
    
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    // MARK: - MAC 地址映射管理
    
    /// 保存设备 MAC 地址映射
    /// - Parameter mapping: 设备 UUID 到 MAC 地址的映射字典
    func saveDeviceMacMapping(_ mapping: [String: String]) {
        userDefaults.set(mapping, forKey: BleConstants.StorageKeys.deviceMacMapping)
        userDefaults.synchronize()
    }
    
    /// 加载设备 MAC 地址映射
    /// - Returns: 设备 UUID 到 MAC 地址的映射字典，如果不存在则返回空字典
    func loadDeviceMacMapping() -> [String: String] {
        if let savedMapping = userDefaults.dictionary(forKey: BleConstants.StorageKeys.deviceMacMapping) as? [String: String] {
            return savedMapping
        }
        return [:]
    }
    
    /// 获取指定设备的 MAC 地址
    /// - Parameter deviceUUID: 设备 UUID
    /// - Returns: MAC 地址，如果不存在则返回 nil
    func getMacAddress(for deviceUUID: String) -> String? {
        let mapping = loadDeviceMacMapping()
        return mapping[deviceUUID]
    }
    
    /// 保存单个设备的 MAC 地址
    /// - Parameters:
    ///   - macAddress: MAC 地址
    ///   - deviceUUID: 设备 UUID
    func saveMacAddress(_ macAddress: String, for deviceUUID: String) {
        var mapping = loadDeviceMacMapping()
        mapping[deviceUUID] = macAddress
        saveDeviceMacMapping(mapping)
    }
}

