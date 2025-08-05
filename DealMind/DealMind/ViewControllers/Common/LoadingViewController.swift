//
//  LoadingViewController.swift
//  DealMind
//
//  Created by app on 2025/7/8.
//

import UIKit

/// 加载状态显示控制器
class LoadingViewController: UIViewController {
    
    // MARK: - UI Components
    
    /// 背景视图
    private let backgroundView = UIView()
    
    /// 模糊效果视图
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    
    /// 加载指示器
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    /// 消息标签
    private let messageLabel = UILabel()
    
    /// 容器视图
    private let containerView = UIView()
    
    // MARK: - Properties
    
    /// 显示的消息
    var message: String? {
        didSet {
            updateMessage()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startLoading()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopLoading()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // 设置视图层次
        view.addSubview(blurEffectView)
        view.addSubview(containerView)
        
        containerView.addSubview(activityIndicator)
        containerView.addSubview(messageLabel)
    }
    
    private func setupConstraints() {
        // 模糊效果视图约束
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 容器视图约束
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(120)
        }
        
        // 加载指示器约束
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        // 消息标签约束
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(activityIndicator.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setupAppearance() {
        // 容器视图样式
        containerView.backgroundColor = UIDesignSystem.Colors.backgroundCard.withAlphaComponent(0.9)
        containerView.layer.cornerRadius = UIDesignSystem.CornerRadius.large
        containerView.applyShadow(UIDesignSystem.Shadows.large)
        
        // 加载指示器样式
        activityIndicator.color = UIDesignSystem.Colors.primary
        activityIndicator.hidesWhenStopped = true
        
        // 消息标签样式
        messageLabel.font = UIDesignSystem.Typography.body
        messageLabel.textColor = UIDesignSystem.Colors.textPrimary
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        // 更新消息
        updateMessage()
    }
    
    // MARK: - Private Methods
    
    private func updateMessage() {
        messageLabel.text = message ?? "加载中..."
    }
    
    private func startLoading() {
        activityIndicator.startAnimating()
        
        // 添加入场动画
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: []
        ) {
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        }
    }
    
    private func stopLoading() {
        activityIndicator.stopAnimating()
    }
    
    // MARK: - Public Methods
    
    /// 更新加载消息
    func updateLoadingMessage(_ newMessage: String) {
        message = newMessage
    }
    
    /// 显示成功状态
    func showSuccess(message: String, completion: (() -> Void)? = nil) {
        activityIndicator.stopAnimating()
        messageLabel.text = message
        
        // 添加成功图标
        let successImageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        successImageView.tintColor = UIDesignSystem.Colors.success
        successImageView.contentMode = .scaleAspectFit
        
        containerView.addSubview(successImageView)
        successImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.size.equalTo(44)
        }
        
        // 更新消息标签约束
        messageLabel.snp.remakeConstraints { make in
            make.top.equalTo(successImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(20)
        }
        
        // 2秒后自动消失
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion?()
        }
    }
    
    /// 显示错误状态
    func showError(message: String, completion: (() -> Void)? = nil) {
        activityIndicator.stopAnimating()
        messageLabel.text = message
        
        // 添加错误图标
        let errorImageView = UIImageView(image: UIImage(systemName: "exclamationmark.circle.fill"))
        errorImageView.tintColor = UIDesignSystem.Colors.error
        errorImageView.contentMode = .scaleAspectFit
        
        containerView.addSubview(errorImageView)
        errorImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.size.equalTo(44)
        }
        
        // 更新消息标签约束
        messageLabel.snp.remakeConstraints { make in
            make.top.equalTo(errorImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(20)
        }
        
        // 3秒后自动消失
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            completion?()
        }
    }
} 