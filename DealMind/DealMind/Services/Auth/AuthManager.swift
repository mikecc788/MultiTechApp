//
//  AuthManager.swift
//  DealMind
//
//  Created by app on 2025/7/8.
//

import Foundation
import Security

/// 认证管理器协议
protocol AuthManagerProtocol: AnyObject {
    /// 当前是否已认证
    var isAuthenticated: Bool { get }
    
    /// 当前用户信息
    var currentUser: User? { get }
    
    /// 认证状态变化回调
    var onAuthenticationStateChanged: ((Bool) -> Void)? { get set }
    
    /// 登录
    func login(username: String, password: String, completion: @escaping (Result<User, AuthError>) -> Void)
    
    /// 登出
    func logout()
    
    /// 检查认证状态
    func checkAuthenticationStatus()
    
    /// 刷新令牌
    func refreshToken(completion: @escaping (Result<Void, AuthError>) -> Void)
    
    #if DEBUG
    /// 测试用：模拟登录成功
    func simulateSuccessfulLogin()
    
    /// 测试用：清除所有认证数据
    func clearAllAuthData()
    
    /// 获取调试信息
    var debugInfo: String { get }
    #endif
}

/// 认证错误类型
enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case networkError
    case tokenExpired
    case userNotFound
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "用户名或密码错误"
        case .networkError:
            return "网络连接失败，请检查网络设置"
        case .tokenExpired:
            return "登录已过期，请重新登录"
        case .userNotFound:
            return "用户不存在"
        case .serverError(let message):
            return "服务器错误：\(message)"
        }
    }
}

/// 用户模型
struct User: Codable {
    let id: String
    let username: String
    let email: String
    let displayName: String
    let avatarURL: String?
    let createdAt: Date
    let lastLoginAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, username, email
        case displayName = "display_name"
        case avatarURL = "avatar_url"
        case createdAt = "created_at"
        case lastLoginAt = "last_login_at"
    }
}

/// 认证令牌模型
struct AuthToken: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresAt: Date
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresAt = "expires_at"
    }
    
    /// 检查令牌是否过期
    var isExpired: Bool {
        return Date() >= expiresAt
    }
    
    /// 检查令牌是否即将过期（5分钟内）
    var willExpireSoon: Bool {
        return Date().addingTimeInterval(300) >= expiresAt
    }
}

/// 认证管理器实现
class AuthManager: AuthManagerProtocol {
    
    // MARK: - Properties
    
    private(set) var isAuthenticated: Bool = false
    private(set) var currentUser: User?
    private var currentToken: AuthToken?
    
    var onAuthenticationStateChanged: ((Bool) -> Void)?
    
    // MARK: - Constants
    
    private let keychainService = "com.dealmind.auth"
    private let userDefaultsUserKey = "current_user"
    private let keychainTokenKey = "auth_token"
    
    // MARK: - Initialization
    
    init() {
        loadStoredAuthenticationData()
    }
    
    // MARK: - Public Methods
    
