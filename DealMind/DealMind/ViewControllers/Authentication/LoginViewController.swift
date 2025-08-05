//
//  LoginViewController.swift
//  DealMind
//
//  Created by app on 2025/7/8.
//

import UIKit
import SnapKit
/// 登录页面控制器
class LoginViewController: BaseAuthViewController {
    
    // MARK: - UI Components
    
    /// 邮箱输入框
    private let emailTextField = TechTextField(type: .email, placeholder: "邮箱地址")
    
    /// 密码输入框
    private let passwordTextField = TechTextField(type: .password, placeholder: "密码")
    
    /// 忘记密码按钮
    private let forgotPasswordButton = UIButton(type: .system)
    
    /// 登录按钮
    private let loginButton = TechButton(title: "登录", style: .primary, size: .large)
    
    /// 或者分割线容器
    private let dividerContainer = UIView()
    private let leftLine = UIView()
    private let rightLine = UIView()
    private let dividerLabel = UILabel()
    
    /// 社交登录容器
    private let socialLoginContainer = UIView()
    
    /// Apple登录按钮
    private let appleLoginButton = TechButton(title: "使用 Apple 登录", style: .secondary, size: .medium)
    
    /// 注册提示容器
    private let signupContainer = UIView()
    private let signupPromptLabel = UILabel()
    private let signupButton = UIButton(type: .system)
    
    // MARK: - Properties
    
    /// 登录回调
    var loginCompletion: ((String, String) -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginUI()
        setupConstraints()
        setupActions()
        configureContent()
    }
    
    // MARK: - Setup Methods
    
    private func setupLoginUI() {
        // 添加UI组件到主要内容容器
        mainContentView.addSubview(emailTextField)
        mainContentView.addSubview(passwordTextField)
        mainContentView.addSubview(forgotPasswordButton)
        mainContentView.addSubview(loginButton)
        
        // 添加分割线容器
        mainContentView.addSubview(dividerContainer)
        dividerContainer.addSubview(leftLine)
        dividerContainer.addSubview(rightLine)
        dividerContainer.addSubview(dividerLabel)
        
        // 添加社交登录
        mainContentView.addSubview(socialLoginContainer)
        socialLoginContainer.addSubview(appleLoginButton)
        
        // 添加注册提示到底部容器
        bottomContentView.addSubview(signupContainer)
        signupContainer.addSubview(signupPromptLabel)
        signupContainer.addSubview(signupButton)
    }
    
    private func setupConstraints() {
        // 邮箱输入框约束
        emailTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        // 密码输入框约束
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(UIDesignSystem.Spacing.md)
            make.leading.trailing.equalToSuperview()
        }
        
