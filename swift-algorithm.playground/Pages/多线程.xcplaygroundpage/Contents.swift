//: [Previous](@previous)

import Foundation
import UIKit
var greeting = "Hello, playground"

//: [Next](@next)

let q = DispatchQueue.main

for i in 0..<10{
    q.async{
        print("\(Thread.current) \(i)")
    }
}
print("睡会")
Thread.sleep(forTimeInterval: 2.0)
print("come here")
