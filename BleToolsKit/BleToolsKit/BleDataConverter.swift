//
//  BleDataConverter.swift
//  BleToolsKit
//
//  Created by app on 2025/10/20.
//

import Foundation

/// 数据转换工具类
internal final class BleDataConverter {
    
    // MARK: - String 转 Data
    
    /// 将十六进制字符串转换为 Data
    /// - Parameter hexString: 十六进制字符串，如 "0102FF"
    /// - Returns: Data 对象，如果格式错误返回 nil
    static func hexStringToData(_ hexString: String) -> Data? {
        var hex = hexString.replacingOccurrences(of: " ", with: "")
        hex = hex.replacingOccurrences(of: "0x", with: "")
        guard hex.count % 2 == 0 else { return nil }
        
        var data = Data()
        var index = hex.startIndex
        while index < hex.endIndex {
            let nextIndex = hex.index(index, offsetBy: 2)
            guard let byte = UInt8(hex[index..<nextIndex], radix: 16) else { return nil }
            data.append(byte)
            index = nextIndex
        }
        return data
    }
    
    // MARK: - Data 转 String
    
    /// 将 Data 转换为十六进制字符串
    /// - Parameter data: Data 对象
    /// - Returns: 十六进制字符串，如 "0102FF"
    static func dataToHexString(_ data: Data) -> String {
        return data.map { String(format: "%02X", $0) }.joined()
    }
    
}

// MARK: - String Extension（保持向后兼容）
internal extension String {
    /// 将十六进制字符串转换为 Data（兼容旧代码）
    func hexToData() -> Data? {
        return BleDataConverter.hexStringToData(self)
    }
}

