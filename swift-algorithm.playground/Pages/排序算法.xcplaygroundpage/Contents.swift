//: [Previous](@previous)

import Foundation

//无序数组中的最大中位数
var initialArr:Array = [12,3,10,8,6,7,11,13,9]

//判断n的个数为奇数还是偶数

func partSort(_ array:[Int],_ start:Int, _ end:Int) ->Int{
    var low = start
    var high = end
    //选取关键字
    let key = array[high]
    while low < high {
        //左边找比key大的值
        while low < high && array[low] < key {
            low += 1
        }
        //右边找比key小的值
        while low < high && array[high] > key {
             high -= 1
        }
        if low < high {
//            var temp = array[low]
//            array[low] = array[high]
            
        }
    }
    return low
}

//print(partSort(initialArr, 0, 8))

//冒泡排序 时间复杂度 n*n 空间 1
var sortArr:Array = [12,3,10,8,6,7,11,13,9]
func buddleSort(_ array:inout [Int]) -> [Int]{
    var temp = [Int]()
    for i in 0..<array.count{
        for j in i+1..<array.count{
            if array[j] < array[i] {
                var temp = array [i]
                array[i] = array[j]
                array[j] = temp
            }
        }
    }
    return array
}
//print(buddleSort(&sortArr))

/**
 选择排序
 找到最小的值 与它比较
 */
// [12,3,10,8,6,7,11,13,9]
func selectSort(_ array:inout [Int]) -> [Int]{
    
    for i  in 0..<array.count {
        var min = i
        for j in i+1..<array.count{
            if array[j]<=array[min]{
                min = j
            }
        }
        
        let minValue = array[min]
        array[min] = array[i]
        array[i] = minValue
    }
    
    return array
}
//print(selectSort(&sortArr))

/**
 归并排序 利用递归
 */
var arr2 = [12,3,10,8,6,7,11,13,9]
func mergeSort(_ array: inout [Int]) -> [Int]{
    guard array.count > 1 else{return array}
    let middleIndex = array.count / 2
  
    // 将原数组拆分成左右两个子数组
    var leftArray = Array(array[0..<middleIndex])
    var rightArray = Array(array[middleIndex..<array.count])
//    print("left=\(leftArray)"+"rightArray=\(rightArray)")
    mergeSort(&leftArray)
    mergeSort(&rightArray)
//    print("left====\(leftArray)"+"rightArray====\(rightArray)")
    array = merge(leftArray, rightArray)
    return array
}
/**
 理解
 当我们合并两个已排好序的子数组时，我们需要用到两个指针 leftIndex 和 rightIndex 分别指向这两个子数组中的元素。在每次循环中，我们比较左右指针所指向的元素大小，并将较小的元素加入结果数组中，同时将该指针向后移动一位。

 例如，我们有两个已排好序的子数组：
 [1, 4, 6, 8]
 [2, 3, 5, 7]
 
 初始时，leftIndex 指向第一个子数组的索引 0，而 rightIndex 指向第二个子数组的索引 0。然后我们依次比较第一个子数组中的元素 1 和第二个子数组中的元素 2，由于 1 小于 2，因此将 1 加入结果数组中，并将 leftIndex 向后移动一位。现在 leftIndex 指向索引 1，rightIndex 仍然指向索引 0，继续比较第一个子数组中的元素 4 和第二个子数组中的元素 2，同样由于 2 小于 4，因此将 2 加入结果数组中，并将 rightIndex 向后移动一位。现在 leftIndex 指向索引 1，rightIndex 指向索引 1，继续比较第一个子数组中的元素 4 和第二个子数组中的元素 3，由于 3 小于 4，因此将 3 加入结果数组中，并将 rightIndex 向后移动一位。以此类推，不断比较并加入更小的元素，直到我们遍历完了其中一个子数组。

 当左右两个子数组长度不同时，我们需要把剩余元素加入到结果数组中。例如：

 [1, 4, 6, 8]
 [2, 3, 5]
 
 在上述例子中，第一个子数组有 4 个元素，而第二个子数组只有 3 个元素。当我们遍历完第二个子数组时，leftIndex 指向索引 4，而 rightIndex 已经超出了第二个数组的长度，这时我们需要将第一个子数组中剩余的元素 [6, 8] 加入到结果数组中。

 因此，在合并两个已排好序的子数组时，我们需要用 while 循环和两个指针来实现。当左右两个子数组都还有元素未被加入到结果数组中时，我们就比较它们当前指向的元素大小并将较小的元素加入到结果数组中。如果其中一个子数组已经全部加入到结果数组中，我们就需要把另一个子数组中所有的剩余元素加入到结果数组中。
 */
func merge(_ leftArray: [Int], _ rightArray: [Int]) -> [Int] {
    
    var result = [Int]()
    var leftIndex = 0
    var rightIndex = 0

    while leftIndex < leftArray.count && rightIndex < rightArray.count  {
        if leftArray[leftIndex] < rightArray[rightIndex]{
            result.append(leftArray[leftIndex])
            leftIndex += 1
        }else{
            result.append(rightArray[rightIndex])
            rightIndex += 1
        }
    }
    
    if leftIndex < leftArray.count {
//        print("resultstart=\(result) left=\(leftArray[leftIndex..<leftArray.count])")
        result.append(contentsOf: leftArray[leftIndex..<leftArray.count])
//        print("resultend=\(result) left=\(leftArray[leftIndex..<leftArray.count])")
    }
    if rightIndex < rightArray.count {
            result.append(contentsOf: rightArray[rightIndex..<rightArray.count])
    }
    return result
}
print(mergeSort(&arr2))

/**
 快速排序
 
 快速排序的思路是选取一个基准值，将小于等于该值的元素放在左边，大于该值的元素放在右边，然后对左右子数组递归进行快速排序。partition 函数用于实现分区操作，low 和 high 分别表示当前处理的子数组的起始和结束位置。在分区过程中，我们从左往右遍历数组，将小于等于基准值的元素交换到数组的左边，最后将基准值放到中间位置。quickSort 函数则实现了递归的快速排序过程。
 
 */
func quickSort(_ array: inout [Int], low: Int, high: Int){
    guard low < high else {
        return
    }
    let pivot = partition(&array, low: low, high: high)
    quickSort(&array, low: low, high: pivot - 1)
    quickSort(&array, low: pivot + 1, high: high)
    print(array)
}

func partition(_ array: inout [Int], low: Int, high: Int) -> Int {
    let pivot = array[high]
    var i = low
    for j in low..<high{
        if array[j] <= pivot{
            array.swapAt(i, j)
            i+=1
        }
    }
    array.swapAt(i, high)
    return i
}
var arr = [5, 2, 9, 3, 7, 6, 8, 4, 1]
quickSort(&arr, low: 0, high: arr.count - 1)
