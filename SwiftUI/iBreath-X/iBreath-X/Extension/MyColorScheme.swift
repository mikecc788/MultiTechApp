//
//  MyColorScheme.swift
//  iBreath-X
//
//  Created by app on 2024/8/22.
//


import SwiftUI
struct MyColorScheme {
    static let background = Color.gray
    static let text = Color.red
    static let buttonBackground = Color.teal
    static let border = Color.black
    static let bgColor = Color.init(hex: "F5F5F5")
    let background = Color("BackgroundColor")
    
}
extension Color {
    static var mainColor: Color {
        Color("MainColor")
    }
    static var darkBlue: Color {
        Color("DarkColor")
    }
    static var textFieldColor: Color {
        Color("textFieldColor")
    }
    
}
extension Color {
    static let theme = MyColorScheme()
}

extension Color {
    
    // Color -> UIColor
    func toUIColor() -> UIColor {
        if let components = self.cgColor?.components {
            return UIColor(displayP3Red: components[0], green: components[1], blue: components[2], alpha: components[3])
        } else {
            return UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
    }
    
    // Color -> RGB
    func toRGB() -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        if let components = self.cgColor?.components {
            return (red: components[0], green: components[1], blue: components[2])
        } else {
            return (red: 0.0, green: 0.0, blue: 0.0)
        }
    }
    // Color -> color code
    func toColorCode() -> String {
        if let components = self.cgColor?.components {
            let rgb: [CGFloat] = [components[0], components[1], components[2]]
            return rgb.reduce("") { res, value in
                let intval = Int(round(value * 255))
                return res + (NSString(format: "%02X", intval) as String)
            }
        } else {
            return ""
        }
    }
    // Color(hex: color code)
    init(hex: String) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b)
    }
}
