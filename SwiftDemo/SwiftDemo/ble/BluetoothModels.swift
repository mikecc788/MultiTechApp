//
//  BluetoothModels.swift
//  SwiftDemo
//
//  Created by app on 2025/8/11.
//

import Foundation
import CoreBluetooth
/// BLEError represents the possible errors that can occur during BLE operations.
/// BLEError 表示在 BLE 操作过程中可能出现的错误类型。
/// 通过定义具体的错误类型，可以方便地进行错误处理和调试，提升代码的健壮性和可维护性。
public enum BLEError: Error, Equatable {
    /// The BLE manager is not ready.
    /// BLE 管理器尚未准备好。
    case notReady
    /// No peripheral device found.
    /// 未找到外设设备。
    case noPeripheral
    /// The specified service was not found.
    /// 未找到指定的服务。
    case serviceNotFound(CBUUID)
    /// The specified characteristic was not found.
    /// 未找到指定的特征。
    case characteristicNotFound(CBUUID)
    /// The data to write is too long.
    /// 写入的数据过长。
    case writeTooLong(Int)
    /// Operation timed out.
    /// 操作超时。
    case timeout(String)
}
/// BLEScanFilter defines the criteria used to filter BLE scan results.
/// BLEScanFilter 定义了用于过滤 BLE 扫描结果的条件。
/// 通过设置过滤条件，可以有效减少无关设备的干扰，提高扫描效率和准确性。
public struct BLEScanFilter {
    /// Services to filter by.
    /// 用于过滤的服务列表。
    public var services: [CBUUID]?
    /// Device name prefix to filter by.
    /// 用于过滤的设备名称前缀。
    public var namePrefix: String?
    /// Minimum RSSI value to filter by.
    /// 用于过滤的最小信号强度（RSSI）。
    public var rssiMin: Int?
    /// Whether to allow duplicate scan results.
    /// 是否允许重复扫描结果。
    public var allowDuplicates: Bool

    /// Initializes a BLEScanFilter with optional parameters.
    /// 使用可选参数初始化 BLEScanFilter。
    /// - Parameters:
    ///   - services: Services to filter by.
    ///   - namePrefix: Device name prefix to filter by.
    ///   - rssiMin: Minimum RSSI value to filter by.
    ///   - allowDuplicates: Whether to allow duplicate scan results.
    public init(services: [CBUUID]? = nil,
                namePrefix: String? = nil,
                rssiMin: Int? = nil,
                allowDuplicates: Bool = false) {
        self.services = services
        self.namePrefix = namePrefix
        self.rssiMin = rssiMin
        self.allowDuplicates = allowDuplicates
    }
}
/// BLETimeouts defines timeout durations for BLE operations.
/// BLETimeouts 定义了 BLE 操作的超时时间。
/// 通过设置合理的超时时间，可以避免操作长时间无响应，提升用户体验和程序稳定性。
public struct BLETimeouts {
    /// Timeout for connecting to a peripheral.
    /// 连接外设的超时时间。
    public var connect: TimeInterval
    /// Timeout for interrogating a peripheral.
    /// 询问外设的超时时间。
    public var interrogate: TimeInterval

    /// Initializes BLETimeouts with optional timeout values.
    /// 使用可选超时时间初始化 BLETimeouts。
    /// - Parameters:
    ///   - connect: Timeout for connecting, default is 10 seconds.
    ///   - interrogate: Timeout for interrogating, default is 8 seconds.
    public init(connect: TimeInterval = 10,
                interrogate: TimeInterval = 8) {
        self.connect = connect
        self.interrogate = interrogate
    }
}
/// DiscoveredPeripheral represents a BLE peripheral discovered during scanning.
/// DiscoveredPeripheral 表示扫描过程中发现的 BLE 外设。
/// 该结构体封装了外设对象、广告数据和信号强度，方便管理和比较扫描到的设备。
public struct DiscoveredPeripheral: Hashable {
    /// The underlying CBPeripheral object.
    /// 底层的 CBPeripheral 对象。
    public let peripheral: CBPeripheral
    /// Advertisement data received from the peripheral.
    /// 从外设接收到的广播数据。
    public let adv: [String: Any]
    /// Received signal strength indicator (RSSI).
    /// 接收到的信号强度指示（RSSI）。
    public let rssi: NSNumber
    public var isConnected: Bool = false // 新增状态，标记是否已连接

    /// Hashes the essential components of the peripheral.
    /// 对外设的关键部分进行哈希。
    public func hash(into hasher: inout Hasher) { hasher.combine(peripheral.identifier) }
    /// Compares two DiscoveredPeripheral instances for equality.
    /// 比较两个 DiscoveredPeripheral 实例是否相等。
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.peripheral.identifier == rhs.peripheral.identifier
    }
}
