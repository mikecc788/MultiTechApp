//
//  INN+Color.swift
//  AudioLatencyTester
//
//  Created by chenliao on 2021/10/29.
//

import Foundation
import UIKit

public extension UIColor{
    // MARK: 3.1、根据 十六进制字符串 颜色获取 RGB，如：#3CB371 或者 ##3CB371 -> 60,179,113
    /// 根据 十六进制字符串 颜色获取 RGB
    /// - Parameter hexString: 十六进制颜色的字符串，如：#3CB371 或者 ##3CB371 -> 60,179,113
    /// - Returns: 返回 RGB
    static func hexStringToColorRGB(hexString: String) -> (r: CGFloat?, g: CGFloat?, b: CGFloat?) {
        // 1、判断字符串的长度是否符合
        guard hexString.count >= 6 else {
            return (nil, nil, nil)
        }
        // 2、将字符串转成大写
        var tempHex = hexString.uppercased()
        // 检查字符串是否拥有特定前缀
        // hasPrefix(prefix: String)
        // 检查字符串是否拥有特定后缀。
        // hasSuffix(suffix: String)
        // 3、判断开头： 0x/#/##
        if tempHex.hasPrefix("0x") || tempHex.hasPrefix("##") {
            tempHex = String(tempHex[tempHex.index(tempHex.startIndex, offsetBy: 2)..<tempHex.endIndex])
        }
        if tempHex.hasPrefix("#") {
            tempHex = String(tempHex[tempHex.index(tempHex.startIndex, offsetBy: 1)..<tempHex.endIndex])
        }
        // 4、分别取出 RGB
        // FF --> 255
        var range = NSRange(location: 0, length: 2)
        let rHex = (tempHex as NSString).substring(with: range)
        range.location = 2
        let gHex = (tempHex as NSString).substring(with: range)
        range.location = 4
        let bHex = (tempHex as NSString).substring(with: range)
        // 5、将十六进制转成 255 的数字
        var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        return (r: CGFloat(r), g: CGFloat(g), b: CGFloat(b))
    }
    
    // MARK: 2.1、根据RGBA的颜色(方法)
    /// 根据RGBA的颜色(方法)
    /// - Parameters:
    ///   - r: red 颜色值
    ///   - g: green颜色值
    ///   - b: blue颜色值
    ///   - alpha: 透明度
    /// - Returns: 返回 UIColor
    static func color(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    // MARK: 2.2、十六进制字符串设置颜色(方法)
    static func hexStringColor(hexString: String, alpha: CGFloat = 1.0) -> UIColor {
        let newColor = hexStringToColorRGB(hexString: hexString)
        guard let r = newColor.r, let g = newColor.g, let b = newColor.b else {
            assert(false, "颜色值有误")
            return .white
        }
        return color(r: r, g: g, b: b, alpha: alpha)
    }
    
    // MARK: - hex 16 进制颜色 传入(Int) 0x000000
    convenience init(inn_Hex: Int, _ lgf_Alpha: Double = 1.0) {
        let r = CGFloat((inn_Hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((inn_Hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(inn_Hex & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: CGFloat(lgf_Alpha))
    }
    // MARK: - hex 16 进制颜色 传入(String) "000000"
    convenience init!(inn_HexString: String, _ inn_Alpha: Double = 1.0) {
        let scanner = Scanner(string: inn_HexString.replacingOccurrences(of: "#", with: ""))
        var rgbHex: UInt64 = 0
        guard scanner.scanHexInt64(&rgbHex) else {
            return nil
        }
        self.init(inn_Hex: Int(rgbHex), inn_Alpha)
    }
    
    // MARK: - rgb a
    @nonobjc
    convenience init(_ inn_Red: Int, _ inn_Green: Int, _ inn_Blue: Int, _ inn_Alpha: Double = 1.0) {
        self.init(red: CGFloat(inn_Red) / 255, green: CGFloat(inn_Green) / 255, blue: CGFloat(inn_Blue) / 255, alpha: CGFloat(inn_Alpha))
    }
    // MARK: -  随机颜色
    class func inn_RandomColor() -> UIColor {
        return UIColor.init(Int(arc4random() % 256 / 255), Int(arc4random() % 256 / 255), Int(arc4random() % 256 / 255))
    }
}
