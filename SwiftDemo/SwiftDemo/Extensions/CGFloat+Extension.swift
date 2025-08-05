//
//  CGFloat+Extension.swift
//  AudioLatencyTester
//
//  Created by chenliao on 2021/10/29.
//

import UIKit
extension CGFloat: INNPOPCompatible {}

// MARK: - 一、CGFloat 的基本转换
public extension INNPOP where Base == CGFloat {

    // MARK: 1.1、转 Int
    /// 转 Int
    var int: Int { return Int(self.base) }
    
    // MARK: 1.2、转 CGFloat
    /// 转 CGFloat
    var cgFloat: CGFloat { return self.base }
    
    // MARK: 1.3、转 Int64
    /// 转 Int64
    var int64: Int64 { return Int64(self.base) }
    
    // MARK: 1.4、转 Float
    /// 转 Float
    var float: Float { return Float(self.base) }
    
    // MARK: 1.5、转 String
    /// 转 String
    var string: String { return String(self.base.inn.double) }
    
    // MARK: 1.6、转 NSNumber
    /// 转 NSNumber
    var number: NSNumber { return NSNumber(value: self.base.inn.double) }
    
    // MARK: 1.7、转 Double
    /// 转 Double
    var double: Double { return Double(self.base) }
}

// MARK: - 二、角度和弧度相互转换
public extension INNPOP where Base == CGFloat {
    
    // MARK: 角度转弧度
    /// 角度转弧度
    /// - Returns: 弧度
    func degreesToRadians() -> CGFloat {
        return (.pi * self.base) / 180.0
    }
    
    // MARK: 弧度转角度
    /// 角弧度转角度
    /// - Returns: 角度
    func radiansToDegrees() -> CGFloat {
        return (self.base * 180.0) / .pi
    }
}

extension CGFloat {
    /// 根据设计稿尺寸适配
    var adapted: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return (screenWidth / 375.0) * self
    }
}
// Double 扩展
extension Double {
    var adapted: CGFloat {
           return CGFloat(self).adapted
       }
}

// Int 扩展
extension Int {
    var adapted: CGFloat {
            return CGFloat(self).adapted
        }
}
