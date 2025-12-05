# BleToolsKit - 极简蓝牙SDK

> 🎯 **仅对外暴露3个核心接口**，所有复杂逻辑内部自动处理

## ⭐️ 三大核心接口

| 接口 | 说明 | 示例 |
|-----|------|-----|
| **`scan()`** | 扫描蓝牙设备 | `ble.scan()` |
| **`connect(deviceId:)`** | 连接指定设备 | `ble.connect(deviceId: "xxx")` |
| **`send(_:)`** | 发送数据 | `ble.send("0102FF")` |

## 快速使用

```swift
import BleToolsKit

let ble = BleAPI.shared

// 1. 配置UUID（可选）
ble.characteristicUUIDs = ["FFE1"]

// 2. 设置回调
ble.onDeviceFound = { deviceId, name, rssi in
    print("📱 发现: \(name)")
    ble.connect(deviceId: deviceId)  // 连接设备
}

ble.onConnected = {
    print("✅ 已连接")
    ble.send("01")  // 发送数据
}

ble.onDataReceived = { hexString in
    print("📦 收到: \(hexString)")
}

ble.onError = { error in
    print("❌ \(error)")
}

// 3. 开始扫描
ble.scan()
```

## 完整示例

```swift
class MyViewController: UIViewController {
    
    let ble = BleAPI.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBluetooth()
    }
    
    func setupBluetooth() {
        // 配置
        ble.serviceUUIDs = ["FFE0"]
        ble.characteristicUUIDs = ["FFE1"]
        ble.timeout = 10
        
        // 回调
        ble.onDeviceFound = { [weak self] deviceId, name, rssi in
            print("发现设备: \(name), 信号: \(rssi)dBm")
            
            if name.contains("BLE") {
                self?.ble.connect(deviceId: deviceId)
            }
        }
        
        ble.onConnected = { [weak self] in
            print("连接成功")
            self?.ble.send("01")  // 发送开启命令
        }
        
        ble.onDataReceived = { [weak self] data in
            print("收到数据: \(data)")
            // 处理接收的数据...
        }
        
        ble.onError = { [weak self] error in
            print("错误: \(error)")
        }
        
        // 开始扫描
        ble.scan()
    }
    
    @IBAction func sendCommand(_ sender: Any) {
        ble.send("0102FF")
    }
    
    @IBAction func disconnect(_ sender: Any) {
        ble.disconnect()
    }
}
```

## API详细说明

### 配置属性

| 属性 | 类型 | 说明 | 默认值 |
|-----|------|------|--------|
| `serviceUUIDs` | `[String]?` | 服务UUID列表 | `nil`（扫描所有） |
| `characteristicUUIDs` | `[String]` | 特征UUID列表 | `[]` |
| `timeout` | `TimeInterval` | 连接超时（秒） | `10` |

### 回调属性

| 回调 | 参数 | 说明 |
|-----|------|------|
| `onDeviceFound` | `(deviceId, name, rssi)` | 发现设备 |
| `onConnected` | - | 连接成功 |
| `onDataReceived` | `hexString` | 收到数据 |
| `onError` | `message` | 错误信息 |

### 核心方法

#### 1. `scan()` - 扫描设备
开始扫描蓝牙设备，发现设备时触发 `onDeviceFound` 回调。

```swift
ble.scan()
```

#### 2. `connect(deviceId:)` - 连接设备
连接指定设备，自动发现服务和特征，自动订阅通知。

```swift
ble.connect(deviceId: "设备ID")
```

参数：
- `deviceId`: 从 `onDeviceFound` 回调中获取的设备ID

#### 3. `send(_:)` - 发送数据
向设备发送十六进制数据，自动选择可写特征。

```swift
ble.send("0102FF")
```

参数：
- 十六进制字符串（如：`"01"`, `"0102FF"`, `"FF00AA"`）

### 辅助方法（可选）

```swift
ble.stopScan()     // 停止扫描
ble.disconnect()   // 断开连接
```

## 自动处理的功能

SDK内部自动处理以下复杂逻辑：

✅ 服务发现  
✅ 特征发现  
✅ 自动订阅通知特征  
✅ 自动选择可写特征  
✅ 数据格式转换（十六进制↔️Data）  
✅ 错误处理  
✅ 连接超时  

## 使用场景示例

### 场景1：心率监测器

```swift
ble.serviceUUIDs = ["180D"]
ble.characteristicUUIDs = ["2A37"]

ble.onDataReceived = { data in
    // 解析心率（第2个字节）
    if data.count >= 4 {
        let heartRate = Int(data.dropFirst(2).prefix(2), radix: 16)
        print("❤️ 心率: \(heartRate ?? 0) bpm")
    }
}

ble.scan()
```

### 场景2：智能灯控制

```swift
ble.characteristicUUIDs = ["FFE1"]

ble.onConnected = {
    ble.send("01")        // 开灯
    ble.send("50")        // 亮度50%
    ble.send("FF0000")    // 红色
}

ble.scan()
```

### 场景3：温度传感器

```swift
ble.onDataReceived = { hexString in
    guard let data = Data(hexString: hexString) else { return }
    // 解析温度数据
    let temperature = Float(data[0])
    print("🌡️ 温度: \(temperature)°C")
}
```

## 注意事项

### 权限配置

在 `Info.plist` 中添加：

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>需要使用蓝牙连接设备</string>
```

### UUID 格式

支持短格式和长格式：
- ✅ `"180A"` 
- ✅ `"FFE0"`
- ✅ `"0000180A-0000-1000-8000-00805F9B34FB"`

### 数据格式

统一使用十六进制字符串：
- `"01"` = `0x01`
- `"0102FF"` = `0x01, 0x02, 0xFF`
- `"FF00AA"` = `0xFF, 0x00, 0xAA`

### 使用流程

```
scan() 
  ↓
onDeviceFound (发现设备)
  ↓
connect(deviceId)
  ↓
onConnected (连接成功)
  ↓
send("hexData") / onDataReceived (数据交互)
  ↓
disconnect() (可选)
```

## 系统要求

- iOS 13.0+
- Swift 5.0+
- Xcode 13.0+

## SDK架构

```
┌─────────────────────────────┐
│   BleAPI (仅3个公开方法)      │ ← 外部调用
├─────────────────────────────┤
│   BleCentral (internal)     │ ← 内部实现
├─────────────────────────────┤
│   CoreBluetooth (系统)       │ ← iOS框架
└─────────────────────────────┘
```

所有内部实现类（`BleCentral`、`BleDevice`、`BleFilter` 等）都是 `internal`，外部SDK无法访问。

## 开源协议

Copyright © 2025

---

**简单、强大、易用** - 仅需3个方法，轻松搞定蓝牙开发！
