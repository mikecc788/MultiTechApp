//
//  HomeViewController.swift
//  DealMind
//
//  Created by app on 2025/7/8.
//

import UIKit
import SnapKit

/// 主页面控制器
class HomeViewController: UIViewController {
    
    // MARK: - UI Components
    
    /// 科技感背景视图
    private let backgroundView = TechBackgroundView()
    
    /// 导航栏容器
    private let navigationContainer = UIView()
    
    /// 标题标签
    private let titleLabel = UILabel()
    
    /// 用户头像按钮
    private let avatarButton = UIButton(type: .custom)
    
    /// 主要内容滚动视图
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    /// 欢迎卡片
    private let welcomeCard = UIView()
    private let welcomeLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    /// 功能卡片容器
    private let featuresContainer = UIView()
    
    /// 快捷功能按钮
    private let dealAnalysisButton = TechButton(title: "交易分析", style: .primary, size: .large)
    private let marketInsightButton = TechButton(title: "市场洞察", style: .secondary, size: .large)
    private let portfolioButton = TechButton(title: "投资组合", style: .outline, size: .large)
    
    /// 数据统计卡片
    private let statsCard = UIView()
    private let statsLabel = UILabel()
    private let profitLabel = UILabel()
    private let growthLabel = UILabel()
    
    // MARK: - Properties
    
    /// 退出登录回调
    var logoutHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupAppearance()
        setupActions()
        configureContent()
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
    
    // MARK: - Setup Methods
    
    private func setupView() {
        view.backgroundColor = UIDesignSystem.Colors.backgroundPrimary
        
        // 设置视图层次
        view.addSubview(backgroundView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 导航栏
        contentView.addSubview(navigationContainer)
        navigationContainer.addSubview(titleLabel)
        navigationContainer.addSubview(avatarButton)
        
        // 主要内容
        contentView.addSubview(welcomeCard)
        welcomeCard.addSubview(welcomeLabel)
        welcomeCard.addSubview(subtitleLabel)
        
        contentView.addSubview(featuresContainer)
        featuresContainer.addSubview(dealAnalysisButton)
        featuresContainer.addSubview(marketInsightButton)
        featuresContainer.addSubview(portfolioButton)
        
        contentView.addSubview(statsCard)
        statsCard.addSubview(statsLabel)
        statsCard.addSubview(profitLabel)
        statsCard.addSubview(growthLabel)
        
        // 滚动视图配置
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
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
        }
        
        // 导航栏容器约束
        navigationContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIDesignSystem.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(UIDesignSystem.Spacing.lg)
            make.height.equalTo(44)
        }
        
