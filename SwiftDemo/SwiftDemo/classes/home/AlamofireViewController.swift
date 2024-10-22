//
//  AlamofireViewController.swift
//  SwiftDemo
//
//  Created by chenliao on 2021/12/24.
//

import UIKit
import Alamofire


/// 定义个遵守Codable的模型
struct Item: Codable {
    var topicOrder: Int?
    var id: Int?
    var topicDesc: String?
    var topicTittle: String?
    var upTime: String?
    var topicImageUrl: String?
    var topicStatus: Int?
}

class AlamofireViewController:UIViewController{
    var manager: Alamofire.Session?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        AF.request("https://www.baidu.com").response{
            response in
            print(response)
        }
        
    }
}
