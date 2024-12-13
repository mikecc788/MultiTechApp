//
//  BLEDeviceModel.swift
//  SwiftDemo
//
//  Created by app on 2024/11/4.
//

import Foundation
import CoreBluetooth

struct BLEDeviceModel {
    let peripheral: CBPeripheral
    let advertisementData: [String: Any]
    let rssi: NSNumber
    let lastUpdatedTime: Date
    
    var name: String {
        peripheral.name ??
                (advertisementData[CBAdvertisementDataLocalNameKey] as? String) ??
                "Unnamed Device"
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
        let absoluteValue = abs(self)
        switch absoluteValue {
        case ..<60:
            return "\(Int(absoluteValue)) seconds"
        case 60..<3600:
            return "\(Int(absoluteValue / 60)) minutes"
        default:
            return String(format: "%.1f hours", absoluteValue / 3600)
        }
    }
}
