//
//  INNAsyncs.swift
//  AudioLatencyTester
//
//  Created by chenliao on 2021/11/1.
//

import UIKit

public typealias INNTask = () -> Void

// MARK: - 延迟事件
public struct INNAsyncs{
    //取消没有return的警告
    // MARK: 1.1、异步做一些任务
    /// 异步做一些任务
    /// - Parameter Task: 任务
    @discardableResult
    public static func async(_ INNTask: @escaping INNTask) -> DispatchWorkItem {
        return _asyncDelay(0, INNTask)
    }
    
    // MARK: 1.2、异步做任务后回到主线程做任务
    /// 异步做任务后回到主线程做任务
    /// - Parameters:
    ///   - JKTask: 异步任务
    ///   - mainJKTask: 主线程任务
    @discardableResult
    public static func async(_ INNTask: @escaping INNTask,
                             _ mainJKTask: @escaping INNTask) -> DispatchWorkItem{
        return _asyncDelay(0, INNTask, mainJKTask)
    }
    
    // MARK: 1.4、异步延迟回到主线程(子线程执行任务，然后回到主线程执行任务)
    /// 异步延迟回到主线程(子线程执行任务，然后回到主线程执行任务)
    /// - Parameter seconds: 延迟秒数
    /// - Parameter JKTask: 延迟的block
    /// - Parameter mainJKTask: 延迟的主线程block
    @discardableResult
    public static func asyncDelay(_ seconds: Double,
                                  _ INNTask: @escaping INNTask,
                                  _ mainJKTask: @escaping INNTask) -> DispatchWorkItem {
        return _asyncDelay(seconds, INNTask, mainJKTask)
    }
    
}

// MARK: - 私有的方法
extension INNAsyncs {
    
    /// 延迟任务
    /// - Parameters:
    ///   - seconds: 延迟时间
    ///   - JKTask: 任务
    ///   - mainJKTask: 任务
    /// - Returns: DispatchWorkItem
    fileprivate static func _asyncDelay(_ seconds: Double,
                                        _ INNTask: @escaping INNTask,
                                        _ mainJKTask: INNTask? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: INNTask)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + seconds,
                                          execute: item)
        if let main = mainJKTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        return item
    }
}

