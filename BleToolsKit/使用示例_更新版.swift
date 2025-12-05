//
//  使用示例_更新版.swift
//  BleToolsKit
//
//  蓝牙 SDK 使用示例 - 支持自动绑定指令
//

import Foundation
import BleToolsKit

class BleManager {
    
    // MARK: - 初始化配置
    func setupBleSDK() {
        // 1️⃣ 配置连接超时（可选，默认 10 秒）
        BleAPI.shared.timeout = 10
        
        // 注意：服务 UUID "1000" 和特征 UUID "1001"、"1002" 已在内部硬编码
        
        // 2️⃣ 设置回调
        BleAPI.shared.onDeviceFound = { [weak self] deviceId, deviceName, rssi in
            print("📱 发现设备:")
            print("   ID: \(deviceId)")
            print("   名称: \(deviceName)")
            print("   信号: \(rssi) dBm")
            
            // 如果是目标设备 "Air Smart Extra"，可以选择自动连接
            if deviceName.contains("Air Smart Extra") {
                self?.connectToDevice(deviceId)
            }
        }
        
        BleAPI.shared.onConnected = {
            print("✅ 设备已连接")
            print("🔄 已自动发送绑定指令: 88dd1E00000000000000000000000000000000 + CRC")
        }
        
        BleAPI.shared.onDataReceived = { hexString in
            print("📨 收到数据: \(hexString)")
            // 在这里处理接收到的数据
        }
        
        BleAPI.shared.onError = { errorMessage in
            print("❌ 错误: \(errorMessage)")
        }
    }
    
    // MARK: - 扫描设备
    func startScanning() {
        print("🔍 开始扫描设备...")
        BleAPI.shared.scan()
    }
    
    // MARK: - 连接设备
    func connectToDevice(_ deviceId: String) {
        print("🔗 正在连接设备: \(deviceId)")
        BleAPI.shared.stopScan()  // 停止扫描
        BleAPI.shared.connect(deviceId: deviceId)
    }
    
    // MARK: - 发送数据
    func sendData(hexString: String) {
        print("📤 发送数据: \(hexString)")
        BleAPI.shared.send(hexString)
    }
    
    // MARK: - 断开连接
    func disconnect() {
        print("🔌 断开连接")
        BleAPI.shared.disconnect()
    }
}

// MARK: - 使用示例

/*
 
 // 1. 初始化（不需要配置 UUID，已内部硬编码）
 let bleManager = BleManager()
 bleManager.setupBleSDK()
 
 // 2. 扫描设备（只扫描 "Air Smart Extra"）
 bleManager.startScanning()
 
 // 3. 连接设备（在 onDeviceFound 回调中获取 deviceId）
 // bleManager.connectToDevice(deviceId)
 
 // 4. 连接成功后，会自动：
 //    - 发现服务 "1000"
 //    - 发现特征 "1001"(写) 和 "1002"(读)
 //    - 启用通知
 //    - 发送绑定指令: 88dd1E00000000000000000000000000000000 + CRC
 
 // 5. 发送自定义数据
 // bleManager.sendData(hexString: "0102FF")
 
 // 6. 断开连接
 // bleManager.disconnect()
 
 */

// MARK: - 工作流程说明

/*
 
 📋 完整工作流程：
 
 1. 扫描设备
    - 只扫描设备名包含 "Air Smart Extra" 的设备
    - 通过 onDeviceFound 回调返回设备信息
 
 2. 连接设备
    - 调用 connect(deviceId:) 连接指定设备
    - 内部自动发现服务 UUID "1000"（硬编码）
 
 3. 发现特征
    - 内部自动发现特征 "1001"（写入，硬编码）
    - 内部自动发现特征 "1002"（通知/读取，硬编码）
    - 自动启用 "1002" 的通知功能
 
 4. 自动发送绑定指令
    - 延迟 0.2 秒后自动发送绑定指令
    - 指令格式: 88dd1E00000000000000000000000000000000 + CRC
    - CRC 计算: 将指令每两位十六进制相加，取最后两位
    - 无需手动配置，完全自动化
 
 5. 接收数据
    - 通过 "1002" 特征的通知功能接收数据
    - 通过 onDataReceived 回调返回十六进制字符串
 
 6. 发送数据
    - 调用 send() 方法通过 "1001" 特征发送数据
 
 */