        // 标题约束
        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        
        // 头像按钮约束
        avatarButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.size.equalTo(44)
        }
        
        // 欢迎卡片约束
        welcomeCard.snp.makeConstraints { make in
            make.top.equalTo(navigationContainer.snp.bottom).offset(UIDesignSystem.Spacing.xl)
            make.leading.trailing.equalToSuperview().inset(UIDesignSystem.Spacing.lg)
        }
        
        // 欢迎标签约束
        welcomeLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(UIDesignSystem.Spacing.lg)
        }
        
        // 副标题约束
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(UIDesignSystem.Spacing.sm)
            make.leading.trailing.bottom.equalToSuperview().inset(UIDesignSystem.Spacing.lg)
        }
        
        // 功能容器约束
        featuresContainer.snp.makeConstraints { make in
            make.top.equalTo(welcomeCard.snp.bottom).offset(UIDesignSystem.Spacing.xl)
            make.leading.trailing.equalToSuperview().inset(UIDesignSystem.Spacing.lg)
        }
        
        // 交易分析按钮约束
        dealAnalysisButton.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        // 市场洞察按钮约束
        marketInsightButton.snp.makeConstraints { make in
            make.top.equalTo(dealAnalysisButton.snp.bottom).offset(UIDesignSystem.Spacing.md)
            make.leading.trailing.equalToSuperview()
        }
        
        // 投资组合按钮约束
        portfolioButton.snp.makeConstraints { make in
            make.top.equalTo(marketInsightButton.snp.bottom).offset(UIDesignSystem.Spacing.md)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        // 统计卡片约束
        statsCard.snp.makeConstraints { make in
            make.top.equalTo(featuresContainer.snp.bottom).offset(UIDesignSystem.Spacing.xl)
            make.leading.trailing.equalToSuperview().inset(UIDesignSystem.Spacing.lg)
            make.bottom.equalToSuperview().inset(UIDesignSystem.Spacing.xl)
        }
        
        // 统计标签约束
        statsLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(UIDesignSystem.Spacing.lg)
        }
        
        // 利润标签约束
        profitLabel.snp.makeConstraints { make in
            make.top.equalTo(statsLabel.snp.bottom).offset(UIDesignSystem.Spacing.lg)
            make.leading.trailing.equalToSuperview().inset(UIDesignSystem.Spacing.lg)
        }
        
        // 增长标签约束
        growthLabel.snp.makeConstraints { make in
            make.top.equalTo(profitLabel.snp.bottom).offset(UIDesignSystem.Spacing.sm)
            make.leading.trailing.bottom.equalToSuperview().inset(UIDesignSystem.Spacing.lg)
        }
    }
    
    private func setupAppearance() {
        // 标题样式
        titleLabel.text = "DealMind"
        titleLabel.font = UIDesignSystem.Typography.techTitle
        titleLabel.textColor = UIDesignSystem.Colors.textPrimary
        
        // 头像按钮样式
        avatarButton.setImage(UIImage(systemName: "person.circle.fill"), for: .normal)
        avatarButton.tintColor = UIDesignSystem.Colors.primary
        avatarButton.layer.cornerRadius = 22
        avatarButton.backgroundColor = UIDesignSystem.Colors.backgroundCard.withAlphaComponent(0.8)
        avatarButton.applyShadow(UIDesignSystem.Shadows.medium)
        
        // 欢迎卡片样式
        setupCardStyle(welcomeCard)
        
        welcomeLabel.text = "欢迎回来！"
        welcomeLabel.font = UIDesignSystem.Typography.title1
        welcomeLabel.textColor = UIDesignSystem.Colors.textPrimary
        
        subtitleLabel.text = "准备好开始您的智能交易之旅了吗？"
        subtitleLabel.font = UIDesignSystem.Typography.body
        subtitleLabel.textColor = UIDesignSystem.Colors.textSecondary
        subtitleLabel.numberOfLines = 0
        
        // 统计卡片样式
        setupCardStyle(statsCard)
        
        statsLabel.text = "今日统计"
        statsLabel.font = UIDesignSystem.Typography.headline
        statsLabel.textColor = UIDesignSystem.Colors.textPrimary
        
        profitLabel.text = "总收益: +$12,345.67"
        profitLabel.font = UIDesignSystem.Typography.title2
        profitLabel.textColor = UIDesignSystem.Colors.success
        
        growthLabel.text = "增长率: +15.2%"
        growthLabel.font = UIDesignSystem.Typography.callout
        growthLabel.textColor = UIDesignSystem.Colors.accent
    }
    
    private func setupCardStyle(_ card: UIView) {
        card.backgroundColor = UIDesignSystem.Colors.backgroundCard.withAlphaComponent(0.9)
        card.layer.cornerRadius = UIDesignSystem.CornerRadius.large
        card.applyShadow(UIDesignSystem.Shadows.medium)
        
        // 添加边框光效
        card.layer.borderWidth = 1
        card.layer.borderColor = UIDesignSystem.Colors.borderPrimary.cgColor
    }
    
    private func setupActions() {
        avatarButton.addTarget(self, action: #selector(avatarTapped), for: .touchUpInside)
        dealAnalysisButton.addTarget(self, action: #selector(dealAnalysisTapped), for: .touchUpInside)
        marketInsightButton.addTarget(self, action: #selector(marketInsightTapped), for: .touchUpInside)
        portfolioButton.addTarget(self, action: #selector(portfolioTapped), for: .touchUpInside)
    }
    
    private func configureContent() {
        // 设置按钮图标
        dealAnalysisButton.setImage(UIImage(systemName: "chart.line.uptrend.xyaxis"), for: .normal)
        marketInsightButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        portfolioButton.setImage(UIImage(systemName: "briefcase.fill"), for: .normal)
        
        // 启用霓虹光效
        dealAnalysisButton.setNeonGlowEnabled(true)
        marketInsightButton.setNeonGlowEnabled(true)
        portfolioButton.setNeonGlowEnabled(true)
    }
    
    // MARK: - Animation Methods
    
    private func startBackgroundAnimation() {
        backgroundView.setEffect(.combination)
        backgroundView.startEffect()
    }
    
    private func playEntranceAnimation() {
        // 初始化动画状态
        let animationViews = [navigationContainer, welcomeCard, featuresContainer, statsCard]
        
        animationViews.enumerated().forEach { index, view in
            view.alpha = 0
            view.transform = CGAffineTransform(translationX: 0, y: 30)
        }
        
        // 执行动画序列
        animationViews.enumerated().forEach { index, view in
            UIView.animate(
                withDuration: 0.6,
                delay: TimeInterval(index) * 0.1,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.3,
                options: []
            ) {
                view.alpha = 1
                view.transform = .identity
            }
        }
    }
    
    // MARK: - Action Methods
    
    @objc private func avatarTapped() {
        showUserMenu()
    }
    
    @objc private func dealAnalysisTapped() {
        dealAnalysisButton.setLoading(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.dealAnalysisButton.setLoading(false)
            self.showFeatureAlert(title: "交易分析", message: "智能分析您的交易数据和市场趋势")
        }
    }
    
    @objc private func marketInsightTapped() {
        marketInsightButton.setLoading(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.marketInsightButton.setLoading(false)
            self.showFeatureAlert(title: "市场洞察", message: "获取实时市场数据和专业分析")
        }
    }
    
    @objc private func portfolioTapped() {
        portfolioButton.setLoading(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.portfolioButton.setLoading(false)
            self.showFeatureAlert(title: "投资组合", message: "管理和优化您的投资组合")
        }
    }
    
    private func showUserMenu() {
        let alert = UIAlertController(title: "用户菜单", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "个人设置", style: .default) { _ in
            self.showFeatureAlert(title: "个人设置", message: "个人信息和偏好设置")
        })
        
        alert.addAction(UIAlertAction(title: "账户安全", style: .default) { _ in
            self.showFeatureAlert(title: "账户安全", message: "密码修改和安全设置")
        })
        
        alert.addAction(UIAlertAction(title: "退出登录", style: .destructive) { _ in
            self.confirmLogout()
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        
        // iPad适配
        if let popover = alert.popoverPresentationController {
            popover.sourceView = avatarButton
            popover.sourceRect = avatarButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    private func confirmLogout() {
        let alert = UIAlertController(
            title: "确认退出",
            message: "您确定要退出登录吗？",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "退出", style: .destructive) { _ in
            self.logoutHandler?()
        })
        
        present(alert, animated: true)
    }
    
    private func showFeatureAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Tab Bar Configuration

extension HomeViewController {
    
    /// 配置为Tab Bar项
    static func createTabBarItem() -> HomeViewController {
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(
            title: "首页",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        return homeVC
    }
} 