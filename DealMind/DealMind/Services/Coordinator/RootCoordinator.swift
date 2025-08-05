//
//  RootCoordinator.swift
//  DealMind
//
//  Created by app on 2025/7/8.
//

import UIKit

/// 根协调器协议
protocol CoordinatorProtocol: AnyObject {
    /// 启动协调器
    func start()
    
    /// 停止协调器
    func stop()
}

/// 根协调器实现
class RootCoordinator: CoordinatorProtocol {
    
    // MARK: - Properties
    
    /// 主窗口
    private let window: UIWindow
    
    /// 应用路由器
    private let appRouter: AppRouterProtocol
    
    /// 认证管理器
    private let authManager: AuthManagerProtocol
    
    /// 子协调器集合
    private var childCoordinators: [CoordinatorProtocol] = []
    
    /// 应用状态监听器
    private var applicationStateObserver: NSObjectProtocol?
    
    // MARK: - Initialization
    
    init(window: UIWindow) {
        self.window = window
        self.authManager = AuthManager()
        self.appRouter = AppRouter(window: window, authManager: authManager)
        
        setupApplicationStateObservers()
    }
    
    // MARK: - CoordinatorProtocol
    
    func start() {
        configureWindow()
        startInitialFlow()
        setupTestControls()
    }
    
    func stop() {
        removeApplicationStateObservers()
        childCoordinators.removeAll()
    }
    
    // MARK: - Private Methods
    
    private func configureWindow() {
        window.backgroundColor = UIDesignSystem.Colors.backgroundPrimary
        window.makeKeyAndVisible()
    }
    
    private func startInitialFlow() {
        // 显示启动画面
        appRouter.showLaunchScreen()
    }
    
    private func setupApplicationStateObservers() {
        // 监听应用进入前台
        applicationStateObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleApplicationWillEnterForeground()
        }
        
        // 监听应用进入后台
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleApplicationDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        // 监听内存警告
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleMemoryWarning),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
    }
    
    private func removeApplicationStateObservers() {
        if let observer = applicationStateObserver {
            NotificationCenter.default.removeObserver(observer)
            applicationStateObserver = nil
        }
        
        NotificationCenter.default.removeObserver(self)
    }
    
    private func handleApplicationWillEnterForeground() {
        // 检查认证状态
        authManager.checkAuthenticationStatus()
        
        // 检查令牌是否需要刷新
        if authManager.isAuthenticated {
            authManager.refreshToken { [weak self] result in
                switch result {
                case .success:
                    print("令牌刷新成功")
                case .failure(let error):
                    print("令牌刷新失败: \(error.localizedDescription)")
                    self?.appRouter.showError(error)
                }
            }
        }
    }
    
    @objc private func handleApplicationDidEnterBackground() {
        // 可以在这里保存应用状态
        print("应用进入后台")
    }
    
    @objc private func handleMemoryWarning() {
        // 处理内存警告
        print("收到内存警告")
        // 可以在这里清理不必要的资源
    }
    
    private func setupTestControls() {
        #if DEBUG
        setupDebugGestures()
        #endif
    }
    
    // MARK: - Child Coordinator Management
    
    private func addChildCoordinator(_ coordinator: CoordinatorProtocol) {
        childCoordinators.append(coordinator)
    }
    
    private func removeChildCoordinator(_ coordinator: CoordinatorProtocol) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}

// MARK: - Debug Extensions

#if DEBUG
extension RootCoordinator {
    
    /// 设置调试手势
    private func setupDebugGestures() {
        // 三指长按显示调试菜单
        let debugGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(showDebugMenu)
        )
        debugGesture.numberOfTouchesRequired = 3
        debugGesture.minimumPressDuration = 2.0
        window.addGestureRecognizer(debugGesture)
    }
    
    @objc private func showDebugMenu() {
        let alert = UIAlertController(
            title: "调试菜单",
            message: "选择要执行的操作",
            preferredStyle: .actionSheet
        )
        
        // 强制显示登录页面
        alert.addAction(UIAlertAction(title: "显示登录页面", style: .default) { [weak self] _ in
            (self?.appRouter as? AppRouter)?.forceShow(.login)
        })
        
        // 强制显示主页面
        alert.addAction(UIAlertAction(title: "显示主页面", style: .default) { [weak self] _ in
            (self?.appRouter as? AppRouter)?.forceShow(.mainTabBar)
        })
        
        // 模拟登录
        alert.addAction(UIAlertAction(title: "模拟登录", style: .default) { [weak self] _ in
            (self?.authManager as? AuthManager)?.simulateSuccessfulLogin()
        })
        
        // 清除认证数据
        alert.addAction(UIAlertAction(title: "清除认证数据", style: .destructive) { [weak self] _ in
            (self?.authManager as? AuthManager)?.clearAllAuthData()
        })
        
        // 显示调试信息
        alert.addAction(UIAlertAction(title: "显示调试信息", style: .default) { [weak self] _ in
            self?.showDebugInfo()
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        // iPad适配
        if let popover = alert.popoverPresentationController {
            popover.sourceView = window
            popover.sourceRect = CGRect(x: window.bounds.midX, y: window.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        if let topViewController = getTopViewController() {
            topViewController.present(alert, animated: true)
        }
    }
    
    private func showDebugInfo() {
        let authInfo = (authManager as? AuthManager)?.debugInfo ?? "无认证信息"
        let routerInfo = (appRouter as? AppRouter)?.debugInfo ?? "无路由信息"
        
        let alert = UIAlertController(
            title: "调试信息",
            message: "\(authInfo)\n\n\(routerInfo)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        
        if let topViewController = getTopViewController() {
            topViewController.present(alert, animated: true)
        }
    }
    
    private func getTopViewController() -> UIViewController? {
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
#endif

// MARK: - Error Handling

extension RootCoordinator {
    
    /// 处理全局错误
    func handleGlobalError(_ error: Error) {
        print("全局错误: \(error.localizedDescription)")
        
        // 根据错误类型决定处理方式
        if let authError = error as? AuthError {
            handleAuthError(authError)
        } else {
            appRouter.showError(error)
        }
    }
    
    private func handleAuthError(_ error: AuthError) {
        switch error {
        case .tokenExpired:
            // 令牌过期，返回登录页面
            appRouter.showLogin()
        case .networkError:
            // 网络错误，显示重试选项
            showNetworkErrorAlert()
        default:
            // 其他认证错误
            appRouter.showError(error)
        }
    }
    
    private func showNetworkErrorAlert() {
        let alert = UIAlertController(
            title: "网络错误",
            message: "网络连接失败，请检查网络设置后重试",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "重试", style: .default) { [weak self] _ in
            self?.authManager.checkAuthenticationStatus()
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        if let topViewController = getTopViewController() {
            topViewController.present(alert, animated: true)
        }
    }
    

} 