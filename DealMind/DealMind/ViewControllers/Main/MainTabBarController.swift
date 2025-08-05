//
//  MainTabBarController.swift
//  DealMind
//
//  Created by app on 2025/7/8.
//

import UIKit

/// 主TabBar控制器
class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    /// 退出登录回调
    var logoutHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
        setupAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBarAnimation()
    }
    
    // MARK: - Setup Methods
    
    private func setupTabBar() {
        // 启用半透明效果
        tabBar.isTranslucent = true
        
        // 设置背景色和样式
        tabBar.backgroundColor = UIDesignSystem.Colors.backgroundCard.withAlphaComponent(0.95)
        tabBar.barTintColor = UIDesignSystem.Colors.backgroundCard
        
        // 设置选中和未选中的颜色
        tabBar.tintColor = UIDesignSystem.Colors.primary
        tabBar.unselectedItemTintColor = UIDesignSystem.Colors.textSecondary
        
        // 添加模糊效果
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = tabBar.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabBar.insertSubview(blurView, at: 0)
        
        // 添加科技感边框
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIDesignSystem.Colors.borderPrimary.cgColor
        
        // 添加阴影效果
        tabBar.layer.shadowColor = UIDesignSystem.Colors.primary.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowRadius = 8
    }
    
    private func setupViewControllers() {
        // 创建各个页面控制器
        let homeVC = createHomeViewController()
        let analyticsVC = createAnalyticsViewController()
        let marketVC = createMarketViewController()
        let portfolioVC = createPortfolioViewController()
        let settingsVC = createSettingsViewController()
        
        // 设置viewControllers
        viewControllers = [homeVC, analyticsVC, marketVC, portfolioVC, settingsVC]
        
        // 设置默认选中页面
        selectedIndex = 0
    }
    
    private func setupAppearance() {
        // 设置TabBar字体
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIDesignSystem.Colors.backgroundCard.withAlphaComponent(0.95)
        
        // 设置正常状态
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIDesignSystem.Colors.textSecondary,
            .font: UIDesignSystem.Typography.caption1
        ]
        
        // 设置选中状态
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIDesignSystem.Colors.primary,
            .font: UIDesignSystem.Typography.caption1
        ]
        
        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func setupTabBarAnimation() {
        // 为TabBar添加启动动画
        tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
        tabBar.alpha = 0
        
        UIView.animate(
            withDuration: 0.8,
            delay: 0.2,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: []
        ) {
            self.tabBar.transform = .identity
            self.tabBar.alpha = 1
        }
    }
    
    // MARK: - View Controller Creation
    
    private func createHomeViewController() -> UINavigationController {
        let homeVC = HomeViewController.createTabBarItem()
        homeVC.logoutHandler = { [weak self] in
            self?.logoutHandler?()
        }
        
        let navController = createNavigationController(rootViewController: homeVC)
        return navController
    }
    
    private func createAnalyticsViewController() -> UINavigationController {
        let analyticsVC = AnalyticsViewController.createTabBarItem()
        let navController = createNavigationController(rootViewController: analyticsVC)
        return navController
    }
    
    private func createMarketViewController() -> UINavigationController {
        let marketVC = MarketViewController.createTabBarItem()
        let navController = createNavigationController(rootViewController: marketVC)
        return navController
    }
    
    private func createPortfolioViewController() -> UINavigationController {
        let portfolioVC = PortfolioViewController.createTabBarItem()
        let navController = createNavigationController(rootViewController: portfolioVC)
        return navController
    }
    
    private func createSettingsViewController() -> UINavigationController {
        let settingsVC = SettingsViewController.createTabBarItem()
        let navController = createNavigationController(rootViewController: settingsVC)
        return navController
    }
    
    private func createNavigationController(rootViewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        
        // 设置导航栏透明
        navController.navigationBar.isHidden = true
        navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.isTranslucent = true
        
        return navController
    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // 添加切换动画
        guard let fromView = selectedViewController?.view,
              let toView = viewController.view else {
            return true
        }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseInOut], completion: nil)
        }
        
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // 添加点击反馈
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // 添加按钮动画效果
        if let tabBarItems = tabBar.items {
            let selectedItem = tabBarItems[selectedIndex]
            animateTabBarItem(selectedItem)
        }
    }
    
    private func animateTabBarItem(_ item: UITabBarItem) {
        guard let view = item.value(forKey: "view") as? UIView else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                view.transform = .identity
            }
        }
    }
}

// MARK: - Tab Bar Item Animation

extension MainTabBarController {
    
    /// 添加霓虹光效到选中的TabBar项
    func addNeonEffectToSelectedItem() {
        guard let tabBarItems = tabBar.items,
              selectedIndex < tabBarItems.count else { return }
        
        let selectedItem = tabBarItems[selectedIndex]
        guard let itemView = selectedItem.value(forKey: "view") as? UIView else { return }
        
        // 移除之前的光效
        itemView.layer.sublayers?.forEach { layer in
            if layer.name == "neonGlow" {
                layer.removeFromSuperlayer()
            }
        }
        
        // 添加新的光效
        let glowLayer = CALayer()
        glowLayer.name = "neonGlow"
        glowLayer.backgroundColor = UIDesignSystem.Colors.primary.cgColor
        glowLayer.frame = itemView.bounds
        glowLayer.cornerRadius = 8
        glowLayer.opacity = 0.3
        
        // 添加发光动画
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.fromValue = 0.3
        pulseAnimation.toValue = 0.7
        pulseAnimation.duration = 1.0
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        
        glowLayer.add(pulseAnimation, forKey: "pulse")
        itemView.layer.insertSublayer(glowLayer, at: 0)
    }
} 