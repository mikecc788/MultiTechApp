//
//  INN+Timer.swift
//  AudioLatencyTester
//
//  Created by chenliao on 2021/10/29.
//

import Foundation
import UIKit
public extension Timer {
    // MARK: - 初始化一个定时器
    @discardableResult
    class func inn_RunTimer(_  target: UIViewController!, S: TimeInterval, handler: @escaping (Timer?) -> Void) -> Timer {
        let fireDate = CFAbsoluteTimeGetCurrent()
        let runLoop = CFRunLoopGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, S, 0, 0) { [weak target] (timer) in
            // 自动释放
            if target != nil {
                handler(timer)
            } else {
                CFRunLoopRemoveTimer(runLoop, timer, CFRunLoopMode.commonModes)
                CFRunLoopStop(runLoop)
            }
        }
        CFRunLoopAddTimer(runLoop, timer, CFRunLoopMode.commonModes)
        return timer!
    }
    
    // MARK: - 延时执行
    @discardableResult
    class func inn_After(S: Double, after: @escaping () -> Void) -> DispatchWorkItem {
        return inn_After(S: S, queue: DispatchQueue.main, after: after)
    }
    
    @discardableResult
    class func inn_After(S: Double, queue: DispatchQueue, after: @escaping () -> Void) -> DispatchWorkItem {
        let time = DispatchTime.now() + Double(Int64(S * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        let wAfter = DispatchWorkItem.init(block: after)
        queue.asyncAfter(deadline: time, execute: wAfter)
        return wAfter
    }
}
