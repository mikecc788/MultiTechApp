//
//  BluetoothDelegate.swift
//  SwiftDemo
//
//  Created by app on 2022/3/3.
//

import Foundation
import CoreBluetooth

/// 蓝牙管理器代理协议
protocol BLEManagerDelegate: AnyObject {
    /// 蓝牙状态更新
    func bleManagerDidUpdateState(_ state: CBManagerState)
    
    /// 扫描状态回调
    func bleManagerDidStartScan()
    func bleManagerDidStopScan()
    
    /// 设备列表更新
    func bleManagerDidUpdateDevices(_ devices: [BLEDeviceModel])
    
    /// 连接状态回调
    func bleManagerDidConnect(_ peripheral: CBPeripheral)
    func bleManagerDidDisconnect(_ peripheral: CBPeripheral, error: Error?)
    func bleManagerDidFailToConnect(_ peripheral: CBPeripheral, error: Error)
    
    /// 服务和特征发现
    func bleManagerDidDiscoverServices(_ services: [CBService])
    func bleManagerDidDiscoverCharacteristics(_ characteristics: [CBCharacteristic], for service: CBService)
    
    /// 数据交互
    func bleManagerDidUpdateValue(_ data: Data, for characteristic: CBCharacteristic)
    func bleManagerDidWriteValue(for characteristic: CBCharacteristic, error: Error?)
}
/// 提供默认实现，减少必须实现的方法
extension BLEManagerDelegate {
    func bleManagerDidUpdateState(_ state: CBManagerState) {}
    func bleManagerDidStartScan() {}
    func bleManagerDidStopScan() {}
    func bleManagerDidUpdateDevices(_ devices: [BLEDeviceModel]) {}
    // ... 其他方法的默认空实现
    func bleManagerDidWriteValue(for characteristic: CBCharacteristic, error: Error?)  {}
}
