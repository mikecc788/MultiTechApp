//
//  SDK使用示例 - 带日志调试
//  BleToolsKit
//
//  展示如何使用日志回调查看 SDK 内部运行状态
//

import UIKit
import BleToolsKit

class BleTestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBleSDK()
    }
    
    // MARK: - 配置 SDK
    
    func setupBleSDK() {
        let ble = BleAPI.shared
        
        // ⭐️ 重要：设置日志回调，查看 SDK 内部运行状态
        ble.onLog = { logMessage in
            print("📱 [BLE SDK] \(logMessage)")
            // 你也可以显示到 UI 上，例如：
            // self.logTextView.text += "\n\(logMessage)"
        }
        
        // 设置设备发现回调
        ble.onDeviceFound = { deviceId, name, rssi in
            print("发现设备: \(name), ID: \(deviceId), RSSI: \(rssi)")
        }
        
        // 设置连接成功回调
        ble.onConnected = {
            print("✅ 设备连接成功")
        }
        
        // 设置数据接收回调
        ble.onDataReceived = { hexString in
            print("📥 收到数据: \(hexString)")
        }
        
        // 设置错误回调
        ble.onError = { errorMessage in
            print("❌ 错误: \(errorMessage)")
        }
    }
    
    // MARK: - 测试按钮事件
    
    @IBAction func startScan(_ sender: UIButton) {
        print("🔍 开始扫描设备...")
        BleAPI.shared.scan()
    }
    
    @IBAction func connect(_ sender: UIButton) {
        // 假设你已经保存了设备 ID
        let deviceId = "你的设备ID"
        print("🔗 连接设备: \(deviceId)")
        BleAPI.shared.connect(deviceId: deviceId)
    }
    
    @IBAction func testFVC(_ sender: UIButton) {
        print("🧪 发送 FVC 测试指令")
        BleAPI.shared.fvc()
        // 现在你会看到：
        // 📱 [BLE SDK] 🔵 [FVC] 开始发送 FVC 测试指令
        // 📱 [BLE SDK] 📤 测试命令: e2010101 + Terminator(E5) = e2010101E5
        // 📱 [BLE SDK] 🔐 [新设备] 密钥池加密(0): xxxxx...
        // 或者
        // 📱 [BLE SDK] 📱 [老设备] 直接发送原始数据: e2010101E5
    }
    
    @IBAction func testVC(_ sender: UIButton) {
        print("🧪 发送 VC 测试指令")
        BleAPI.shared.vc()
    }
    
    @IBAction func testMVV(_ sender: UIButton) {
        print("🧪 发送 MVV 测试指令")
        BleAPI.shared.mvv()
    }
    
    @IBAction func stopFVC(_ sender: UIButton) {
        print("⏹ 停止 FVC 测试")
        BleAPI.shared.stopFvc()
    }
    
    @IBAction func stopVC(_ sender: UIButton) {
        print("⏹ 停止 VC 测试")
        BleAPI.shared.stopVc()
    }
    
    @IBAction func stopMVV(_ sender: UIButton) {
        print("⏹ 停止 MVV 测试")
        BleAPI.shared.stopMvv()
    }
}

// MARK: - 更简单的使用方式

class SimpleBleTest {
    
    func quickTest() {
        // 1️⃣ 启用日志（一行代码）
        BleAPI.shared.onLog = { print("🔵 \($0)") }
        
        // 2️⃣ 设置回调
        BleAPI.shared.onError = { print("❌ \($0)") }
        
        // 3️⃣ 测试
        BleAPI.shared.fvc()
        
        // 现在你会在控制台看到完整的日志输出
    }
}

// MARK: - SwiftUI 使用示例

import SwiftUI

struct BleTestView: View {
    @State private var logs: [String] = []
    @State private var isScanning = false
    
    var body: some View {
        VStack {
            // 日志显示区域
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(logs, id: \.self) { log in
                        Text(log)
                            .font(.system(size: 12, design: .monospaced))
                            .foregroundColor(.green)
                    }
                }
                .padding()
            }
            .background(Color.black)
            .frame(height: 300)
            
            // 测试按钮
            HStack {
                Button("FVC") {
                    BleAPI.shared.fvc()
                }
                
                Button("VC") {
                    BleAPI.shared.vc()
                }
                
                Button("MVV") {
                    BleAPI.shared.mvv()
                }
            }
            .padding()
        }
        .onAppear {
            setupBleSDK()
        }
    }
    
    func setupBleSDK() {
        // 日志回调 - 显示到界面上
        BleAPI.shared.onLog = { [self] log in
            DispatchQueue.main.async {
                logs.append(log)
                // 限制日志条数
                if logs.count > 100 {
                    logs.removeFirst()
                }
            }
        }
        
        BleAPI.shared.onError = { [self] error in
            DispatchQueue.main.async {
                logs.append("❌ \(error)")
            }
        }
    }
}

// MARK: - 日志说明

/*
 日志图标说明：
 
 🔵 - 操作开始
 📤 - 发送命令
 📲 - 发送绑定指令
 📱 - 老设备相关
 🔐 - 密钥池加密
 🔑 - 固定密钥加密
 ❌ - 错误信息
 🔴 - 失败信息
 
 示例日志输出：
 
 1. 新设备 FVC 测试：
    🔵 [FVC] 开始发送 FVC 测试指令
    📤 测试命令: e2010101 + Terminator(E5) = e2010101E5
    🔐 [新设备] 密钥池加密(0): AF12CD34...
 
 2. 老设备 FVC 测试：
    🔵 [FVC] 开始发送 FVC 测试指令
    📤 测试命令: e2010101 + Terminator(E5) = e2010101E5
    📱 [老设备] 直接发送原始数据: e2010101E5
 
 3. 连接时的绑定指令：
    新设备：
    📲 [新设备] 发送绑定指令: 88dd1E00000000000000000000000000000000AB
    
    老设备：
    📲 [老设备] 发送绑定指令: e20020251209105030CD, 长度: 24
 */

