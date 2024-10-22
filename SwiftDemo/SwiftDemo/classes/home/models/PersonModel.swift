//
//  PersonModel.swift
//  SwiftDemo
//
//  Created by chenliao on 2021/12/27.
//

import Foundation
//JSON数据是一组数组集合
struct Person: Codable{
    var name: String
    var className: String
    var courceCycle: Int
}


struct car:Codable{
    var name: String
    var className: String?
    var courceCycle: Int
}

struct LGPerson:Decodable{
    let elements: [String]
       
    enum CodingKeys: String, CaseIterable, CodingKey {
       case item0 = "item.0"
       case item1 = "item.1"
       case item2 = "item.2"
       case item3 = "item.3"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var element: [String]  = []
        for item in CodingKeys.allCases{
            guard container.contains(item) else { break }
            
            element.append(try container.decode(String.self, forKey: item))
        }
        
        self.elements = element
    }
       
}

