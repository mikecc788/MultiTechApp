//
//  TimeTraveling.swift
//  SwiftDemo
//
//  Created by chenliao on 2021/12/16.
//

import Foundation
import UIKit

protocol TimeTraveling {
    func travelInTime(time: TimeInterval) -> String
}


protocol CustomButtonDelegate: AnyObject{
    func CustomButtonDidClick()
}
