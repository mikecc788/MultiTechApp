//
//  Teacher.swift
//  SwiftDemo
//
//  Created by chenliao on 2021/12/27.
//

import Foundation
struct Teacher: Codable{
    var name: String
    var className: String
    var courceCycle: Int
    var personInfo: PersonInfo
    
    var studentInfo:[StudentInfo]
}
extension Teacher{
    struct PersonInfo:Codable{
        var age:Int
        var height:Double
    }
    
    struct StudentInfo:Codable{
        var age:Int
        var height:Double
    }
}


struct Location:Codable{
    var x: Double
    var y: Double
    init(from decoder: Decoder) throws {
        var contaioner = try decoder.unkeyedContainer()
        self.x = try contaioner.decode(Double.self)
        self.y = try contaioner.decode(Double.self)
    }
}

struct RawSeverResponse: Codable{
    var location: Location
    
}

struct LGTeacher:Codable{
    var name: String
    var className: String
    var courceCycle: Int
    var date: Date
}
