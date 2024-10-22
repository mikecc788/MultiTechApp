//
//  UINotificationFeedbackGenerator.swift
//  TestDemo
//
//  Created by app on 2024/8/21.
//

import UIKit
extension UINotificationFeedbackGenerator {
 public enum FeedbackType : Int, @unchecked Sendable {
 case success = 0
 case warning = 1
 case error = 2
 }
}
