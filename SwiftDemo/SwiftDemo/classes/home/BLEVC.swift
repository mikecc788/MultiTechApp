//
//  BLEVC.swift
//  SwiftDemo
//
//  Created by app on 2022/3/3.
//

import Foundation
import UIKit
import CoreBluetooth
class BLEVC:BaseViewController,BluetoothDelegate{
    
    
    let bluetoothManager = LFSBLEManager.getInstance()
    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton.init(frame: CGRect.init(x: 50, y: 150, width: 100, height: 50))
        btn.title("扫描")
        btn.backgroundColor = .gray
        btn.addTarget(self, action: #selector(click(btn:)), for: .touchUpInside)
        self.view.addSubview(btn)
        
        
    }
    
    @objc func click(btn:UIButton){
        print("......")
        
        bluetoothManager.startScanPeripheral()
    }
    
    func didUpdateState(_ state: CBManagerState) {
        print("BLEVC --> didUpdateState:\(state)")
        
    }
}

