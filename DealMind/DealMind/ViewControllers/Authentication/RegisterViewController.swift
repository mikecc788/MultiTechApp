//
//  RegisterViewController.swift
//  DealMind
//
//  Created by app on 2025/7/8.
//

import UIKit
import SnapKit

/// 注册页面控制器
class RegisterViewController: BaseAuthViewController {
    
    // MARK: - UI Components
    
    /// 姓名输入框
    private let nameTextField = TechTextField(type: .text, placeholder: "姓名")
    
    /// 邮箱输入框
    private let emailTextField = TechTextField(type: .email, placeholder: "邮箱地址")
    
    /// 密码输入框
    private let passwordTextField = TechTextField(type: .password, placeholder: "密码")
    
    /// 确认密码输入框
    private let confirmPasswordTextField = TechTextField(type: .password, placeholder: "确认密码")
    
    /// 同意条款容器
    private let termsContainer = UIView()
    private let termsCheckbox = UIButton(type: .custom)
    private let termsLabel = UILabel()
    
    /// 注册按钮
    private let registerButton = TechButton(title: "注册", style: .primary, size: .large)
    
    /// 或者分割线容器
    private let dividerContainer = UIView()
    private let leftLine = UIView()
    private let rightLine = UIView()
    private let dividerLabel = UILabel()
    
    /// 社交登录容器
    private let socialLoginContainer = UIView()
    
    /// Apple注册按钮
    private let appleRegisterButton = TechButton(title: "使用 Apple 注册", style: .secondary, size: .medium)
    
    /// 登录提示容器
    private let loginContainer = UIView()
    private let loginPromptLabel = UILabel()
    private let loginButton = UIButton(type: .system)
    
    // MARK: - Properties
    
    /// 注册回调
    var registerCompletion: ((String, String, String) -> Void)?
    
