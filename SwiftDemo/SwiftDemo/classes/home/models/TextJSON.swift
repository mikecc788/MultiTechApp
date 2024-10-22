//
//  TextJSON.swift
//  SwiftDemo
//
//  Created by chenliao on 2021/12/27.
//

import Foundation

struct TextJson:Codable{
    let status: Int
    let text: String
    let isCheck: Bool?
}


class TextClassJson: Codable{
    let status: Int
    let text: String
     
     init(status: Int, text:String){
        self.status = status
        self.text = text
     }
}
