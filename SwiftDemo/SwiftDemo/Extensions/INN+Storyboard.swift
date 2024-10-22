//
//  INN+Storyboard.swift
//  AudioLatencyTester
//
//  Created by chenliao on 2021/10/29.
//

import UIKit

// MARK: -  Storyboard 初始化类型枚举
public enum inn_StoryboardInstantiateType {
    case initial
    case identifier(String)
}

// MARK: -  协议静态值
public protocol inn_StoryboardInstantiatable {
    static var inn_StoryboardName: String { get }
    static var inn_StoryboardBundle: Bundle { get }
    static var inn_InstantiateType: inn_StoryboardInstantiateType { get }
}

public extension inn_StoryboardInstantiatable where Self: NSObject {
    // 静态默认 StoryboardName 可以在控制器类重新赋值修改
    static var inn_StoryboardName: String {
        return inn_ClassName
    }
    // 静态默认 StoryboardBundle 可以在控制器类重新赋值修改
    static var inn_StoryboardBundle: Bundle {
        return Bundle(for: self)
    }
    // 静态默认 Storyboard 初始化类型（见 inn_StoryboardInstantiateType 枚举） 可以在控制器类重新赋值修改
    static var inn_InstantiateType: inn_StoryboardInstantiateType {
        return .identifier(inn_StoryboardName)
    }
    private static var inn_Storyboard: UIStoryboard {
        return UIStoryboard(name: inn_StoryboardName, bundle: inn_StoryboardBundle)
    }
}

// MARK: - 便捷 Storyboard 初始化
public extension inn_StoryboardInstantiatable where Self: UIViewController {
    static func lgf() -> Self {
        switch inn_InstantiateType {
        case .initial:
            return inn_Storyboard.instantiateInitialViewController() as! Self
        case .identifier(let identifier):
            return inn_Storyboard.instantiateViewController(withIdentifier: identifier) as! Self
        }
    }
}

// MARK: - 使用
/**
 
 // 箭头 storyboard 初始化
 final class InitialViewController: UIViewController, inn_StoryboardInstantiatable {
     @IBOutlet weak var label: UILabel!
     static var inn_InstantiateType: inn_StoryboardInstantiateType {
         return .initial
     }
 }
 
 // 初始化
 func testInstantiateByInitial() {
     let viewControlelr = InitialViewController.lgf()
     _ = viewControlelr.view// _ = viewControlelr.view 之前 viewControlelr.label == nil, 之后 viewControlelr.label 才有值
     viewControlelr.label.text = "lgf"
 }
 
 // identifier storyboard 初始化
 final class IdentifierViewController: UIViewController, inn_StoryboardInstantiatable {
     @IBOutlet weak var label: UILabel!
     static var inn_StoryboardName: String { return InitialViewController.className }
 }
 
 // 初始化
 func testInstantiateByIdentifier() {
     let viewControlelr = IdentifierViewController.lgf()
     _ = viewControlelr.view// _ = viewControlelr.view 之前 viewControlelr.label == nil, 之后 viewControlelr.label 才有值
     viewControlelr.label.text = "lgf"
 }
 
**/
