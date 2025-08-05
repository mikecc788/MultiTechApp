//
//  AppRouter.swift
//  DealMind
//
//  Created by app on 2025/7/8.
//

import UIKit

/// 应用路由协议
protocol AppRouterProtocol: AnyObject {
    /// 显示启动页面
    func showLaunchScreen()
    
    /// 显示登录页面
    func showLogin()
    
    /// 显示主页面
    func showMainTabBar()
    
    /// 退出登录
    func logout()
    
    /// 显示错误提示
    func showError(_ error: Error)
    
    /// 显示加载状态
    func showLoading(_ message: String?)
    
    /// 隐藏加载状态
    func hideLoading()
    
    #if DEBUG
    /// 测试模式：强制显示指定页面
    func forceShow(_ destination: RouteDestination)
    
    /// 获取当前路由状态信息
    var debugInfo: String { get }
    #endif
}

/// 路由目标枚举
enum RouteDestination {
    case launch
    case login
    case mainTabBar
    case error(Error)
}

/// 应用路由器实现
class AppRouter: AppRouterProtocol {
    
    // MARK: - Properties
    
    /// 主窗口
    private weak var window: UIWindow?
    
    /// 当前显示的根控制器
    private var currentRootViewController: UIViewController?
    
    /// 加载指示器
    private var loadingViewController: UIViewController?
    
    /// 认证管理器
    private let authManager: AuthManagerProtocol
    
    // MARK: - Initialization
    
    init(window: UIWindow?, authManager: AuthManagerProtocol) {
        self.window = window
        self.authManager = authManager
        setupAuthManagerCallbacks()
    }
    
    // MARK: - Public Methods
    
    func showLaunchScreen() {
        let launchVC = LaunchViewController()
        setRootViewController(launchVC, animated: false)
        
        // 自动检查认证状态
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.checkAuthenticationStatus()
        }
    }
    
    func showLogin() {
        let loginVC = LoginViewController()
        loginVC.loginCompletion = { [weak self] email, password in
            // 这里可以添加实际的登录验证逻辑
            self?.authManager.login(username: email, password: password) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.showMainTabBar()
                    case .failure(let error):
                        self?.showError(error)
                    }
                }
            }
        }
        
        setRootViewController(loginVC, animated: true)
    }
    
    func showMainTabBar() {
        let mainTabBarVC = MainTabBarController()
        mainTabBarVC.logoutHandler = { [weak self] in
            self?.logout()
        }
        
        setRootViewController(mainTabBarVC, animated: true)
    }
    
    func logout() {
        authManager.logout()
        showLogin()
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "错误",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        
        if let topVC = getTopViewController() {
            topVC.present(alert, animated: true)
        }
    }
    
    func showLoading(_ message: String? = nil) {
        hideLoading()
        
        let loadingVC = LoadingViewController()
        loadingVC.message = message
        loadingVC.modalPresentationStyle = .overFullScreen
        loadingVC.modalTransitionStyle = .crossDissolve
        
        if let topVC = getTopViewController() {
            topVC.present(loadingVC, animated: true)
            loadingViewController = loadingVC
        }
    }
    
    func hideLoading() {
        loadingViewController?.dismiss(animated: true) { [weak self] in
            self?.loadingViewController = nil
        }
    }
    
    // MARK: - Private Methods
    
    private func setupAuthManagerCallbacks() {
        authManager.onAuthenticationStateChanged = { [weak self] isAuthenticated in
            DispatchQueue.main.async {
                if isAuthenticated {
                    self?.showMainTabBar()
                } else {
                    self?.showLogin()
                }
            }
        }
    }
    
    private func checkAuthenticationStatus() {
        if authManager.isAuthenticated {
            showMainTabBar()
        } else {
            showLogin()
        }
    }
    
    private func setRootViewController(_ viewController: UIViewController, animated: Bool) {
        guard let window = window else { return }
        
        currentRootViewController = viewController
        
        if animated {
            UIView.transition(
                with: window,
                duration: 0.5,
                options: [.transitionCrossDissolve],
                animations: {
                    window.rootViewController = viewController
                },
                completion: nil
            )
        } else {
            window.rootViewController = viewController
        }
        
        window.makeKeyAndVisible()
    }
    
    private func getTopViewController() -> UIViewController? {
        guard let window = window else { return nil }
        
        var topViewController = window.rootViewController
        
        while let presentedViewController = topViewController?.presentedViewController {
            topViewController = presentedViewController
        }
        
        if let navigationController = topViewController as? UINavigationController {
            topViewController = navigationController.visibleViewController
        }
        
        if let tabBarController = topViewController as? UITabBarController {
            topViewController = tabBarController.selectedViewController
            
            if let navigationController = topViewController as? UINavigationController {
                topViewController = navigationController.visibleViewController
            }
        }
        
        return topViewController
    }
}

// MARK: - Navigation Extensions

extension AppRouter {
    
    /// 导航到指定目标
    func navigate(to destination: RouteDestination) {
        switch destination {
        case .launch:
            showLaunchScreen()
        case .login:
            showLogin()
        case .mainTabBar:
            showMainTabBar()
        case .error(let error):
            showError(error)
        }
    }
    
    /// 检查是否可以导航到指定目标
    func canNavigate(to destination: RouteDestination) -> Bool {
        switch destination {
        case .launch:
            return true
        case .login:
            return true
        case .mainTabBar:
            return authManager.isAuthenticated
        case .error:
            return true
        }
    }
}

// MARK: - Debug Extensions

#if DEBUG
extension AppRouter {
    
    /// 测试模式：强制显示指定页面
    func forceShow(_ destination: RouteDestination) {
        switch destination {
        case .launch:
            showLaunchScreen()
        case .login:
            showLogin()
        case .mainTabBar:
            showMainTabBar()
        case .error(let error):
            showError(error)
        }
    }
    
    /// 获取当前路由状态信息
    var debugInfo: String {
        let currentVC = String(describing: type(of: currentRootViewController))
        let authStatus = authManager.isAuthenticated ? "已认证" : "未认证"
        return "当前页面: \(currentVC), 认证状态: \(authStatus)"
    }
}
#endif 