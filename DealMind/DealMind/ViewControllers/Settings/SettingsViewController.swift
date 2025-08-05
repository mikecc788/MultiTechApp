//
//  SettingsViewController.swift
//  DealMind
//
//  Created by app on 2025/7/8.
//

import UIKit

/// 设置页面控制器
class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
