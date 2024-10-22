//
//  StatiticsModel.swift
//  iBreath-X
//
//  Created by app on 2024/8/24.
//

import Foundation
struct StatiticsModel: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}
