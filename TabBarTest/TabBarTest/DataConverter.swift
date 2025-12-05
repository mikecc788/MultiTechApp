//
//  DataConverter.swift
//  TabBarTest
//
//  Created by app on 2025/11/5.
//

import Foundation

import Foundation

final class DataConverter {
    
    /// 将十六进制字符串转换为 Data
    /// - Parameter hexString: 仅包含 0-9A-F 的十六进制字符串，可大写或小写
    /// - Returns: 转换后的 Data，如果字符串无效则返回空 Data
    static func data(from hexString: String) -> Data {
        var data = Data()
        var hex = hexString
        
        // 去除空格和换行符
        hex = hex.replacingOccurrences(of: " ", with: "")
                   .replacingOccurrences(of: "\n", with: "")
        
        // 若长度为奇数，补 0
        if hex.count % 2 != 0 {
            hex = "0" + hex
        }
        
        var index = hex.startIndex
        while index < hex.endIndex {
            let nextIndex = hex.index(index, offsetBy: 2)
            let byteString = hex[index..<nextIndex]
            if let byte = UInt8(byteString, radix: 16) {
                data.append(byte)
            }
            index = nextIndex
        }
        return data
    }
}


extension NSData {
    /// 将十六进制字符串转换为 NSData
    /// - Parameter hexString: 形如 "88dd1f1503..." 的十六进制字符串
    /// - Returns: NSData 对象
    class func dataWithHexString(_ hexString: String) -> NSData {
        let data = NSMutableData()
        var hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
                           .replacingOccurrences(of: " ", with: "")
        
        // 补齐奇数位（防止崩溃）
        if hex.count % 2 != 0 {
            hex = "0" + hex
        }

        var index = hex.startIndex
        while index < hex.endIndex {
            let nextIndex = hex.index(index, offsetBy: 2)
            let byteString = hex[index..<nextIndex]
            if let byte = UInt8(byteString, radix: 16) {
                var value = byte
                data.append(&value, length: 1)
            }
            index = nextIndex
        }
        return data
    }
    ///NSData 再转回十六进制字符串
    func hexString() -> String {
        var bytes = [UInt8](repeating: 0, count: self.length)
        self.getBytes(&bytes, length: self.length)
        return bytes.map { String(format: "%02x", $0) }.joined()
    }
}
