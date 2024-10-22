//
//  FlutterViewVC.swift
//  SwiftDemo
//
//  Created by app on 2024/10/22.
//

import Flutter
import UIKit
class FlutterViewVC: FlutterViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        popMethodChannel()
//        setupMethodChannel()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 如果需要，在离开 Flutter 视图时重新显示导航栏
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    private func popMethodChannel() {
        let channel = FlutterMethodChannel(name: "com.yourcompany.flutter/native",binaryMessenger: self.binaryMessenger)
        channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
                guard let self = self else { return }
                
                if call.method == "returnToNative" {
                    self.returnToNative()
                    result(nil)
                } else {
                    result(FlutterMethodNotImplemented)
                }
            }
    }
    private func returnToNative() {
        // 如果 FlutterViewController 是被 push 到导航栈中的
        self.navigationController?.popViewController(animated: true)
        
        // 或者如果 FlutterViewController 是被 present 的
        // self.dismiss(animated: true, completion: nil)
    }
    
    private func setupMethodChannel() {
        let channel = FlutterMethodChannel(name: "com.yourcompany.flutter/native",
                                           binaryMessenger: self.binaryMessenger)
        
        channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else { return }
            
            switch call.method {
            case "setTitle":
                if let args = call.arguments as? [String: Any],
                   let title = args["title"] as? String {
                    self.setTitle(title)
                    result(nil)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for setTitle", details: nil))
                }
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    private func setTitle(_ title: String) {
        // 根据您的 UI 结构来设置标题
        // 例如，如果您使用 UINavigationController：
        self.navigationItem.title = title
        
        // 或者如果您有自定义的标题视图：
        // self.titleLabel.text = title
    }
}
