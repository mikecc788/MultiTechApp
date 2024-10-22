//
//  INN+NSObject.swift
//  AudioLatencyTester
//
//  Created by chenliao on 2021/10/29.
//

import Foundation
public protocol ClassNameProtocol {
    static var inn_ClassName: String { get }
    var inn_ClassName: String { get }
}
// MARK: - 便捷获取当前类名字符串
public extension ClassNameProtocol {
    static var inn_ClassName: String {
        return String.init(describing: self)
    }
    var inn_ClassName: String {
        return Self.inn_ClassName
    }
}
extension NSObject: ClassNameProtocol {}
// MARK: - 获取 object 描述
public extension NSObjectProtocol {
    var describedProperty: String {
        let mirror = Mirror(reflecting: self)
        return mirror.children.map { element -> String in
            let key = element.label ?? "Unknown"
            let value = element.value
            return "\(key): \(value)"
            }
            .joined(separator: "\n")
    }
}
