//
//  BluetoothProtocol.swift
//  iBreath-X
//
//  Created by app on 2024/9/5.
//

import Foundation
import Combine  //一个响应式编程框架，用于处理异步数据流
import CoreBluetooth
@available(macOS 12, iOS 15, tvOS 15.0, watchOS 8.0, *)

public protocol BluetoothProtocol {
    // never 表示该发布者永远不会失败   CurrentValueSubject对象，用于发布蓝牙状态的变化 { get } 只读
    var bleState: CurrentValueSubject<BLEState, Never> { get }
    var peripheralsStream: AsyncStream<[CBPeripheral]> { get async }
    func discoverServices(for peripheral: CBPeripheral, from cache: Bool, disconnect: Bool) async throws -> [CBService]
    func connect(to peripheral: CBPeripheral) async throws
    func disconnect(from peripheral: CBPeripheral) async throws
}
