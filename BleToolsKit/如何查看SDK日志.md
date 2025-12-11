# 如何查看 SDK 日志

## 问题描述

当把 SDK 拖到项目中测试时，点击 FVC、VC、MVV 没有任何反应，看不到打印日志。

## 原因分析

1. **Release 模式构建**：`build_xcframework.sh` 使用 `Release` 配置，所有 `#if DEBUG` 包裹的代码都不会被编译
2. **无日志反馈**：SDK 内部使用 `print()`，但外部无法看到这些日志

## 解决方案

我已经为 SDK 添加了 **日志回调机制**，现在你可以通过设置 `onLog` 回调来查看 SDK 内部的运行状态。

### 1️⃣ 最简单的用法（一行代码）

```swift
import BleToolsKit

// 启用日志输出到控制台
BleAPI.shared.onLog = { print("🔵 [BLE] \($0)") }
```

### 2️⃣ 完整使用示例

```swift
import UIKit
import BleToolsKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSDK()
    }
    
    func setupSDK() {
        let ble = BleAPI.shared
        
        // ⭐️ 关键：设置日志回调
        ble.onLog = { log in
            print("📱 [SDK] \(log)")
        }
        
        // 设置错误回调
        ble.onError = { error in
            print("❌ 错误: \(error)")
        }
        
        // 设置数据接收回调
        ble.onDataReceived = { hexString in
            print("📥 收到数据: \(hexString)")
        }
    }
    
    @IBAction func testFVC(_ sender: UIButton) {
        BleAPI.shared.fvc()
        // 现在你会看到：
        // 📱 [SDK] 🔵 [FVC] 开始发送 FVC 测试指令
        // 📱 [SDK] 📤 测试命令: e2010101 + Terminator(E5) = e2010101E5
        // 📱 [SDK] 🔐 [新设备] 密钥池加密(0): xxxxx...
    }
}
```

### 3️⃣ 显示到界面上（推荐）

```swift
class ViewController: UIViewController {
    
    @IBOutlet weak var logTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 将日志显示到界面上
        BleAPI.shared.onLog = { [weak self] log in
            DispatchQueue.main.async {
                let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
                self?.logTextView.text += "\n[\(timestamp)] \(log)"
                
                // 自动滚动到底部
                let bottom = NSRange(location: self?.logTextView.text.count ?? 0, length: 1)
                self?.logTextView.scrollRangeToVisible(bottom)
            }
        }
    }
}
```

### 4️⃣ SwiftUI 版本

```swift
import SwiftUI
import BleToolsKit

struct BleTestView: View {
    @State private var logs: [String] = []
    
    var body: some View {
        VStack {
            // 日志显示区域
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(logs, id: \.self) { log in
                        Text(log)
                            .font(.system(size: 12, design: .monospaced))
                    }
                }
            }
            .frame(height: 300)
            .background(Color.black)
            
            // 测试按钮
            Button("FVC 测试") {
                BleAPI.shared.fvc()
            }
        }
        .onAppear {
            BleAPI.shared.onLog = { [self] log in
                DispatchQueue.main.async {
                    logs.append(log)
                }
            }
        }
    }
}
```

## 日志说明

### 图标含义

- 🔵 操作开始
- 📤 发送命令
- 📲 发送绑定指令
- 📱 老设备相关
- 🔐 密钥池加密
- 🔑 固定密钥加密
- ❌ 错误信息
- 🔴 失败信息

### 示例日志输出

#### 新设备 FVC 测试
```
🔵 [FVC] 开始发送 FVC 测试指令
📤 测试命令: e2010101 + Terminator(E5) = e2010101E5
🔐 [新设备] 密钥池加密(0): AF12CD34EF56...
```

#### 老设备 FVC 测试
```
🔵 [FVC] 开始发送 FVC 测试指令
📤 测试命令: e2010101 + Terminator(E5) = e2010101E5
📱 [老设备] 直接发送原始数据: e2010101E5
```

#### 连接时的绑定指令

**新设备：**
```
📲 [新设备] 发送绑定指令: 88dd1E00000000000000000000000000000000AB
```

**老设备：**
```
📲 [老设备] 发送绑定指令: e20020251209105030CD, 长度: 24
```

## 重新构建 SDK

修改代码后，需要重新构建 xcframework：

```bash
cd /Users/feellife/Desktop/swift/BleToolsKit
./build_xcframework.sh
```

构建完成后，新的 framework 位于：
```
./ReleaseArtifacts/BleToolsKit.xcframework
```

## 常见问题排查

### 1. 点击测试按钮没有反应

**原因**：设备可能未连接，或写特征未准备好

**解决**：
1. 先扫描设备：`BleAPI.shared.scan()`
2. 连接设备：`BleAPI.shared.connect(deviceId: "xxx")`
3. 等待连接成功回调后再测试

**查看日志**：
```swift
BleAPI.shared.onLog = { print($0) }
```

如果看到：
```
❌ 写特征未准备好，无法发送测试命令
```
说明设备未正确连接或特征未发现。

### 2. 看不到任何日志

**原因**：没有设置 `onLog` 回调

**解决**：在调用任何 SDK 方法之前设置：
```swift
BleAPI.shared.onLog = { print("🔵 \($0)") }
```

### 3. 日志显示"加密失败"

**原因**：密钥配置错误或加密方法有问题

**解决**：检查日志中的详细错误信息，通常会显示具体原因

## 完整测试流程

```swift
// 1. 配置回调
BleAPI.shared.onLog = { print("📱 \($0)") }
BleAPI.shared.onError = { print("❌ \($0)") }
BleAPI.shared.onDeviceFound = { id, name, rssi in
    print("发现设备: \(name)")
}
BleAPI.shared.onConnected = {
    print("✅ 连接成功，可以开始测试")
}

// 2. 扫描设备
BleAPI.shared.scan()

// 3. 连接设备（在 onDeviceFound 中获取 deviceId）
BleAPI.shared.connect(deviceId: "你的设备ID")

// 4. 等待连接成功后测试
// 在 onConnected 回调中执行：
BleAPI.shared.fvc()  // FVC 测试
BleAPI.shared.vc()   // VC 测试
BleAPI.shared.mvv()  // MVV 测试
```

## 更多示例

详细的使用示例请查看：
- `SDK使用示例_带日志.swift` - 包含 UIKit 和 SwiftUI 的完整示例
- `使用示例_更新版.swift` - 基础使用示例

## 技术支持

如果仍然有问题，请查看日志输出并提供：
1. 完整的日志输出
2. 使用的设备类型（新设备/老设备）
3. 具体的错误信息

这样可以更快定位问题。

