//
//  ViewController.swift
//  SwiftDemo
//
//  Created by chenliao on 2021/12/16.
//

import UIKit

class ViewController: UIViewController {
    let customB = ACustomButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
//        let time = DeLorean()
//        let str = time.travelInTime(time: 1000)
//        print(str)
//        customB.delegate = self
//        customB.didClick()
//        self.DispatchQueueDemo1()
        
        var a1 = [-1,3,10,6,9,4,39,24,17]
        
    }
    
    
    func findKthLargest(_ nums: [Int], k: Int) -> Int? {
        guard k > nums.count else {
            return nil
        }
        
        if nums.count <= 1 {
            return nums.first ?? 0
        }
        var pivot = nums[Int.random(in: 0 ..< nums.count)]
        // print("nums: \(nums)")
        // print("pivot: \(pivot)")
        var small = [Int]()
        var large = [Int]()
        var count = 0
        for n in nums {
            if n > pivot {
                large.append(n)
            } else if n < pivot {
                small.append(n)
            } else {
                count += 1
            }
        }
        if large.count >= k {
            // print("1")
            return findKthLargest(large, k: k)
        } else if large.count + count >= k {
            // print("2")
            return pivot
        } else {
            // print("3")
            return findKthLargest(small, k: k - large.count - count)
        }
    }

    
    
}

//extension ViewController:CustomButtonDelegate{
//    func CustomButtonDidClick() {
//        print("delegate works")
//    }
//
//}

//MARK: - GCD
extension ViewController{
    func DispatchQueueDemo1(){
        let item1 = DispatchWorkItem {
            for i in 0...4{
                print("item1 -> \(i)  thread: \(Thread.current)")
            }
        }
        let item2 = DispatchWorkItem {
            for i in 0...4{
                print("item2 -> \(i)  thread: \(Thread.current)")
            }
        }
        
//        //主队列追加异步任务，按顺序打印
//        let mainQueue = DispatchQueue.main
//        mainQueue.async(execute: item1)
//        mainQueue.async(execute: item2)
//
//        //全局队列追加异步任务，随机打印
//        let globalQueue = DispatchQueue.global()
//        globalQueue.async(execute: item1)
//        globalQueue.async(execute: item2)
        
        //自定义串行队列追加异步任务，按顺序打印
        let serialQueue = DispatchQueue(label: "serial")
        serialQueue.async(execute: item1)
        serialQueue.async(execute: item2)
        
        //主队列追加同步任务，会引起死锁
        /**
        let mainQueue = DispatchQueue.main
        mainQueue.sync(execute: item1)
        mainQueue.sync(execute: item2)
         */
        
    }
}
