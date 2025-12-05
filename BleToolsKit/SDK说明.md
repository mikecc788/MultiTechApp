# BleToolsKit SDK 说明

## 🎯 设计目标

打包成 SDK 后，**外部项目只能访问 3 个核心接口**，其他所有实现细节完全隐藏。

## ⭐️ 对外暴露的接口

### 公开类
- `BleAPI` - 唯一的公开类

### 公开方法（仅3个）
1. `scan()` - 扫描设备
2. `connect(deviceId:)` - 连接设备  
3. `send(_:)` - 发送数据

### 公开属性
**配置属性（3个）：**
- `serviceUUIDs: [String]?`
- `characteristicUUIDs: [String]`
- `timeout: TimeInterval`

**回调属性（4个）：**
- `onDeviceFound: ((String, String, Int) -> Void)?`
- `onConnected: (() -> Void)?`
- `onDataReceived: ((String) -> Void)?`
- `onError: ((String) -> Void)?`

### 辅助方法（可选暴露）
- `stopScan()` - 停止扫描
- `disconnect()` - 断开连接

## 🔒 内部实现（不对外暴露）

所有内部类和结构都使用 `internal` 或 `private` 修饰符：

### 内部类（internal）
- `BleCentral` - 核心蓝牙管理类
- `BleDevice` - 设备信息结构
- `BleFilter` - 扫描过滤器
- `BleError` - 错误枚举
- `ScanToken` - 扫描令牌协议

### 上下文辅助类（private）
- `DiscoverContext` - 服务发现上下文
- `WriteContext` - 写入操作上下文
- `NotifyContext` - 通知订阅上下文

## 📦 文件结构

```
BleToolsKit/
├── BleAPI.swift          ⭐️ 公开API（仅此文件对外）
├── BleCentral.swift      🔒 内部实现（internal）
├── BlePublic.swift       🔒 内部数据结构（internal）
└── BleToolsKit.swift     ⭐️ 入口文件（可选）
```

## 🎨 访问级别设计

| 类型 | 访问级别 | 说明 |
|-----|---------|------|
| `BleAPI` | `public` | 对外公开 |
| `BleAPI.scan()` | `public` | 对外公开 |
| `BleAPI.connect()` | `public` | 对外公开 |
| `BleAPI.send()` | `public` | 对外公开 |
| `BleCentral` | `internal` | 仅SDK内部 |
| `BleDevice` | `internal` | 仅SDK内部 |
| `BleFilter` | `internal` | 仅SDK内部 |
| 工具扩展 | `fileprivate` | 仅文件内部 |

## 📋 使用示例

```swift
import BleToolsKit

let ble = BleAPI.shared

// ✅ 可以访问
ble.scan()
ble.connect(deviceId: "xxx")
ble.send("01")

// ❌ 无法访问（编译错误）
let central = BleCentral.shared     // Error: 'BleCentral' is internal
let device = BleDevice(...)         // Error: 'BleDevice' is internal
```

## 🔧 打包验证

打包成 XCFramework 后，外部项目：

**✅ 可以使用：**
```swift
import BleToolsKit

BleAPI.shared.scan()
BleAPI.shared.connect(deviceId: "xxx")
BleAPI.shared.send("0102")
```

**❌ 无法访问：**
```swift
BleCentral.shared              // 编译错误
BleDevice(...)                 // 编译错误
BleFilter(...)                 // 编译错误
```

## 🚀 SDK优势

### 1. 极简接口
外部只需学习 3 个方法即可完成所有蓝牙操作

### 2. 安全隔离
内部实现完全隐藏，防止误用和滥用

### 3. 自动处理
- 自动服务发现
- 自动特征发现
- 自动订阅通知
- 自动选择可写特征

### 4. 易于维护
内部实现可随时修改，不影响外部接口

## 📝 修改记录

### 访问级别修改

| 文件 | 修改内容 |
|-----|---------|
| `BleCentral.swift` | 所有 `public` → `internal` |
| `BlePublic.swift` | 所有 `public` → `internal` |
| `BleAPI.swift` | 只保留核心方法为 `public` |

### 具体修改

**BleCentral.swift:**
```swift
// 修改前
public final class BleCentral
public func startScan(...)
public func connect(...)

// 修改后
internal final class BleCentral
internal func startScan(...)
internal func connect(...)
```

**BlePublic.swift:**
```swift
// 修改前
public struct BleDevice
public protocol ScanToken
public enum BleError

// 修改后
internal struct BleDevice
internal protocol ScanToken
internal enum BleError
```

**BleAPI.swift:**
```swift
// 保留public
public final class BleAPI
public func scan()
public func connect(deviceId:)
public func send(_:)

// 工具方法改为fileprivate
fileprivate extension String {
    func hexToData() -> Data?
}
```

## 🎓 开发者使用指南

外部开发者只需要：

1. **导入框架**
   ```swift
   import BleToolsKit
   ```

2. **配置和设置回调**
   ```swift
   let ble = BleAPI.shared
   ble.characteristicUUIDs = ["FFE1"]
   ble.onDeviceFound = { ... }
   ble.onConnected = { ... }
   ble.onDataReceived = { ... }
   ```

3. **调用三个核心方法**
   ```swift
   ble.scan()                    // 扫描
   ble.connect(deviceId: "xxx")  // 连接
   ble.send("01")                // 发送
   ```

## ✅ 验证清单

- [x] 只暴露 3 个核心方法
- [x] 所有内部类使用 `internal`
- [x] 工具方法使用 `fileprivate`
- [x] 无编译错误
- [x] 文档完整
- [x] 示例代码完整

## 🎉 完成

SDK 已经完全按照要求设计：
- ✅ 对外只暴露 3 个接口
- ✅ 所有复杂逻辑内部自动处理
- ✅ 极简易用，学习成本低
- ✅ 安全可靠，不会误用

**适合场景：**
- 提供给其他团队使用
- 商业SDK产品
- 开源框架
- 简化集成流程

