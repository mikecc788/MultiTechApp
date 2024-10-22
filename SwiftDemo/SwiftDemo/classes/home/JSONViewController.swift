//
//  JSONViewController.swift
//  SwiftDemo
//
//  Created by chenliao on 2021/12/24.
//

import UIKit
import SwiftyJSON
import Dollar
class JSONViewController:UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
//        paserJSON()
        
//        dollarArrayTest()
        
        
//        test2()
        
//        test3()
        
//        test4()
//        test5()
        
//        test6()
        test7()
        
    }
    func test7(){
        let json = """
            {
                "first_name": "funcc",
                "points": 200,
                "description": "A handsome boy."
            }
        """
        
        let jsonData = json.data(using: .utf8)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        if let data = jsonData{
            let result = try? decoder.decode(APerson.self, from: data)
            print(result ?? "解析失败")
            print(result!.firstName)
        }
        
        
    }
    
    func test6(){
        let jsonString = """
        {
            "location": [20, 10]
        }
        """
    
        let jsonData = jsonString.data(using: .utf8)
        let decoder = JSONDecoder()
        let result = try! decoder.decode(RawSeverResponse.self, from: jsonData!)
        print(result.location.x)
    }
    
    func test5(){
//  值为null      将可能出现问题的属性设置为可选值即可


        let jsonString = """
        {
                "name": "Cat",
                "className": null,
                "courceCycle": 15
            }
        """
        let jsonData = jsonString.data(using: .utf8)
        let decoder = JSONDecoder()
        if let data = jsonData{
            let result = try? decoder.decode(car.self, from: data)
            print(result ?? "解析失败")
        }
    }
    
    
    func test4(){
        let jsonString = """
        [
            {
                "name": "Kody",
                "className": "Swift",
                "courceCycle": 12
            },{
                "name": "Cat",
                "className": "强化班",
                "courceCycle": 15
            },{
                "name": "Hank",
                "className": "逆向班",
                "courceCycle": 22
            },{
                "name": "Cooci",
                "className": "大师班",
                "courceCycle": 22
            }
        ]
        """
        //在decode时传输数组类型
        let jsonData = jsonString.data(using: .utf8)
        let decoder = JSONDecoder()
        if let data = jsonData{
            let result = try? decoder.decode([Person].self, from: data)
            print(result ?? "解析失败")
            
            for info in result!{
                print(info.name)
            }
        }
    }
    
    func test3(){
        let jsonString = """
        {
            "name": "Kody",
            "className": "Swift",
            "courceCycle": 10,
            "personInfo": {
                "age": 18,
                "height": 1.85
             },
        
            "studentInfo":[
                {
                    "age": 23,
                    "height":1.9
        
                },{
                    "age": 13,
                    "height":1.7
                }
            ]
        }
        """
                
        let jsonData = jsonString.data(using: .utf8)
        let decoder = JSONDecoder()
        if let data = jsonData{
            let result = try? decoder.decode(Teacher.self, from: data)
            print(result ?? "解析失败")
            print(result!.personInfo.age)
        }
    }
    
    func test2(){
        let makeModel = TextClassJson(status:10,text:"json")

        let jsonData = try! JSONEncoder().encode(makeModel)
        
        let data = try! JSONDecoder().decode(TextClassJson.self, from:jsonData)
        print(data.status, data.text)
    }
    
    func test1(){
        let makeModel = TextJson(status:10,text:"json",isCheck: false)

        let jsonData = try! JSONEncoder().encode(makeModel)

        let jsonStr = String(data:jsonData, encoding: .utf8)
        print(jsonStr!)
        
        let data = try! JSONDecoder().decode(TextJson.self, from:jsonData)
        print(data)
    }
    
    func dollarArrayTest(){
        
        print(Dollar.at(["ant","bat","cat","dog","egg"], indexes: [0,2,4]))
        let dict:Dictionary<String,Int> = ["Dog":1,"Cat":2]

        let dict2:Dictionary<String,Int> = ["Cow":3]
        
        print(Dollar.merge(dict,dict2))
    }
    
    func paserJSON(){
        
        let  jsonStr =  "[{\"name\": \"hangge\", \"age\": 100, \"phones\": [{\"name\": \"公司\",\"number\": \"123456\"}, {\"name\": \"家庭\",\"number\": \"001\"}]}, {\"name\": \"big boss\",\"age\": 1,\"phones\": [{ \"name\": \"公司\",\"number\": \"111111\"}]}]"
        
        let jsonData = jsonStr.data(using: .utf8)
        let  json = try! JSON (data: jsonData!)
        
        let name = json[1]["phones"].arrayValue
        print(json)
        print(type(of: name))
        
        for data in name{
            print(data)
        }
    }
}
