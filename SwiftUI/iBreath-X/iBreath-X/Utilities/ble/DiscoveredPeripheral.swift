//
//  DiscoveredPeripheral.swift
//  iBreath-X
//
//  Created by app on 2024/9/5.
//

import Foundation
import CoreBluetooth

struct DiscoveredPeripheral: Hashable, Identifiable {
    let id = UUID()
    var rssi: Int?
    var peripheral: CBPeripheral
    var atomizerCha: CBCharacteristic?
    var locationCharacteristic: CBCharacteristic?
    var advertisedData: String
//    var sensorData: SensorData?
    var isWritePending = false
    var writeSuccess: Bool?
}
