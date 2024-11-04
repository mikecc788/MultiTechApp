//
//  BluetoothDelegate.swift
//  SwiftDemo
//
//  Created by app on 2022/3/3.
//

import Foundation
import CoreBluetooth

@objc protocol BLEManagerDelegate: NSObjectProtocol {
    
    @objc optional func bleManagerDidUpdateState(_ state: CBManagerState)
    @objc optional func bleManagerDidStartScan()
    @objc optional func bleManagerDidStopScan()
        
    @objc optional func bleManagerDidUpdateDevices(_ devices: [BLEDeviceModel])
    
    @objc optional func bleManagerDidConnect(_ peripheral: CBPeripheral)
    
    @objc optional func bleManagerDidDisconnect(_ peripheral: CBPeripheral, error: Error?)
    
    @objc optional func bleManagerDidFailToConnect(_ peripheral: CBPeripheral, error: Error)
    
    @objc optional func bleManagerDidDiscoverServices(_ services: [CBService])
    
    @objc optional func bleManagerDidDiscoverCharacteristics(_ characteristics: [CBCharacteristic], for service: CBService)
    @objc optional func didFailToDiscoverCharacteritics(_ error: Error)
    @objc optional func didDiscoverDescriptors(_ characteristic: CBCharacteristic)
    @objc optional func didFailToDiscoverDescriptors(_ error: Error)
    
    @objc optional func bleManagerDidUpdateValue(_ data: Data, for characteristic: CBCharacteristic)
    @objc optional func bleManagerDidWriteValue(for characteristic: CBCharacteristic, error: Error?)
    
    @objc optional func didFailToReadValueForCharacteristic(_ error: Error)
}
