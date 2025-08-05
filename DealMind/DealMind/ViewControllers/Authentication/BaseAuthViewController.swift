//
//  BaseAuthViewController.swift
//  DealMind
//
//  Created by app on 2025/7/8.
//

import UIKit


/// 认证页面基础控制器
/// 提供通用的科技感背景、动画效果和基础UI配置
class BaseAuthViewController: UIViewController {
    
    // MARK: - UI Components
    
    /// 科技感背景视图
    let backgroundView = TechBackgroundView()
    
    /// 内容滚动视图
    let scrollView = UIScrollView()
    
    /// 内容容器视图
    let contentView = UIView()
    
    /// Logo图片视图
    let logoImageView = UIImageView()
    
    /// 标题标签
    let titleLabel = UILabel()
    
    /// 副标题标签
    let subtitleLabel = UILabel()
    
    /// 主要内容容器
    let mainContentView = UIView()
    
    /// 底部容器视图
    let bottomContentView = UIView()
    
    // MARK: - Properties
    
    /// 是否启用键盘管理
    var enableKeyboardManagement: Bool = true
    
    /// 内容边距
    var contentInsets = UIEdgeInsets(all: UIDesignSystem.Spacing.lg)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupAppearance()
        setupKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startBackgroundAnimation()
        playEntranceAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        backgroundView.stopEffect()
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        view.backgroundColor = UIDesignSystem.Colors.backgroundPrimary
        
        // 设置视图层次
        view.addSubview(backgroundView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 内容视图结构
        contentView.addSubview(logoImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(mainContentView)
        contentView.addSubview(bottomContentView)
        
        // 配置滚动视图
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.keyboardDismissMode = .interactive
        scrollView.contentInsetAdjustmentBehavior = .never
        
        // 隐藏导航栏
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupConstraints() {
        // 背景视图约束
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 滚动视图约束
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        // 内容视图约束
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview()
        }
        
        // Logo约束
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIDesignSystem.Spacing.xxxl)
            make.centerX.equalToSuperview()
            make.size.equalTo(120)
        }
        
        // 标题约束
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(UIDesignSystem.Spacing.xl)
            make.leading.trailing.equalToSuperview().inset(contentInsets.left)
        }
        
        // 副标题约束
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(UIDesignSystem.Spacing.sm)
            make.leading.trailing.equalToSuperview().inset(contentInsets.left)
        }
        
        // 主要内容约束
        mainContentView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(UIDesignSystem.Spacing.xl)
            make.leading.trailing.equalToSuperview().inset(contentInsets.left)
        }
        
        // 底部内容约束
        bottomContentView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(mainContentView.snp.bottom).offset(UIDesignSystem.Spacing.xl)
            make.leading.trailing.equalToSuperview().inset(contentInsets.left)
            make.bottom.equalToSuperview().inset(contentInsets.bottom)
        }
    }
    
    private func setupAppearance() {
        // Logo配置
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(systemName: "brain.head.profile")
        logoImageView.tintColor = UIDesignSystem.Colors.primary
        logoImageView.layer.cornerRadius = 20
        logoImageView.backgroundColor = UIDesignSystem.Colors.backgroundCard.withAlphaComponent(0.8)
        logoImageView.applyShadow(UIDesignSystem.Shadows.large)
        
        // 标题样式
        titleLabel.font = UIDesignSystem.Typography.largeTitle
        titleLabel.textColor = UIDesignSystem.Colors.textPrimary
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        // 副标题样式
        subtitleLabel.font = UIDesignSystem.Typography.body
        subtitleLabel.textColor = UIDesignSystem.Colors.textSecondary
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        
        // 主要内容容器样式
        mainContentView.backgroundColor = UIColor.clear
        
        // 底部内容容器样式
        bottomContentView.backgroundColor = UIColor.clear
    }
    
    // MARK: - Background Animation
    
    private func startBackgroundAnimation() {
        backgroundView.setEffect(.combination)
        backgroundView.startEffect()
        backgroundView.addPulseEffect()
    }
    
    private func playEntranceAnimation() {
        // 初始化动画状态
        logoImageView.alpha = 0
        logoImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransform(translationX: 0, y: 30)
        
        subtitleLabel.alpha = 0
        subtitleLabel.transform = CGAffineTransform(translationX: 0, y: 30)
        
        mainContentView.alpha = 0
        mainContentView.transform = CGAffineTransform(translationX: 0, y: 50)
        
        bottomContentView.alpha = 0
        bottomContentView.transform = CGAffineTransform(translationX: 0, y: 30)
        
        // 执行动画序列
        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            self.logoImageView.alpha = 1
            self.logoImageView.transform = .identity
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.5, options: .curveEaseOut) {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = .identity
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.7, options: .curveEaseOut) {
            self.subtitleLabel.alpha = 1
            self.subtitleLabel.transform = .identity
        }
        
        UIView.animate(withDuration: 0.8, delay: 0.9, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3) {
            self.mainContentView.alpha = 1
            self.mainContentView.transform = .identity
        }
        
        UIView.animate(withDuration: 0.6, delay: 1.1, options: .curveEaseOut) {
            self.bottomContentView.alpha = 1
            self.bottomContentView.transform = .identity
        }
    }
    
    // MARK: - Keyboard Management
    
    private func setupKeyboardNotifications() {
        guard enableKeyboardManagement else { return }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
        
        // 如果有第一响应者，滚动到可见区域
        if let activeTextField = findFirstResponder() {
            let rect = activeTextField.convert(activeTextField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(rect, animated: true)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset = .zero
            self.scrollView.scrollIndicatorInsets = .zero
        }
    }
    
    private func findFirstResponder() -> UIView? {
        return view.subviews.first { $0.isFirstResponder } ?? view.findFirstResponder()
    }
    
    // MARK: - Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - Public Methods
    
    /// 设置页面标题和副标题
    /// - Parameters:
    ///   - title: 主标题
    ///   - subtitle: 副标题
    func setTitle(_ title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    /// 显示加载状态
    /// - Parameter isLoading: 是否加载中
    func showLoading(_ isLoading: Bool) {
        if isLoading {
            // 可以在这里添加全局加载指示器
            view.isUserInteractionEnabled = false
        } else {
            view.isUserInteractionEnabled = true
        }
    }
    
    /// 显示错误提示
    /// - Parameter message: 错误信息
    func showError(_ message: String) {
        let alert = UIAlertController(title: "错误", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
    
    /// 播放成功动画
    func playSuccessAnimation() {
        logoImageView.addNeonGlowAnimation(color: UIDesignSystem.Colors.success)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.logoImageView.removeAllAnimations()
        }
    }
}

// MARK: - UIView Extension for First Responder

extension UIView {
    func findFirstResponder() -> UIView? {
        if isFirstResponder {
            return self
        }
        
        for subview in subviews {
            if let firstResponder = subview.findFirstResponder() {
                return firstResponder
            }
        }
        
        return nil
    }
} 
