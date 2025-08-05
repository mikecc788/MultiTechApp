//
//  PortfolioViewController.swift
//  DealMind
//
//  Created by app on 2025/7/8.
//

import UIKit

/// 投资组合页面控制器
class PortfolioViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = UIDesignSystem.Colors.backgroundPrimary
        
        let label = UILabel()
        label.text = "投资组合"
        label.font = UIDesignSystem.Typography.title1
        label.textColor = UIDesignSystem.Colors.textPrimary
        label.textAlignment = .center
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    static func createTabBarItem() -> PortfolioViewController {
        let portfolioVC = PortfolioViewController()
        portfolioVC.tabBarItem = UITabBarItem(
            title: "组合",
            image: UIImage(systemName: "briefcase"),
            selectedImage: UIImage(systemName: "briefcase.fill")
        )
        return portfolioVC
    }
} 