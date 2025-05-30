//
//  Dictionary+Extension.swift
//  iBreath-X
//
//  Created by app on 2024/8/22.
//

import Foundation

extension Dictionary where Key == String,Value:Any {
    func toJsonString() -> String? {
        if let data = try? JSONSerialization.data(withJSONObject: self, options:[]) {
            return String(data:data, encoding: .utf8)
        }
        else {
            return nil
        }
    }
    
    func toJsonData() -> Data? {
        if let data = try? JSONSerialization.data(withJSONObject: self, options:[]) {
            return data
        }
        else {
            return nil
        }
    }
}
