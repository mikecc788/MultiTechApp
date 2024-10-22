//
//  DeLorean.swift
//  SwiftDemo
//
//  Created by chenliao on 2021/12/16.
//

import Foundation


final class DeLorean: TimeTraveling {
    func travelInTime(time: TimeInterval) -> String {
        return "Used Flux Capacitor and travelled in time by: \\(time)s"
    }
}
