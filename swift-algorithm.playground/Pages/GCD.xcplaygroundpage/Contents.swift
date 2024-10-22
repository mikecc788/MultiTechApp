//: [Previous](@previous)

import Foundation
import UIKit

let mainQueue = DispatchQueue.main
let globalQueue = DispatchQueue.global()
//串行队列，label名字随便取
let serialQueue = DispatchQueue(label: "test")
//并行队列
let concurrentQueue = DispatchQueue(label: "test", attributes: .concurrent)

print("0\(Thread.current)")
  
DispatchQueue.main.async {
    mainQueue.async {
        print("1\(Thread.current)")
    }
//      globalQueue.async {
//          print("1\(Thread.current)")
//      }
    
}

print("2\(Thread.current)")

let itme1 = DispatchWorkItem{
    for i in 0...4{
            print("item1 -> \(i)  thread: \(Thread.current)")
        }

}

@objc protocol Drawable {
    func draw()
    @objc optional func click()
}
class Circle: Drawable {
    
    
    func draw() {
        print("绘制一个圆形")
    }
}

class Rectangle: Drawable {
    func click() {
        print("click")
    }
    
    func draw() {
        print("绘制一个矩形")
    }
}

let shapes: [Drawable] = [Circle(), Rectangle()]

for shape in shapes {
    shape.draw()
    shape.click?()
}
