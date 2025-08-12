//
//  BluetoothExtensions.swift
//  SwiftDemo
//
//  Created by app on 2025/8/11.
//

import Foundation
import CoreBluetooth
public extension CBPeripheral {
    /// 根据服务 UUID 查找服务
    func service(_ uuid: CBUUID) -> CBService? {
        services?.first(where: { $0.uuid == uuid })
    }

    /// 根据服务/特征 UUID 查找特征
    func characteristic(_ char: CBUUID, in serviceUUID: CBUUID) -> CBCharacteristic? {
        service(serviceUUID)?.characteristics?.first(where: { $0.uuid == char })
    }
}

public extension Dictionary where Key == String, Value == Any {
    /// 解析本地名（可选）
    var localName: String? { self[CBAdvertisementDataLocalNameKey] as? String }
}


public extension CBCharacteristicProperties {
    var stringRepresentation: String {
        var strings: [String] = []
        if contains(.broadcast) { strings.append("广播") }
        if contains(.read) { strings.append("读") }
        if contains(.writeWithoutResponse) { strings.append("无应答写") }
        if contains(.write) { strings.append("写") }
        if contains(.notify) { strings.append("通知") }
        if contains(.indicate) { strings.append("指示") }
        if contains(.authenticatedSignedWrites) { strings.append("认证写") }
        return strings.joined(separator: ", ")
    }
}

public extension Data {
    init?(hexString: String) {
        let cleaned = hexString.replacingOccurrences(of: " ", with: "")
                               .replacingOccurrences(of: "\n", with: "")
                               .replacingOccurrences(of: "0x", with: "")
                               .replacingOccurrences(of: "0X", with: "")
        guard cleaned.count % 2 == 0 else { return nil }
        var bytes = [UInt8]()
        bytes.reserveCapacity(cleaned.count/2)
        var index = cleaned.startIndex
        while index < cleaned.endIndex {
            let next = cleaned.index(index, offsetBy: 2)
            guard next <= cleaned.endIndex,
                  let b = UInt8(cleaned[index..<next], radix: 16) else { return nil }
            bytes.append(b)
            index = next
        }
        self = Data(bytes)
    }
}

