//
//  TestPerson.swift
//  SwiftDemo
//
//  Created by chenliao on 2021/12/27.
//

import Foundation
///后台系统使用的命名规则有可能与前端不一致
/// 只需修改模型，实现CodingKey协议
struct APerson:Codable{
    
    var firstName : String
    var points : Int
    var description : String
    /// 自定义字段属性
  /// 注意 1.需要遵守Codingkey  2.每个字段都要枚举
    enum Codingkeys:String,CodingKey {
        case firstName = "first_Name"
        case points
        case description
    }
}