    func login(username: String, password: String, completion: @escaping (Result<User, AuthError>) -> Void) {
        // 验证输入
        guard !username.isEmpty, !password.isEmpty else {
            completion(.failure(.invalidCredentials))
            return
        }
        
        // 模拟网络请求
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) { [weak self] in
            // 模拟登录逻辑
            if self?.simulateLogin(username: username, password: password) == true {
                let user = User(
                    id: UUID().uuidString,
                    username: username,
                    email: "\(username)@dealmind.com",
                    displayName: username.capitalized,
                    avatarURL: nil,
                    createdAt: Date(),
                    lastLoginAt: Date()
                )
                
                let token = AuthToken(
                    accessToken: "access_token_\(UUID().uuidString)",
                    refreshToken: "refresh_token_\(UUID().uuidString)",
                    expiresAt: Date().addingTimeInterval(3600) // 1小时后过期
                )
                
                DispatchQueue.main.async {
                    self?.handleSuccessfulLogin(user: user, token: token)
                    completion(.success(user))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidCredentials))
                }
            }
        }
    }
    
    func logout() {
        clearAuthenticationData()
        updateAuthenticationState(isAuthenticated: false)
    }
    
    func checkAuthenticationStatus() {
        guard let token = currentToken else {
            updateAuthenticationState(isAuthenticated: false)
            return
        }
        
        if token.isExpired {
            // 尝试刷新令牌
            refreshToken { [weak self] result in
                switch result {
                case .success:
                    self?.updateAuthenticationState(isAuthenticated: true)
                case .failure:
                    self?.logout()
                }
            }
        } else {
            updateAuthenticationState(isAuthenticated: true)
        }
    }
    
    func refreshToken(completion: @escaping (Result<Void, AuthError>) -> Void) {
        guard let currentToken = currentToken else {
            completion(.failure(.tokenExpired))
            return
        }
        
        // 模拟刷新令牌请求
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) { [weak self] in
            // 模拟成功刷新
            let newToken = AuthToken(
                accessToken: "new_access_token_\(UUID().uuidString)",
                refreshToken: currentToken.refreshToken,
                expiresAt: Date().addingTimeInterval(3600)
            )
            
            DispatchQueue.main.async {
                self?.currentToken = newToken
                self?.saveTokenToKeychain(newToken)
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func simulateLogin(username: String, password: String) -> Bool {
        // 简单的模拟登录逻辑
        // 在实际应用中，这里应该是真正的API调用
        return password.count >= 6 // 简单的密码长度验证
    }
    
    private func handleSuccessfulLogin(user: User, token: AuthToken) {
        currentUser = user
        currentToken = token
        
        saveUserToUserDefaults(user)
        saveTokenToKeychain(token)
        
        updateAuthenticationState(isAuthenticated: true)
    }
    
    private func updateAuthenticationState(isAuthenticated: Bool) {
        self.isAuthenticated = isAuthenticated
        onAuthenticationStateChanged?(isAuthenticated)
    }
    
    private func clearAuthenticationData() {
        currentUser = nil
        currentToken = nil
        
        UserDefaults.standard.removeObject(forKey: userDefaultsUserKey)
        deleteTokenFromKeychain()
    }
    
    private func loadStoredAuthenticationData() {
        // 加载用户数据
        if let userData = UserDefaults.standard.data(forKey: userDefaultsUserKey),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            currentUser = user
        }
        
        // 加载令牌
        currentToken = loadTokenFromKeychain()
        
        // 检查认证状态
        checkAuthenticationStatus()
    }
    
    // MARK: - UserDefaults Operations
    
    private func saveUserToUserDefaults(_ user: User) {
        if let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: userDefaultsUserKey)
        }
    }
    
    // MARK: - Keychain Operations
    
    private func saveTokenToKeychain(_ token: AuthToken) {
        guard let tokenData = try? JSONEncoder().encode(token) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainTokenKey,
            kSecValueData as String: tokenData
        ]
        
        // 删除现有项目
        SecItemDelete(query as CFDictionary)
        
        // 添加新项目
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func loadTokenFromKeychain() -> AuthToken? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainTokenKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let token = try? JSONDecoder().decode(AuthToken.self, from: data) else {
            return nil
        }
        
        return token
    }
    
    private func deleteTokenFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainTokenKey
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}

// MARK: - Debug Extensions

#if DEBUG
extension AuthManager {
    
    /// 测试用：模拟登录成功
    func simulateSuccessfulLogin() {
        let testUser = User(
            id: "test_user_id",
            username: "testuser",
            email: "test@dealmind.com",
            displayName: "测试用户",
            avatarURL: nil,
            createdAt: Date(),
            lastLoginAt: Date()
        )
        
        let testToken = AuthToken(
            accessToken: "test_access_token",
            refreshToken: "test_refresh_token",
            expiresAt: Date().addingTimeInterval(3600)
        )
        
        handleSuccessfulLogin(user: testUser, token: testToken)
    }
    
    /// 测试用：清除所有认证数据
    func clearAllAuthData() {
        logout()
    }
    
    /// 获取调试信息
    var debugInfo: String {
        let authStatus = isAuthenticated ? "已认证" : "未认证"
        let userInfo = currentUser?.username ?? "无用户"
        let tokenInfo = currentToken != nil ? "有令牌" : "无令牌"
        return "认证状态: \(authStatus), 用户: \(userInfo), 令牌: \(tokenInfo)"
    }
}
#endif 