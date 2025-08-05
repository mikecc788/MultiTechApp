//
//  AnalyticsViewController.swift
//  DealMind
//
//  Created by app on 2025/7/8.
//

import UIKit

/// 分析页面控制器
class AnalyticsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = UIDesignSystem.Colors.backgroundPrimary
        
        let label = UILabel()
        label.text = "交易分析"
        label.font = UIDesignSystem.Typography.title1
        label.textColor = UIDesignSystem.Colors.textPrimary
        label.textAlignment = .center
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    static func createTabBarItem() -> AnalyticsViewController {
        let analyticsVC = AnalyticsViewController()
        analyticsVC.tabBarItem = UITabBarItem(
            title: "分析",
            image: UIImage(systemName: "chart.bar"),
            selectedImage: UIImage(systemName: "chart.bar.fill")
        )
        return analyticsVC
    }
} 