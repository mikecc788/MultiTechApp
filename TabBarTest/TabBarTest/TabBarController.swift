//
//  TabBarController.swift
//  TabBarTest
//
//  Created by app on 2025/9/25.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupViewControllers()
    }
    
    // MARK: - Setup Methods
    
    private func setupTabBar() {
        // Use system appearance instead of manual colors/shadows to avoid the extra "bottom bar" look
        let appearance = AppAppearance.tabBarAppearance()

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        tabBar.isTranslucent = true
        view.backgroundColor = .clear
    }
    
    private func setupViewControllers() {
        // 创建三个主要的视图控制器
        let homeViewController = HomeViewController()
        let searchViewController = SearchViewController()
        let profileViewController = ProfileViewController()
        
        // 为每个视图控制器创建导航控制器
        let homeNavController = createNavigationController(
            rootViewController: homeViewController,
            title: "首页",
            imageName: "home_normal"
        )
        
        let searchNavController = createNavigationController(
            rootViewController: searchViewController,
            title: "搜索",
            imageName: "info_normal"
        )
        
        let profileNavController = createNavigationController(
            rootViewController: profileViewController,
            title: "我的",
            imageName: "user_normal"
        )
        
        // 设置 TabBar 的视图控制器
        viewControllers = [homeNavController, searchNavController, profileNavController]
    }
    
    private func createNavigationController(
        rootViewController: UIViewController,
        title: String,
        imageName: String
    ) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.view.backgroundColor = .clear
        
        let navAppearance = AppAppearance.navigationBarAppearance()
        navController.navigationBar.standardAppearance = navAppearance
        navController.navigationBar.scrollEdgeAppearance = navAppearance
        
        // 设置 TabBarItem
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        navController.tabBarItem.selectedImage = UIImage(named: imageName + "_selected")
        
        // 设置导航栏外观
        navController.navigationBar.prefersLargeTitles = true
        
        return navController
    }
}
