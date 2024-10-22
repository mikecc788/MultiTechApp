//
//  GenericViewController.swift
//  SwiftDemo
//
//  Created by chenliao on 2021/12/29.
//

import Foundation
class GenericViewController:BaseViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        demo1()
        ///闭包
        demo2()
        
    }
    func demo2(){
       
//        func sumFunc(v1: Int, v2: Int) -> Int { return v1 + v2 }
//        print( sumFunc(v1: 1, v2: 2))
        
        let driving = {(place:String) ->String in
            
            return "take car\(place)"
        }
        
//        print(driving("hello"))
        
        let dri = {
            print("aaaa")
        }
        
        travel(action: dri)
        
        var i = 1
        let closure = {
            print("closure \(i)")
        }
        
        i += 1
        print("before \(i)")
        closure() //执行的时候捕获值
        print("after \(i)")
        
        
    }
    
    func travel(action:()->Void){
        print("start")
        action()
        print("over")
    }
    
    
    func demo1(){
        var stack = Instack<Any>()
        stack.push(2)
        stack.push(4)
        stack.push(6)
        print(stack.items)
        stack.pop()
        print(stack.items)
        
        stack.push("hello")
        print(stack.items)
        print(stack.topItem)
        
        let doubleIndex = findIndex(of: "hello", in: ["hello","lllli","wwww"])
        print(doubleIndex)
    }
    ///Equatable 传入的任意参数必须能比较
    func findIndex<T:Equatable>(of valueToFInd:T,in array:[T])->Int?{
        for (index ,value) in array.enumerated(){
            if value == valueToFInd{
                return index
            }
        }
        return nil
    }
    
}

struct Instack<ElementType>{
    var items = [ElementType]()
    
    mutating func push(_ item:ElementType){
        items.append(item)
    }
    
    mutating func pop()->ElementType{
        return items.removeLast()
    }
    
}

extension Instack{
    var topItem:ElementType?{
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

protocol Container{
    associatedtype Item
}
