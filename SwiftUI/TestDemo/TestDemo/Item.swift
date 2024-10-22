//
//  Item.swift
//  TestDemo
//
//  Created by app on 2024/8/20.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
