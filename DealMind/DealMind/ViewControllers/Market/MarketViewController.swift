//
//  MarketViewController.swift
//  DealMind
//
//  Created by app on 2025/7/8.
//

import UIKit

/// 市场页面控制器
class MarketViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = UIDesignSystem.Colors.backgroundPrimary
        
        let label = UILabel()
        label.text = "市场洞察"
        label.font = UIDesignSystem.Typography.title1
        label.textColor = UIDesignSystem.Colors.textPrimary
        label.textAlignment = .center
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    static func createTabBarItem() -> MarketViewController {
        let marketVC = MarketViewController()
        marketVC.tabBarItem = UITabBarItem(
            title: "市场",
            image: UIImage(systemName: "globe"),
            selectedImage: UIImage(systemName: "globe.asia.australia.fill")
        )
        return marketVC
    }
} 