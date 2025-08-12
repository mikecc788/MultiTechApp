//
//  BluetoothDelegate.swift
//  SwiftDemo
//
//  Created by app on 2022/3/3.
//

import Foundation
import CoreBluetooth
import Combine

public protocol BluetoothManagerDelegate: AnyObject {
    func didUpdateState(_ state: CBManagerState) /// 中心状态变更
    func didStartScanning() /// 开始扫描
    func didStopScanning() /// 停止扫描
    func didDiscover(_ peripheral: CBPeripheral, adv: [String: Any], rssi: NSNumber) /// 发现外设
    func didConnect(_ peripheral: CBPeripheral) /// 已连接
    func didFailToConnect(_ peripheral: CBPeripheral, error: Error?) /// 连接失败
    func didDisconnect(_ peripheral: CBPeripheral, error: Error?) /// 断开连接
    func didRestore(_ peripherals: [CBPeripheral]) /// 状态恢复
    func didDiscoverServices(_ peripheral: CBPeripheral) /// 服务发现完成
    func didDiscoverCharacteristics(_ service: CBService) /// 特征发现完成
    func didUpdateValue(_ characteristic: CBCharacteristic, error: Error?) /// 收到特征值
    func didWriteValue(_ characteristic: CBCharacteristic, error: Error?) /// 写入回执
    func didUpdateNotification(_ characteristic: CBCharacteristic, error: Error?) /// 通知状态变更
    func didTimeoutConnect(_ peripheral: CBPeripheral) /// 连接超时
    func didTimeoutInterrogate(_ peripheral: CBPeripheral) /// 探测超时
}

public extension BluetoothManagerDelegate {
    func didUpdateState(_ state: CBManagerState) {}
    func didStartScanning() {}
    func didStopScanning() {}
    func didDiscover(_ peripheral: CBPeripheral, adv: [String: Any], rssi: NSNumber) {}
    func didConnect(_ peripheral: CBPeripheral) {}
    func didFailToConnect(_ peripheral: CBPeripheral, error: Error?) {}
    func didDisconnect(_ peripheral: CBPeripheral, error: Error?) {}
    func didRestore(_ peripherals: [CBPeripheral]) {}
    func didDiscoverServices(_ peripheral: CBPeripheral) {}
    func didDiscoverCharacteristics(_ service: CBService) {}
    func didUpdateValue(_ characteristic: CBCharacteristic, error: Error?) {}
    func didWriteValue(_ characteristic: CBCharacteristic, error: Error?) {}
    func didUpdateNotification(_ characteristic: CBCharacteristic, error: Error?) {}
    func didTimeoutConnect(_ peripheral: CBPeripheral) {}
    func didTimeoutInterrogate(_ peripheral: CBPeripheral) {}
}
