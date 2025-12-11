//
//  已连接设备扫描示例.swift
//  BleToolsKit
//
//  演示如何在扫描时包含系统已连接的设备
//

import Foundation

// MARK: - 使用示例

class BleUsageExample {
    
    let ble = BleAPI.shared
    
    func setup() {
        // 1️⃣ 设置回调
        ble.onDeviceFound = { [weak self] deviceId, deviceName, rssi in
            print("📱 发现设备: \(deviceName)")
            print("   - ID: \(deviceId)")
            print("   - 信号: \(rssi) dBm")
            
            // 注意：已连接设备的 RSSI 值为 0
            if rssi == 0 {
                print("   - ✅ 这是系统已连接的设备")
            }
        }
        
        ble.onConnected = {
            print("✅ 连接成功！")
        }
        
        ble.onDataReceived = { hexString in
            print("📩 收到数据: \(hexString)")
        }
        
        ble.onError = { errorMsg in
            print("❌ 错误: \(errorMsg)")
        }
        
        ble.onLog = { logMsg in
            print("📝 日志: \(logMsg)")
        }
    }
    
    // MARK: - 方案1: 扫描时包含已连接设备（默认行为）
    
    func scanWithConnectedDevices() {
        print("开始扫描（包含已连接设备）...")
        
        // 方式1: 使用默认参数（包含已连接设备）
        ble.scan()
        
        // 方式2: 显式指定（与方式1等效）
        // ble.scan(includeConnectedDevices: true)
    }
    
    // MARK: - 方案2: 扫描时不包含已连接设备
    
    func scanWithoutConnectedDevices() {
        print("开始扫描（不包含已连接设备）...")
        
        // 显式设置为 false，只扫描新设备
        ble.scan(includeConnectedDevices: false)
    }
    
    // MARK: - 方案3: 先检查已连接设备，再扫描新设备
    
    func scanInStages() {
        print("阶段1: 获取已连接设备...")
        
        // 第一次扫描：只获取已连接设备
        ble.scan(includeConnectedDevices: true)
        
        // 延迟2秒后，停止扫描
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.ble.stopScan()
            print("已连接设备扫描完成")
            
            // 这里可以根据业务逻辑决定是否继续扫描新设备
            print("\n阶段2: 扫描新设备...")
            self?.ble.scan(includeConnectedDevices: false)
        }
    }
    
    // MARK: - 连接设备示例
    
    func connectToDevice(deviceId: String) {
        print("开始连接设备: \(deviceId)")
        ble.connect(deviceId: deviceId)
    }
    
    // MARK: - 完整使用流程
    
    func completeFlow() {
        setup()
        
        // 开始扫描（默认包含已连接设备）
        scanWithConnectedDevices()
        
        // 假设扫描到设备后，在 onDeviceFound 回调中获取 deviceId
        // 然后调用 connectToDevice(deviceId: deviceId) 进行连接
    }
}

// MARK: - 使用说明

/*
 
 ✅ 功能说明：
 
 1. 默认行为（推荐）：
    - ble.scan() 默认包含系统已连接的设备
    - 已连接设备的 RSSI 值为 0，可以用来区分
    - 适用于大多数场景，让用户能看到所有可用设备
 
 2. 不包含已连接设备：
    - ble.scan(includeConnectedDevices: false)
    - 只扫描未连接的新设备
    - 适用于只想发现新设备的场景
 
 3. 已连接设备的特点：
    - RSSI 值固定为 0（因为无法获取实时信号强度）
    - 可以直接连接使用
    - MAC 地址从本地存储中获取（如果之前保存过）
 
 4. 使用场景：
    - 用户手机系统设置中已连接了设备
    - 其他 App 已连接了设备
    - 需要在扫描列表中显示这些已连接的设备
 
 5. 技术细节：
    - 使用 CBCentralManager.retrieveConnectedPeripherals(withServices:) 方法
    - 只返回匹配目标服务 UUID 的已连接设备
    - 设备名称通过 BleDeviceNameFilter 进行过滤
 
 ⚠️ 注意事项：
 
 1. 已连接设备的限制：
    - RSSI 值为 0（无法获取实时信号强度）
    - 如果之前没有保存过，MAC 地址可能为 nil
    - 设备可能是被其他 App 连接的（需要断开才能重新连接）
 
 2. 重复设备问题：
    - 已连接设备会被标记为"已发现"，避免扫描时重复回调
    - 如果需要重复回调，使用 allowDuplicates 参数
 
 3. 连接状态：
    - 如果设备已被系统或其他 App 连接，直接调用 connect 可能会失败
    - 建议先断开再重新连接，或者检查连接状态
 
 */

// MARK: - 与 OC 的对应关系

/*
 
 原 OC 代码：
 ```objc
 NSArray *connectedArr = [manager.manager retrieveConnectedPeripheralsWithServices:array1];
 ```
 
 对应的 Swift 代码（在 BleCentral.swift 内部实现）：
 ```swift
 let connectedPeripherals = central.retrieveConnectedPeripherals(withServices: serviceUUIDs)
 ```
 
 外部调用方式：
 ```swift
 // OC: 需要手动调用并处理返回的数组
 // Swift: 自动集成到 scan() 方法中，通过统一的 onDeviceFound 回调返回
 
 BleAPI.shared.scan(includeConnectedDevices: true)
 ```
 
 优势：
 1. 统一接口：已连接设备和扫描设备使用同一个回调
 2. 自动过滤：只返回目标设备（通过名称过滤）
 3. 自动缓存：设备信息自动保存，连接时可用
 4. 简化使用：外部无需关心底层实现细节
 
 */