    /// 是否同意条款
    private var hasAgreedToTerms = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRegisterUI()
        setupConstraints()
        setupActions()
        configureContent()
    }
    
    // MARK: - Setup Methods
    
    private func setupRegisterUI() {
        // 添加UI组件到主要内容容器
        mainContentView.addSubview(nameTextField)
        mainContentView.addSubview(emailTextField)
        mainContentView.addSubview(passwordTextField)
        mainContentView.addSubview(confirmPasswordTextField)
        mainContentView.addSubview(termsContainer)
        mainContentView.addSubview(registerButton)
        
        // 添加条款组件
        termsContainer.addSubview(termsCheckbox)
        termsContainer.addSubview(termsLabel)
        
        // 添加分割线容器
        mainContentView.addSubview(dividerContainer)
        dividerContainer.addSubview(leftLine)
        dividerContainer.addSubview(rightLine)
        dividerContainer.addSubview(dividerLabel)
        
        // 添加社交注册
        mainContentView.addSubview(socialLoginContainer)
        socialLoginContainer.addSubview(appleRegisterButton)
        
        // 添加登录提示到底部容器
        bottomContentView.addSubview(loginContainer)
        loginContainer.addSubview(loginPromptLabel)
        loginContainer.addSubview(loginButton)
    }
    
    private func setupConstraints() {
        // 姓名输入框约束
        nameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        // 邮箱输入框约束
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(UIDesignSystem.Spacing.md)
            make.leading.trailing.equalToSuperview()
        }
        
        // 密码输入框约束
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(UIDesignSystem.Spacing.md)
            make.leading.trailing.equalToSuperview()
        }
        
        // 确认密码输入框约束
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(UIDesignSystem.Spacing.md)
            make.leading.trailing.equalToSuperview()
        }
        
        // 条款容器约束
        termsContainer.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(UIDesignSystem.Spacing.lg)
            make.leading.trailing.equalToSuperview()
        }
        
        // 条款复选框约束
        termsCheckbox.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.size.equalTo(24)
        }
        
        // 条款标签约束
        termsLabel.snp.makeConstraints { make in
            make.leading.equalTo(termsCheckbox.snp.trailing).offset(UIDesignSystem.Spacing.sm)
            make.trailing.top.bottom.equalToSuperview()
        }
        
        // 注册按钮约束
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(termsContainer.snp.bottom).offset(UIDesignSystem.Spacing.xl)
            make.leading.trailing.equalToSuperview()
        }
        
        // 分割线容器约束
        dividerContainer.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(UIDesignSystem.Spacing.xl)
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
        
        // 社交注册容器约束
        socialLoginContainer.snp.makeConstraints { make in
            make.top.equalTo(dividerContainer.snp.bottom).offset(UIDesignSystem.Spacing.lg)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // Apple注册按钮约束
        appleRegisterButton.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        // 登录容器约束
        loginContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        // 登录提示标签约束
        loginPromptLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        // 登录按钮约束
        loginButton.snp.makeConstraints { make in
            make.leading.equalTo(loginPromptLabel.snp.trailing).offset(UIDesignSystem.Spacing.xs)
            make.trailing.top.bottom.equalToSuperview()
        }
    }
    
    private func setupActions() {
        // 输入框回调
        nameTextField.textChanged = { [weak self] text in
            self?.validateInput()
        }
        
        emailTextField.textChanged = { [weak self] text in
            self?.validateInput()
        }
        
        passwordTextField.textChanged = { [weak self] text in
            self?.validateInput()
        }
        
        confirmPasswordTextField.textChanged = { [weak self] text in
            self?.validateInput()
        }
        
        confirmPasswordTextField.shouldReturn = { [weak self] in
            self?.performRegister()
            return true
        }
        
        // 按钮事件
        termsCheckbox.addTarget(self, action: #selector(termsCheckboxTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        appleRegisterButton.addTarget(self, action: #selector(appleRegisterTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        // 添加条款标签点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(termsLabelTapped))
        termsLabel.addGestureRecognizer(tapGesture)
        termsLabel.isUserInteractionEnabled = true
    }
    
    private func configureContent() {
        // 设置页面标题
        setTitle("创建账户", subtitle: "注册以开始您的智能之旅")
        
        // 配置条款复选框
        termsCheckbox.setImage(UIImage(systemName: "square"), for: .normal)
        termsCheckbox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        termsCheckbox.tintColor = UIDesignSystem.Colors.primary
        
        // 配置条款标签
        let termsText = "我同意 用户协议 和 隐私政策"
        let attributedString = NSMutableAttributedString(string: termsText)
        attributedString.addAttribute(.foregroundColor, value: UIDesignSystem.Colors.textSecondary, range: NSRange(location: 0, length: termsText.count))
        attributedString.addAttribute(.font, value: UIDesignSystem.Typography.callout, range: NSRange(location: 0, length: termsText.count))
        
        // 高亮关键词
        let userAgreementRange = (termsText as NSString).range(of: "用户协议")
        let privacyPolicyRange = (termsText as NSString).range(of: "隐私政策")
        
        attributedString.addAttribute(.foregroundColor, value: UIDesignSystem.Colors.primary, range: userAgreementRange)
        attributedString.addAttribute(.foregroundColor, value: UIDesignSystem.Colors.primary, range: privacyPolicyRange)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: userAgreementRange)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: privacyPolicyRange)
        
        termsLabel.attributedText = attributedString
        termsLabel.numberOfLines = 0
        
        // 配置分割线
        dividerLabel.text = "或者"
        dividerLabel.font = UIDesignSystem.Typography.callout
        dividerLabel.textColor = UIDesignSystem.Colors.textSecondary
        dividerLabel.backgroundColor = UIDesignSystem.Colors.backgroundPrimary
        
        leftLine.backgroundColor = UIDesignSystem.Colors.borderSecondary
        rightLine.backgroundColor = UIDesignSystem.Colors.borderSecondary
        
        // 配置Apple注册按钮
        appleRegisterButton.setImage(UIImage(systemName: "applelogo"), for: .normal)
        appleRegisterButton.imageView?.contentMode = .scaleAspectFit
        appleRegisterButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        
        // 配置登录提示
        loginPromptLabel.text = "已有账户？"
        loginPromptLabel.font = UIDesignSystem.Typography.callout
        loginPromptLabel.textColor = UIDesignSystem.Colors.textSecondary
        
        loginButton.setTitle("立即登录", for: .normal)
        loginButton.setTitleColor(UIDesignSystem.Colors.primary, for: .normal)
        loginButton.titleLabel?.font = UIDesignSystem.Typography.callout
        
        // 初始状态
        registerButton.isEnabled = false
        registerButton.alpha = 0.6
    }
    
    // MARK: - Validation
    
    private func validateInput() {
        let nameValid = (nameTextField.text?.count ?? 0) >= 2
        let emailValid = isValidEmail(emailTextField.text ?? "")
        let passwordValid = isValidPassword(passwordTextField.text ?? "")
        let confirmPasswordValid = passwordTextField.text == confirmPasswordTextField.text
        
        // 更新输入框状态
        if ((nameTextField.text?.isEmpty) == nil) {
            nameTextField.setValidationState(nameValid ? .valid : .invalid)
            if !nameValid {
                nameTextField.showError("姓名至少需要2个字符")
            } else {
                nameTextField.clearError()
            }
        }
        
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
                passwordTextField.showError("密码需要至少8个字符，包含大小写字母和数字")
            } else {
                passwordTextField.clearError()
            }
        }
        
        if ((confirmPasswordTextField.text?.isEmpty) == nil) {
            confirmPasswordTextField.setValidationState(confirmPasswordValid ? .valid : .invalid)
            if !confirmPasswordValid {
                confirmPasswordTextField.showError("密码不匹配")
            } else {
                confirmPasswordTextField.clearError()
            }
        }
        
        // 更新注册按钮状态
        let allValid = nameValid && emailValid && passwordValid && confirmPasswordValid && hasAgreedToTerms
        registerButton.isEnabled = allValid
        
        UIView.animate(withDuration: UIDesignSystem.Animation.fastDuration) {
            self.registerButton.alpha = allValid ? 1.0 : 0.6
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        // 密码需要至少8个字符，包含大小写字母和数字
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d@$!%*?&]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    // MARK: - Actions
    
    @objc private func termsCheckboxTapped() {
        hasAgreedToTerms.toggle()
        termsCheckbox.isSelected = hasAgreedToTerms
        validateInput()
        
        // 添加动画效果
        UIView.animate(withDuration: 0.1) {
            self.termsCheckbox.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.termsCheckbox.transform = .identity
            }
        }
    }
    
    @objc private func termsLabelTapped() {
        showTermsAndPrivacy()
    }
    
    @objc private func registerTapped() {
        performRegister()
    }
    
    @objc private func appleRegisterTapped() {
        // 实现Apple注册逻辑
        showLoading(true)
        
        // 模拟网络请求
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showLoading(false)
            self.playSuccessAnimation()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigateToMainApp()
            }
        }
    }
    
    @objc private func loginTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func performRegister() {
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              !name.isEmpty,
              !email.isEmpty,
              !password.isEmpty else {
            return
        }
        
        // 清除焦点
        view.endEditing(true)
        
        // 显示加载状态
        registerButton.setLoading(true)
        showLoading(true)
        
        // 执行注册逻辑
        registerCompletion?(name, email, password)
        
        // 模拟网络请求
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.registerButton.setLoading(false)
            self.showLoading(false)
            
            // 模拟注册成功
            self.registerButton.animateSuccess {
                self.playSuccessAnimation()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.showRegistrationSuccess()
                }
            }
        }
    }
    
    private func showTermsAndPrivacy() {
        let alert = UIAlertController(title: "用户协议和隐私政策", message: "点击确定查看完整的用户协议和隐私政策内容。", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "用户协议", style: .default) { _ in
            // 这里可以打开用户协议页面
            self.showAlert(title: "用户协议", message: "这里是用户协议的详细内容...")
        })
        
        alert.addAction(UIAlertAction(title: "隐私政策", style: .default) { _ in
            // 这里可以打开隐私政策页面
            self.showAlert(title: "隐私政策", message: "这里是隐私政策的详细内容...")
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    private func showRegistrationSuccess() {
        let alert = UIAlertController(
            title: "注册成功",
            message: "欢迎加入 DealMind！请查收邮箱验证邮件。",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "确定", style: .default) { _ in
            self.navigateToMainApp()
        })
        
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

extension RegisterViewController {
    
    /// 创建注册页面
    /// - Parameter completion: 注册完成回调
    /// - Returns: 注册页面实例
    static func create(completion: @escaping (String, String, String) -> Void) -> RegisterViewController {
        let registerVC = RegisterViewController()
        registerVC.registerCompletion = completion
        return registerVC
    }
} 
