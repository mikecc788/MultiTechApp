//
//  DataConverterTest.swift
//  BleToolsKit
//
//  测试 DataConverter 的 CRC 计算功能
//

import Foundation

// 测试 CRC 计算
func testCRCCalculation() {
    let hexString = "88dd1E00000000000000000000000000000000"
    let crc = DataConverter.calculateCRC(from: hexString)
    
    print("=== CRC 计算测试 ===")
    print("输入十六进制字符串: \(hexString)")
    print("计算的 CRC 值: \(crc)")
    
    // 手动验证
    var sum = 0
    var index = hexString.startIndex
    while index < hexString.endIndex {
        let endIndex = hexString.index(index, offsetBy: 2, limitedBy: hexString.endIndex) ?? hexString.endIndex
        let hexPair = String(hexString[index..<endIndex])
        if let value = Int(hexPair, radix: 16) {
            sum += value
            print("\(hexPair) = \(value), 累加和 = \(sum)")
        }
        index = endIndex
    }
    
    print("最终累加和: \(sum)")
    print("十六进制: \(String(format: "%X", sum))")
    print("取最后两位: \(crc)")
    print("")
}

// 测试数据转换
func testDataConversion() {
    let hexString = "88dd1E00"
    let data = DataConverter.dataWithHexString(hexString)
    
    print("=== 数据转换测试 ===")
    print("输入十六进制字符串: \(hexString)")
    print("转换的 Data: \(data as NSData)")
    print("Data 字节数: \(data.count)")
    print("")
}

// 测试完整流程
func testCompleteFlow() {
    print("=== 完整流程测试 ===")
    
    // 1. 原始指令
    let commandString = "88dd1E00000000000000000000000000000000"
    print("1. 原始指令: \(commandString)")
    
    // 2. 计算 CRC
    let crc = DataConverter.calculateCRC(from: commandString)
    print("2. CRC 校验值: \(crc)")
    
    // 3. 完整指令
    let fullCommand = commandString + crc
    print("3. 完整指令: \(fullCommand)")
    
    // 4. 转换为 Data
    let commandData = DataConverter.dataWithHexString(fullCommand)
    print("4. 指令 Data: \(commandData as NSData)")
    print("5. Data 字节数: \(commandData.count)")
    
    // 5. 验证每个字节
    let bytes = [UInt8](commandData)
    print("6. 字节数组:")
    for (index, byte) in bytes.enumerated() {
        print("   字节[\(index)] = 0x\(String(format: "%02X", byte)) (\(byte))")
    }
    print("")
}

// 运行所有测试
testCRCCalculation()
testDataConversion()
testCompleteFlow()

