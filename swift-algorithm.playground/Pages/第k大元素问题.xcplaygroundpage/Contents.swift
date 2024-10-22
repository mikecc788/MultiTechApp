//: [Previous](@previous)

//你有一个整数数组a。 编写一个算法，在数组中找到第k大的元素
//O(nlogn)  因为它首先对数组进行排序，因此也使用额外的 O(n) 空间
import Foundation

var a1 = [-1,3,10,6,9,4,39,24,17]

func kthLargest(_ a: [Int], _ k: Int) -> Int? {
    let length = a.count
    if k > 0 && k <= length{
        let bbbbb = a.sorted()
        return bbbbb[length - k]
        
    }
       
    else{
        return nil
    }
        
}
//print(kthLargest(a1,4)!)

/**
 方法二  寻找第k大元素
 */
func findKthLargest(_ nums: [Int], k: Int) -> Int? {
    guard k <= nums.count else {
        print("-------")
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

func quickSelect(_ array: [Int], k: Int) -> Int? {
    guard k <= array.count else {
        return nil
    }
    
    if array.count <= 1 {
        return array.first ?? 0
    }
    var pivot = array.randomElement()!
    
    let left = array.filter { $0 < pivot }
    let right = array.filter { $0 > pivot }
    let pivotCount = array.count - left.count - right.count
    print("pivotCount=\(pivotCount)")
    if right.count >= k {
         print("1")
        return quickSelect(right, k: k)
    } else if right.count + pivotCount >= k {
         print("2")
        return pivot
    } else {
        // print("3")
        return quickSelect(left, k: k - right.count - pivotCount)
    }
}

print(quickSelect(a1, k: 4))

print(findKthLargest(a1, k: 3))

/**
 方法三
 */
//有一种聪明的算法结合了二分搜索和快速排序的思想来达到O(n)解决方案
//<T:Comparable>
func randomizedSelect<T>(_ a:inout [T], _ low:Int,_ high:Int,_ k:Int)->T{
    if(low < high){
        return a[low]
    }else{
        return a[high]
    }
}

//print(randomizedSelect(&a1, 0, a1.count-1,4))

//: [Next](@next)
