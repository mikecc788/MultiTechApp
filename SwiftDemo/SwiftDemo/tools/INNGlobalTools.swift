//
//  INNGlobalTools.swift
//  AudioLatencyTester
//
//  Created by chenliao on 2021/10/29.
//

import Foundation
import UIKit
import StoreKit
import SystemConfiguration.CaptiveNetwork

public struct INNGlobalTools{
    // MARK: 1.1、拨打电话
    /// 拨打电话的才处理
    /// - Parameter phoneNumber: 电话号码
    public static func callPhone(phoneNumber: String, complete: @escaping ((Bool) -> Void)) {
        // 注意: 跳转之前, 可以使用 canOpenURL: 判断是否可以跳转
        guard let phoneNumberEncoding = ("tel://" + phoneNumber).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let url = URL(string: phoneNumberEncoding), UIApplication.shared.canOpenURL(url) else {
            // 不能跳转就不要往下执行了
            complete(false)
            return
        }
        openUrl(url: url, complete: complete)
    }
    // MARK: 1.2、应用跳转
    /// 应用跳转
    /// - Parameters:
    ///   - vc: 跳转时所在控制器
    ///   - appId: app的id(开发者账号里面：应用注册后生成的)
    public static func updateApp(vc: UIViewController, appId: String)  {
        guard appId.count > 0 else {
            return
        }
        let productView = SKStoreProductViewController()
        // productView.delegate = (vc as! SKStoreProductViewControllerDelegate)
        productView.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier : appId], completionBlock: { (result, error) in
            if !result {
                //点击取消
                productView.dismiss(animated: true, completion: nil)
            }
        })
        vc.showDetailViewController(productView, sender: vc)
    }
    
    // MARK: 1.3、从 storyboard 中唤醒 viewcontroller
    /// 从 storyboard 中唤醒 viewcontroller
    /// - Parameters:
    ///   - storyboardID: viewcontroller 在 storyboard 中的 id
    ///   - fromStoryboard: storyboard 名称
    ///   - bundle: Bundle  默认为 main
    /// - Returns: UIviewcontroller
    public static func getViewController(storyboardID: String, fromStoryboard: String, bundle: Bundle? = nil) -> UIViewController {
        let sBundle = bundle ?? Bundle.main
        let story = UIStoryboard(name: fromStoryboard, bundle: sBundle)
        return story.instantiateViewController(withIdentifier: storyboardID)
    }
    
    // MARK: 1.5、获取本机IP
    /// 获取本机IP
    public static func getIPAddress() -> String? {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP | IFF_RUNNING | IFF_LOOPBACK)) == (IFF_UP | IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first
    }
    
    // MARK: 1.7、跳转URL
    public static func openUrl(url: URL, complete: @escaping ((Bool) -> Void)) {
        // iOS 10.0 以前
        guard #available(iOS 10.0, *)  else {
            let success = UIApplication.shared.openURL(url)
            if (success) {
                print("10以前可以跳转")
                complete(true)
            } else {
                print("10以前不能完成跳转")
                complete(false)
            }
            return
        }
        // iOS 10.0 以后
        UIApplication.shared.open(url, options: [:]) { (success) in
            if (success) {
                print("10以后可以跳转url")
                complete(true)
            } else {
                print("10以后不能完成跳转")
                complete(false)
            }
        }
    }
    
}
