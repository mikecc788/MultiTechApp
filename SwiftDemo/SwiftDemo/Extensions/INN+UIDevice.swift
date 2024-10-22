//
//  INN+UIDevice.swift
//  AudioLatencyTester
//
//  Created by chenliao on 2021/10/29.
//

import Foundation
import UIKit
public extension UIDevice {
    
    // MARK: -  屏幕宽度
    static let inn_ScreenW = UIScreen.main.bounds.width
    
    // MARK: - 屏幕高度
    static let inn_ScreenH = UIScreen.main.bounds.height
    
    // MARK: -  判断是否是 IphoneX 刘海机型
    class func inn_IsIphoneX() -> Bool {
        if (inn_ScreenW == 375 && inn_ScreenH == 812) || (inn_ScreenW == 812 && inn_ScreenH == 375) {
            return true// MARK: -  iphoneX/iphoneXS
        } else if (inn_ScreenW == 414 && inn_ScreenH == 896) || (inn_ScreenW == 896 && inn_ScreenH == 414) {
            return true// MARK: -  iphoneXR/iphoneXSMax
        } else {
            return false
        }
    }
    
    // MARK: -  判断是否是 Iphone4
    class func inn_IsIphone4() -> Bool {
        if (inn_ScreenW == 640 || inn_ScreenH == 960) && (inn_ScreenW == 960 || inn_ScreenH == 640) {
            return true// MARK: -  iphone4
        } else {
            return false
        }
    }
    
