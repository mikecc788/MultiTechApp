//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)

// 二分查找仅适用于有序数组
// 不断的将数组分成两半进行查找
//给定一个数字13 你需要找到它的索引 然后去删除和修改它 使用二分查找  也可以找17或者 19
let numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]

// 传入的参数 可以比较 Comparable
public func binarySearch<T:Comparable>(_ arr:[T],_ key:T) -> Int?{
    let startTime = CFAbsoluteTimeGetCurrent()
    var start = 0
    var end = arr.count - 1
    print("start=\(start) end=\(end)")
    while start <= end {
        let mid  = (start + end) / 2
        print("start=\(start) end=\(end) mid=\(mid)")
        if arr[mid] == key {
            return mid
        }else if arr[mid] < key{
            start = mid + 1
        }else {
            end = mid - 1
        }
        let endTime = CFAbsoluteTimeGetCurrent()
        print("time=\((endTime - startTime)*1000)")
    }

    return nil
    
}

print(binarySearch(numbers,19) ?? "")

