//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)

//方法一 直接使用set方法

//方法二 有序数组 删除重复元素
var numArray = [1,2,2,3,4,5,5,6,6]
let numArray1 = [1,2,2,3,4,5,5,6,6]
//使用快指针 和 移动指针的方法 时间复杂度O(1) 空间O(n)
func removeDuplicates<T:Comparable>(_ array:inout [T]) -> [T]? {
    let startTime = CFAbsoluteTimeGetCurrent()
    let length  = array.count
    var low :Int = 0
    var fast:Int = 1
    while fast < length{
        if array[low] != array[fast] {
            low += 1
            array[low] = array[fast]
        }else{
            fast += 1
        }
    }
    let endTime = CFAbsoluteTimeGetCurrent()
    print("time1=\((endTime - startTime)*1000)")
    return Array(array[0...low])
}

print(removeDuplicates(&numArray) ?? "")

//for 循环 时间复杂度 O（n） 空间 n*n

func removeDuplicatesTwo<T:Comparable>(_ target:[T])->[T] {
    let startTime = CFAbsoluteTimeGetCurrent()
    var result = [T]()
    for i in 0..<target.count{
        if !result.contains(target[i]){
            result.append(target[i])
        }
    }
    let endTime = CFAbsoluteTimeGetCurrent()
    print("time2=\((endTime - startTime)*1000)")
    return result
}

print(removeDuplicatesTwo(numArray1))
