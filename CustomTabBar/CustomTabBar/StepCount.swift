//
//  StepCount.swift
//  CustomTabBar
//
//  Created by app on 2022/12/27.
//

import SwiftUI

struct StepCount: Identifiable {
    let id = UUID()
    
    let weekday:Date
    let steps:Int
    
    init(day: String, steps: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        self.weekday = formatter.date(from: day) ?? Date.distantPast
        self.steps = steps
    }
    
}

let currentWeek : [StepCount] = [
    StepCount(day: "20220717", steps: 4200),
    StepCount(day: "20220718", steps: 15000),
    StepCount(day: "20220719", steps: 2800),
    StepCount(day: "20220720", steps: 10800),
    StepCount(day: "20220721", steps: 5300),
    StepCount(day: "20220722", steps: 10400),
    StepCount(day: "20220723", steps: 4000)
]