    // MARK: -  NavigationBar 高度
    class func inn_NavBarH() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 70.0
        } else {
            return inn_IsIphoneX() ? 88.0 : 64.0
        }
    }
    
    // MARK: -  TabBar 高度
    class func inn_TabBarH() -> CGFloat {
        return inn_IsIphoneX() ? 83.0 : 49.0
    }
    
    // MARK: -  顶部的安全距离
    class func inn_TopSafeAreaH() -> CGFloat {
        return inn_IsIphoneX() ? 20.0 : 0.0
    }
    
    // MARK: -  底部的安全距离
    class func inn_BottomSafeAreaH() -> CGFloat {
        return inn_IsIphoneX() ? 34.0 : 0.0
    }
    
    // MARK: -  375 自动 Cell 高度
    class func inn_Iphone6Height(_ height: CGFloat) -> CGFloat {
        return (inn_ScreenW / 375.0) * height
    }
    
    class func inn_statusHeight()->CGFloat{
        return UIApplication.shared.statusBarFrame.size.height
    }
    // MARK: -  电池栏小菊花
    static let inn_NWA = UIApplication.shared.isNetworkActivityIndicatorVisible
    
    // MARK: -  uuidString
    class func inn_UUID() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    // MARK: - systemName
    class func inn_SystemName() -> String {
        return UIDevice.current.systemName
    }
    
    // MARK: - systemVersion
    class func inn_SystemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    // MARK: - systemVersion(float)
    class func inn_SystemFloatVersion() -> Float {
        return (inn_SystemVersion() as NSString).floatValue
    }
    
    // MARK: - deviceName
    class func inn_DeviceName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        case "iPod1,1": return "iPod Touch 1"
        case "iPod2,1": return "iPod Touch 2"
        case "iPod3,1": return "iPod Touch 3"
        case "iPod4,1": return "iPod Touch 4"
        case "iPod5,1": return "iPod Touch (5 Gen)"
        case "iPod7,1": return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
        case "iPhone4,1": return "iPhone 4s"
        case "iPhone5,1": return "iPhone 5"
        case "iPhone5,2": return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3": return "iPhone 5c (GSM)"
        case "iPhone5,4": return "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1": return "iPhone 5s (GSM)"
        case "iPhone6,2": return "iPhone 5s (GSM+CDMA)"
        case "iPhone7,2": return "iPhone 6"
        case "iPhone7,1": return "iPhone 6 Plus"
        case "iPhone8,1": return "iPhone 6s"
        case "iPhone8,2": return "iPhone 6s Plus"
        case "iPhone8,4": return "iPhone SE"
        case "iPhone9,1": return "iPhone 7"
        case "iPhone9,2": return "iPhone 7 Plus"
        case "iPhone9,3": return "iPhone 7"
        case "iPhone9,4": return "iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4": return "iPhone 8"
        case "iPhone10,2","iPhone10,5": return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6": return "iPhone X"
        case "iPhone11,8": return "iPhone XR"
        case "iPhone11,2": return "iPhone XS"
        case "iPhone11,4","iPhone11,6": return "iPhone XS Max"
        case "iPhone12,1": return "iPhone 11"
        case "iPhone12,3": return "iPhone 11 Pro"
        case "iPhone12,5": return "iPhone 11 Pro Max"
        case "iPad1,1": return "iPad"
        case "iPad1,2": return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9": return "iPad Mini 3"
        case "iPad5,1", "iPad5,2": return "iPad Mini 4"
        case "iPad5,3", "iPad5,4": return "iPad Air 2"
        case "iPad6,3", "iPad6,4": return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8": return "iPad Pro 12.9"
        case "AppleTV2,1": return "Apple TV 2"
        case "AppleTV3,1", "AppleTV3,2": return "Apple TV 3"
        case "AppleTV5,3": return "Apple TV 4"
        case "i386", "x86_64": return "Simulator"
        default:  return ""
        }
    }
    
    // MARK: - device语言
    class func inn_DeviceLanguage() -> String {
        return Bundle.main.preferredLocalizations[0]
    }
    
    // MARK: - 是否是iphone
    class func inn_IsPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    
    // MARK: - 是否是ipad
    class func inn_IsPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    
    // MARK: - 电话
    class func inn_Call(_ phone: String?) -> Void {
        if let phoneNum = phone {
            if phoneNum.count > 0 {
                if #available(iOS 10.0, *) {
                    if let telUrl = URL(string: "tel://\(phoneNum)") {
                        UIApplication.shared.open(telUrl, options: [:]) { (success) in }
                    }
                } else {
                    if let telUrl = URL(string: "telprompt://\(phoneNum)") {
                        UIApplication.shared.openURL(telUrl)
                    }
                }
            }
        }
    }
    
    // MARK: - 屏幕旋转 是否需要动画
    static func inn_SwitchNewOrientation(_ interfaceOrientation: UIInterfaceOrientation, animated: Bool) {
        if animated {
            self.inn_SwitchNewOrientation(interfaceOrientation)
        } else {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.inn_SwitchNewOrientation(interfaceOrientation)
            CATransaction.commit()
        }
    }
    
    // MARK: - 屏幕旋转
    static func inn_SwitchNewOrientation(_ interfaceOrientation: UIInterfaceOrientation) {
        let resetOrientationTarget = NSNumber.init(value: Int8(UIInterfaceOrientation.unknown.rawValue))
        UIDevice.current.setValue(resetOrientationTarget, forKey: "orientation")
        let orientationTarget = NSNumber.init(value: Int8(interfaceOrientation.rawValue))
        UIDevice.current.setValue(orientationTarget, forKey: "orientation")
    }
    
    // MARK: - 清理缓存
    static func inn_ClearCache() {
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        if cachePath == nil {
            return
        }
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        if fileArr == nil {
            return
        }
        // 遍历删除
        for file in fileArr! {
            let path = cachePath! + "/\(file)"
            if FileManager.default.fileExists(atPath: path) {
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch {}
            }
        }
    }
    
    // MARK: - 获取缓存大小
    static func inn_QueryCacheSize() -> String {
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        if cachePath == nil {
            return "0.0M"
        }
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        if fileArr == nil {
            return "0.0M"
        }
        var size:CGFloat = 0.0
        for file in fileArr! {
            
            // 把文件名拼接到路径中
            let path = cachePath! + "/\(file)"
            // 取出文件属性
            if FileManager.default.fileExists(atPath: path) {
                do {
                    let floder = try FileManager.default.attributesOfItem(atPath: path)
                    // 用元组取出文件大小属性
                    for (abc, bcd) in floder {
                        // 累加文件大小
                        if abc == FileAttributeKey.size {
                            size += CGFloat(truncating: (bcd as AnyObject) as! NSNumber)
                        }
                    }
                } catch {
                    debugPrint("文件路径为空!")
                }
            }
        }
        let cacheSize = size / 1024.0 / 1024.0
        return String.init(format: "%.1fM", cacheSize)
    }
    
}
