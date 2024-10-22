//
//  INN+UIApplication.swift
//  AudioLatencyTester
//
//  Created by chenliao on 2021/10/29.
//

import Foundation
import UIKit
import Photos

extension UIApplication: INNPOPCompatible {}


public extension INNPOP where Base: UIApplication{
    // MARK: - 获取当前最顶层的控制器
    var getTopViewController: UIViewController? {
    
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }
    // MARK: 打开系统app
    /// 打开系统app
    /// - Parameter type: 系统app类型
    static func openSystemApp(type: INNSystemAppType, complete: @escaping ((Bool) -> Void)) {
        INNGlobalTools.openUrl(url: URL(string: type.rawValue)!, complete: complete)
    }
    
    // MARK: - 三、打开系统应用和第三方APP
    /// 系统app
    enum INNSystemAppType: String {
        case safari = "http://"
        case googleMaps = "http://maps.google.com"
        case Phone = "tel://"
        case SMS = "sms://"
        case Mail = "mailto://"
        case iBooks = "ibooks://"
        case AppStore = "itms-apps://itunes.apple.com"
        case Music = "music://"
        case Videos = "videos://"
    }
}