        // 忘记密码按钮约束
        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(UIDesignSystem.Spacing.sm)
            make.trailing.equalToSuperview()
        }
        
        // 登录按钮约束
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(forgotPasswordButton.snp.bottom).offset(UIDesignSystem.Spacing.xl)
            make.leading.trailing.equalToSuperview()
        }
        
        // 分割线容器约束
        dividerContainer.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(UIDesignSystem.Spacing.xl)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
        
        // 分割线组件约束
        dividerLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        leftLine.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(dividerLabel.snp.leading).offset(-UIDesignSystem.Spacing.md)
            make.centerY.equalToSuperview()
            make.height.equalTo(1)
        }
        
        rightLine.snp.makeConstraints { make in
            make.leading.equalTo(dividerLabel.snp.trailing).offset(UIDesignSystem.Spacing.md)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(1)
        }
        
        // 社交登录容器约束
        socialLoginContainer.snp.makeConstraints { make in
            make.top.equalTo(dividerContainer.snp.bottom).offset(UIDesignSystem.Spacing.lg)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // Apple登录按钮约束
        appleLoginButton.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        // 注册容器约束
        signupContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // 注册提示标签约束
        signupPromptLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        // 注册按钮约束
        signupButton.snp.makeConstraints { make in
            make.leading.equalTo(signupPromptLabel.snp.trailing).offset(UIDesignSystem.Spacing.xs)
            make.trailing.top.bottom.equalToSuperview()
        }
    }
    
    private func setupActions() {
        // 输入框回调
        emailTextField.textChanged = { [weak self] text in
            self?.validateInput()
        }
        
        passwordTextField.textChanged = { [weak self] text in
            self?.validateInput()
        }
        
        passwordTextField.shouldReturn = { [weak self] in
            self?.performLogin()
            return true
        }
        
        // 按钮事件
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        appleLoginButton.addTarget(self, action: #selector(appleLoginTapped), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
    }
    
    private func configureContent() {
        // 设置页面标题
        setTitle("欢迎回来", subtitle: "登录您的账户以继续")
        
        // 配置忘记密码按钮
        forgotPasswordButton.setTitle("忘记密码？", for: .normal)
        forgotPasswordButton.setTitleColor(UIDesignSystem.Colors.primary, for: .normal)
        forgotPasswordButton.titleLabel?.font = UIDesignSystem.Typography.callout
        
        // 配置分割线
        dividerLabel.text = "或者"
        dividerLabel.font = UIDesignSystem.Typography.callout
        dividerLabel.textColor = UIDesignSystem.Colors.textSecondary
        dividerLabel.backgroundColor = UIDesignSystem.Colors.backgroundPrimary
        
        leftLine.backgroundColor = UIDesignSystem.Colors.borderSecondary
        rightLine.backgroundColor = UIDesignSystem.Colors.borderSecondary
        
        // 配置Apple登录按钮
        appleLoginButton.setImage(UIImage(systemName: "applelogo"), for: .normal)
        appleLoginButton.imageView?.contentMode = .scaleAspectFit
        appleLoginButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        
        // 配置注册提示
        signupPromptLabel.text = "还没有账户？"
        signupPromptLabel.font = UIDesignSystem.Typography.callout
        signupPromptLabel.textColor = UIDesignSystem.Colors.textSecondary
        
        signupButton.setTitle("立即注册", for: .normal)
        signupButton.setTitleColor(UIDesignSystem.Colors.primary, for: .normal)
        signupButton.titleLabel?.font = UIDesignSystem.Typography.callout
        
        // 初始状态
        loginButton.isEnabled = false
        loginButton.alpha = 0.6
    }
    
    // MARK: - Validation
    
    private func validateInput() {
        let emailValid = isValidEmail(emailTextField.text ?? "")
        let passwordValid = (passwordTextField.text?.count ?? 0) >= 6
        
        // 更新输入框状态
        if ((emailTextField.text?.isEmpty) == nil) {
            emailTextField.setValidationState(emailValid ? .valid : .invalid)
            if !emailValid {
                emailTextField.showError("请输入有效的邮箱地址")
            } else {
                emailTextField.clearError()
            }
        }
        
        if ((passwordTextField.text?.isEmpty) == nil) {
            passwordTextField.setValidationState(passwordValid ? .valid : .invalid)
            if !passwordValid {
                passwordTextField.showError("密码至少需要6个字符")
            } else {
                passwordTextField.clearError()
            }
        }
        
        // 更新登录按钮状态
        let allValid = emailValid && passwordValid
        loginButton.isEnabled = allValid
        
        UIView.animate(withDuration: UIDesignSystem.Animation.fastDuration) {
            self.loginButton.alpha = allValid ? 1.0 : 0.6
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // MARK: - Actions
    
    @objc private func forgotPasswordTapped() {
        let alert = UIAlertController(title: "重置密码", message: "请输入您的邮箱地址", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "邮箱地址"
            textField.keyboardType = .emailAddress
        }
        
        alert.addAction(UIAlertAction(title: "发送", style: .default) { _ in
            if let email = alert.textFields?.first?.text, !email.isEmpty {
                self.showResetPasswordSent(email: email)
            }
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func loginTapped() {
        performLogin()
    }
    
    @objc private func appleLoginTapped() {
        // 实现Apple登录逻辑
        showLoading(true)
        
        // 模拟网络请求
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showLoading(false)
            self.playSuccessAnimation()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                // 跳转到主页面
                self.navigateToMainApp()
            }
        }
    }
    
    @objc private func signupTapped() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    private func performLogin() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              !email.isEmpty,
              !password.isEmpty else {
            return
        }
        
        // 清除焦点
        view.endEditing(true)
        
        // 显示加载状态
        loginButton.setLoading(true)
        showLoading(true)
        
        // 执行登录逻辑
        loginCompletion?(email, password)
        
        // 模拟网络请求
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.loginButton.setLoading(false)
            self.showLoading(false)
            
            // 模拟登录成功
            if email == "test@example.com" && password == "123456" {
                self.loginButton.animateSuccess {
                    self.playSuccessAnimation()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.navigateToMainApp()
                    }
                }
            } else {
                self.loginButton.animateError()
                self.showError("邮箱或密码错误")
            }
        }
    }
    
    private func showResetPasswordSent(email: String) {
        let alert = UIAlertController(
            title: "邮件已发送",
            message: "重置密码的链接已发送到 \(email)，请查收邮件。",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    private func navigateToMainApp() {
        // 跳转到主应用页面
        let mainViewController = UIViewController()
        mainViewController.view.backgroundColor = UIDesignSystem.Colors.backgroundPrimary
        
        let label = UILabel()
        label.text = "欢迎使用 DealMind!"
        label.font = UIDesignSystem.Typography.largeTitle
        label.textColor = UIDesignSystem.Colors.textPrimary
        label.textAlignment = .center
        
        mainViewController.view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // 替换根视图控制器
        if let window = view.window {
            window.rootViewController = mainViewController
            window.makeKeyAndVisible()
        }
    }
}

// MARK: - Static Factory

extension LoginViewController {
    
    /// 创建登录页面
    /// - Parameter completion: 登录完成回调
    /// - Returns: 登录页面实例
    static func create(completion: @escaping (String, String) -> Void) -> LoginViewController {
        let loginVC = LoginViewController()
        loginVC.loginCompletion = completion
        return loginVC
    }
} 
