//
//  Routes.swift
//  iBreath-X
//
//  Created by app on 2024/8/27.
//

import Foundation
import CoreBluetooth

enum Routes {
    case publicAccount
    case offical
    case healthy
}

enum MyRoutes {
    case searchHistory
    case reviewHistory
    case settings
}

// 蓝牙设备名跳转到不同的控制器
enum PeripheralRoutes: Hashable {
    case atomizer(peripheral: CBPeripheral)
    case airFitSmart
    case defaultView
}
