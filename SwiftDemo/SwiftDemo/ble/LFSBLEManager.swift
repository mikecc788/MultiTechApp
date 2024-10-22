//
//  LFSBLEManager.swift
//  SwiftDemo
//
//  Created by app on 2022/3/3.
//

import Foundation
import CoreBluetooth

class LFSBLEManager:NSObject{
    var _manager : CBCentralManager?
    var delegate : BluetoothDelegate?
    private(set) var connected = false
    var state: CBManagerState? {
        guard _manager != nil else {
            return nil
        }
        return CBManagerState(rawValue: (_manager?.state.rawValue)!)
    }
    private var isConnecting = false
    private(set) var connectedPeripheral : CBPeripheral?
    private(set) var connectedServices : [CBService]?
    /// Save the single instance
    static private var instance : LFSBLEManager {
        return sharedInstance
    }
    
    private static let sharedInstance = LFSBLEManager()
    private override init() {
        super.init()
        initCBCentralManager()
    }
    // MARK: Custom functions
    
    func initCBCentralManager() {
        var dic : [String : Any] = Dictionary()
        dic[CBCentralManagerOptionShowPowerAlertKey] = false
        _manager = CBCentralManager(delegate: self, queue: nil, options: dic)
        
    }
    
    static func getInstance() -> LFSBLEManager {
        return instance
    }
    
    func startScanPeripheral() {
        _manager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
    }
    /**
     The method provides for stopping scan near by peripheral
     */
    func stopScanPeripheral() {
        _manager?.stopScan()
    }
    
}
extension LFSBLEManager:CBCentralManagerDelegate{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if #available(iOS 10.0, *) {
            
            switch central.state {
            case .poweredOff:
                print("State : Powered Off")
            case .poweredOn:
                print("State : Powered On")
            case .resetting:
                print("State : Resetting")
            case .unauthorized:
                print("State : Unauthorized")
            case .unknown:
                print("State : Unknown")
            case .unsupported:
                print("State : Unsupported")
            @unknown default:
                print("fail")
            }
            if let state = self.state {
                delegate?.didUpdateState?(state)
            }
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Bluetooth Manager --> didDiscoverPeripheral, RSSI:\(RSSI)")
        delegate?.didDiscoverPeripheral?(peripheral, advertisementData: advertisementData, RSSI: RSSI)
    }
    
}
