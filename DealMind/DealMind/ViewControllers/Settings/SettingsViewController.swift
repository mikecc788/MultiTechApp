//
//  SettingsViewController.swift
//  DealMind
//
//  Created by app on 2025/7/8.
//

import UIKit
import NetworkKit
/// 设置页面控制器
class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        let client = HTTPClient()
        Task {
            do {
                let user: GetUser.Response = try await client.send(GetUser())
                print("user:", user)
            } catch {
                print("network error:", error)
            }
        }
    }
    
    private func setupView() {
        view.backgroundColor = UIDesignSystem.Colors.backgroundPrimary
        
        let label = UILabel()
        label.text = "设置"
        label.font = UIDesignSystem.Typography.title1
        label.textColor = UIDesignSystem.Colors.textPrimary
        label.textAlignment = .center
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    static func createTabBarItem() -> SettingsViewController {
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(
            title: "设置",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        return settingsVC
    }
} 


struct GetUser: Endpoint {
    struct Response: Decodable { let id: Int; let name: String }
    var urlRequest: URLRequest {
        var r = URLRequest(url: URL(string: "https://api.example.com/user/1")!)
        r.httpMethod = "GET"
        return r
    }
}

