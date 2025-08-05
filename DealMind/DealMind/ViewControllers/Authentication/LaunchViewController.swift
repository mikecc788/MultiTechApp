//
//  LaunchViewController.swift
//  DealMind
//
//  Created by app on 2025/7/8.
//

import UIKit
import SnapKit

/// 启动页面控制器
/// 显示应用启动界面，包含Logo动画和品牌展示
class LaunchViewController: UIViewController {
    
    // MARK: - UI Components
    
    /// 科技感背景视图
    private let backgroundView = TechBackgroundView()
    
    /// Logo容器视图
    private let logoContainer = UIView()
    
    /// Logo图片视图
    private let logoImageView = UIImageView()
    
    /// 应用名称标签
    private let appNameLabel = UILabel()
    
    /// 版本信息标签
    private let versionLabel = UILabel()
    
    /// 加载指示器
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    /// 进度条
    private let progressView = UIProgressView(progressViewStyle: .default)
    
    // MARK: - Properties
    
    /// 启动完成回调
    var launchCompletionHandler: (() -> Void)?
    
    /// 当前进度
    private var currentProgress: Float = 0.0 {
        didSet {
            progressView.setProgress(currentProgress, animated: true)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startLaunchSequence()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        view.backgroundColor = UIDesignSystem.Colors.backgroundPrimary
        
        // 添加背景视图
        view.addSubview(backgroundView)
        
        // 添加Logo容器
        view.addSubview(logoContainer)
        logoContainer.addSubview(logoImageView)
        logoContainer.addSubview(appNameLabel)
        
        // 添加版本信息
        view.addSubview(versionLabel)
        
        // 添加加载组件
        view.addSubview(loadingIndicator)
        view.addSubview(progressView)
    }
    
    private func setupConstraints() {
        // 背景视图约束
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Logo容器约束
        logoContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
        }
        
        // Logo图片约束
        logoImageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(120)
        }
        
        // 应用名称约束
        appNameLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(UIDesignSystem.Spacing.lg)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        // 版本信息约束
        versionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-UIDesignSystem.Spacing.xl)
            make.centerX.equalToSuperview()
        }
        
        // 加载指示器约束
        loadingIndicator.snp.makeConstraints { make in
            make.top.equalTo(logoContainer.snp.bottom).offset(UIDesignSystem.Spacing.xxl)
            make.centerX.equalToSuperview()
        }
        
        // 进度条约束
        progressView.snp.makeConstraints { make in
            make.top.equalTo(loadingIndicator.snp.bottom).offset(UIDesignSystem.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(UIDesignSystem.Spacing.xxl)
            make.height.equalTo(4)
        }
    }
    
    private func setupAppearance() {
        // 配置Logo图片
        logoImageView.image = UIImage(systemName: "brain.head.profile")
        logoImageView.tintColor = UIDesignSystem.Colors.primary
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.alpha = 0
        logoImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        // 配置应用名称
        appNameLabel.text = "DealMind"
        appNameLabel.font = UIDesignSystem.Typography.largeTitle
        appNameLabel.textColor = UIDesignSystem.Colors.textPrimary
        appNameLabel.textAlignment = .center
        appNameLabel.alpha = 0
        appNameLabel.transform = CGAffineTransform(translationX: 0, y: 20)
        
        // 配置版本信息
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            versionLabel.text = "版本 \(version) (\(build))"
        } else {
            versionLabel.text = "版本 1.0.0"
        }
        versionLabel.font = UIDesignSystem.Typography.caption1
        versionLabel.textColor = UIDesignSystem.Colors.textSecondary
        versionLabel.textAlignment = .center
        versionLabel.alpha = 0
        
        // 配置加载指示器
        loadingIndicator.color = UIDesignSystem.Colors.primary
        loadingIndicator.alpha = 0
        
        // 配置进度条
        progressView.progressTintColor = UIDesignSystem.Colors.primary
        progressView.trackTintColor = UIDesignSystem.Colors.borderSecondary
        progressView.layer.cornerRadius = 2
        progressView.clipsToBounds = true
        progressView.alpha = 0
        progressView.progress = 0
    }
    
    // MARK: - Launch Sequence
    
    private func startLaunchSequence() {
        // 启动背景动画
        backgroundView.startEffect()
        
        // 执行启动动画序列
        animateLogoAppearance()
    }
    
    private func animateLogoAppearance() {
        // Logo出现动画
        UIView.animate(
            withDuration: 1.0,
            delay: 0.5,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.3,
            options: [.curveEaseOut]
        ) {
            self.logoImageView.alpha = 1.0
            self.logoImageView.transform = .identity
        } completion: { _ in
            self.animateAppNameAppearance()
        }
        
        // Logo发光效果
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.logoImageView.addNeonGlowAnimation(color: UIDesignSystem.Colors.primary)
        }
    }
    
    private func animateAppNameAppearance() {
        // 应用名称出现动画
        UIView.animate(
            withDuration: 0.8,
            delay: 0.2,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.2,
            options: [.curveEaseOut]
        ) {
            self.appNameLabel.alpha = 1.0
            self.appNameLabel.transform = .identity
        } completion: { _ in
            self.animateLoadingComponents()
        }
    }
    
    private func animateLoadingComponents() {
        // 加载组件出现动画
        UIView.animate(withDuration: 0.6, delay: 0.3) {
            self.loadingIndicator.alpha = 1.0
            self.progressView.alpha = 1.0
            self.versionLabel.alpha = 1.0
        } completion: { _ in
            self.startLoadingProcess()
        }
        
        // 启动加载指示器
        loadingIndicator.startAnimating()
    }
    
    private func startLoadingProcess() {
        // 模拟应用初始化过程
        simulateLoadingProgress()
    }
    
    private func simulateLoadingProgress() {
        let steps: [(String, Float, TimeInterval)] = [
            ("初始化系统...", 0.2, 0.5),
            ("加载配置文件...", 0.4, 0.3),
            ("连接服务器...", 0.6, 0.4),
            ("同步数据...", 0.8, 0.6),
            ("启动完成", 1.0, 0.3)
        ]
        
        var stepIndex = 0
        
        func executeNextStep() {
            guard stepIndex < steps.count else {
                finishLaunchSequence()
                return
            }
            
            let (_, progress, duration) = steps[stepIndex]
            stepIndex += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.currentProgress = progress
                executeNextStep()
            }
        }
        
        executeNextStep()
    }
    
    private func finishLaunchSequence() {
        // 停止加载指示器
        loadingIndicator.stopAnimating()
        
        // 完成动画
        UIView.animate(
            withDuration: 0.5,
            delay: 0.5,
            options: [.curveEaseInOut]
        ) {
            self.view.alpha = 0.0
        } completion: { _ in
            self.launchCompletionHandler?()
        }
    }
}

 