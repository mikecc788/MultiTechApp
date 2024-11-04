//
//  BLEDeviceModel.swift
//  SwiftDemo
//
//  Created by app on 2024/11/4.
//

import Foundation
import CoreBluetooth

@objc class BLEDeviceModel:NSObject {
    let peripheral: CBPeripheral
    let advertisementData: [String: Any]
    let rssi: NSNumber
    var lastUpdatedTime: Date
    
    init(peripheral: CBPeripheral, advertisementData: [String: Any], rssi: NSNumber, lastUpdatedTime: Date) {
        self.peripheral = peripheral
        self.advertisementData = advertisementData
        self.rssi = rssi
        self.lastUpdatedTime = lastUpdatedTime
    }
    var name: String {
        if let deviceName = peripheral.name, !deviceName.isEmpty {
            return deviceName
        }
        if let advertisementName = advertisementData[CBAdvertisementDataLocalNameKey] as? String,
           !advertisementName.isEmpty {
            return advertisementName
        }
        return "Unnamed Device"
    }
    
    @available(iOS 15.0, *)
    var detailInfo: String {
        """
        UUID: \(peripheral.identifier.uuidString)
        RSSI: \(rssi) dBm
        Last Updated: \(lastUpdatedTime.timeIntervalSinceNow.formatted) ago
        """
    }
}
// MARK: - TimeInterval Extension
private extension TimeInterval {
    var formatted: String {
        if self < 60 {
            return String(format: "%.0f seconds", self)
        } else if self < 3600 {
            return String(format: "%.0f minutes", self / 60)
        } else {
            return String(format: "%.1f hours", self / 3600)
        }
    }
}
