//
//  PeripheralsManager.swift
//  iBreath-X
//
//  Created by app on 2024/9/5.
//

import Foundation
class PeripheralsManager: ObservableObject {
    static let shared = PeripheralsManager()
    
    @Published var connectedPeripheral: DiscoveredPeripheral?
    
    func disconnect() {
        connectedPeripheral = nil
    }
}
