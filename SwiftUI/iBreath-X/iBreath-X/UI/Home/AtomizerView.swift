//
//  AtomizerView.swift
//  iBreath-X
//
//  Created by app on 2024/9/5.
//

import SwiftUI
import CoreBluetooth

struct AtomizerView: View {
    var peripheral: CBPeripheral
    var body: some View {
        VStack {
            
            Text("Hello, World! \(peripheral.name ?? "Known")")
        }.onAppear{
            BluetoothManager.shared.connect(to: peripheral)
        }
    }
}

//#Preview {
//    AtomizerView()
//}
