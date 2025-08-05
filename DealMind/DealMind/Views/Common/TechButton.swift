//
//  TechButton.swift
//  DealMind
//
//  Created by app on 2025/7/8.
//

import UIKit
import SnapKit

/// 科技感按钮组件
/// 支持霓虹光效、渐变背景、加载状态等
@IBDesignable
class TechButton: UIButton {
    
    // MARK: - Public Properties
    
    /// 按钮样式
    enum Style {
        case primary    // 主要按钮
        case secondary  // 次要按钮
        case outline    // 边框按钮
        case ghost      // 幽灵按钮
    }
    
    /// 按钮尺寸
    enum Size {
        case small
        case medium
        case large
        
        var height: CGFloat {
            switch self {
            case .small: return 32
            case .medium: return 44
            case .large: return 56
            }
        }
        
        var font: UIFont {
            switch self {
            case .small: return UIDesignSystem.Typography.footnote
            case .medium: return UIDesignSystem.Typography.body
            case .large: return UIDesignSystem.Typography.headline
            }
        }
    }
    
    /// 按钮状态
    enum LoadingState {
        case normal
        case loading
        case success
        case error
    }
    
    // MARK: - Private Properties
    
    private var gradientLayer: CAGradientLayer?
    private var borderLayer: CAShapeLayer?
    private var loadingIndicator: UIActivityIndicatorView?
    private var originalTitle: String?
    
    // MARK: - Public Configuration
    
    var buttonStyle: Style = .primary {
        didSet {
            setupAppearance()
        }
    }
    
    var buttonSize: Size = .medium {
        didSet {
            setupAppearance()
        }
    }
    
    var loadingState: LoadingState = .normal {
        didSet {
            updateLoadingState()
        }
    }
    
    /// 是否启用霓虹光效
    @IBInspectable var enableNeonGlow: Bool = true {
        didSet {
            setupAppearance()
        }
    }
    
    /// 是否启用脉冲动画
    @IBInspectable var enablePulseAnimation: Bool = false {
        didSet {
            setupPulseAnimation()
        }
    }
    
    /// 圆角半径 (0为自动计算)
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setupAppearance()
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    convenience init(title: String, style: Style = .primary, size: Size = .medium) {
        self.init(frame: .zero)
        setTitle(title, for: .normal)
        self.buttonStyle = style
        self.buttonSize = size
        setupAppearance()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
        updateBorderFrame()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupButton()
        setupAppearance()
    }
    
    // MARK: - Setup Methods
    
    private func setupButton() {
        // 基础配置
        titleLabel?.numberOfLines = 1
        titleLabel?.textAlignment = .center
        
        // 添加触摸效果
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        // 设置高度约束
        setupHeightConstraint()
        
        // 初始化加载指示器
        setupLoadingIndicator()
    }
    
    private func setupHeightConstraint() {
        snp.makeConstraints { make in
            make.height.equalTo(buttonSize.height)
        }
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator?.hidesWhenStopped = true
        loadingIndicator?.color = UIDesignSystem.Colors.textPrimary
        
        if let indicator = loadingIndicator {
            addSubview(indicator)
            indicator.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
    }
    
    private func setupAppearance() {
        // 移除旧的图层
        gradientLayer?.removeFromSuperlayer()
        borderLayer?.removeFromSuperlayer()
        
        // 设置字体
        titleLabel?.font = buttonSize.font
        
        // 设置圆角
        let radius = cornerRadius > 0 ? cornerRadius : buttonSize.height / 2
        layer.cornerRadius = radius
        layer.masksToBounds = false
        
        // 根据样式配置外观
        switch buttonStyle {
        case .primary:
            setupPrimaryStyle()
        case .secondary:
            setupSecondaryStyle()
        case .outline:
            setupOutlineStyle()
        case .ghost:
            setupGhostStyle()
        }
        
        // 设置霓虹光效
        if enableNeonGlow {
            setupNeonGlow()
        }
        
        // 设置脉冲动画
        setupPulseAnimation()
    }
    
    // MARK: - Style Setup Methods
    
    private func setupPrimaryStyle() {
        // 渐变背景
        gradientLayer = CAGradientLayer()
        gradientLayer?.colors = [
            UIDesignSystem.Colors.primary.cgColor,
            UIDesignSystem.Colors.primaryDark.cgColor
        ]
        gradientLayer?.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer?.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer?.cornerRadius = layer.cornerRadius
        
        if let gradient = gradientLayer {
            layer.insertSublayer(gradient, at: 0)
        }
        
        setTitleColor(UIDesignSystem.Colors.textPrimary, for: .normal)
        setTitleColor(UIDesignSystem.Colors.textSecondary, for: .disabled)
    }
    
    private func setupSecondaryStyle() {
        backgroundColor = UIDesignSystem.Colors.backgroundCard
        setTitleColor(UIDesignSystem.Colors.primary, for: .normal)
        setTitleColor(UIDesignSystem.Colors.textTertiary, for: .disabled)
        
        applyShadow(UIDesignSystem.Shadows.medium)
    }
    
    private func setupOutlineStyle() {
        backgroundColor = UIColor.clear
        
        borderLayer = CAShapeLayer()
        borderLayer?.fillColor = UIColor.clear.cgColor
        borderLayer?.strokeColor = UIDesignSystem.Colors.borderActive.cgColor
        borderLayer?.lineWidth = 2.0
        borderLayer?.cornerRadius = layer.cornerRadius
        
        if let border = borderLayer {
            layer.addSublayer(border)
        }
        
        setTitleColor(UIDesignSystem.Colors.primary, for: .normal)
        setTitleColor(UIDesignSystem.Colors.textTertiary, for: .disabled)
    }
    
    private func setupGhostStyle() {
        backgroundColor = UIColor.clear
        setTitleColor(UIDesignSystem.Colors.textPrimary, for: .normal)
        setTitleColor(UIDesignSystem.Colors.textTertiary, for: .disabled)
    }
    
    private func setupNeonGlow() {
        let glowColor: UIColor
        switch buttonStyle {
        case .primary:
            glowColor = UIDesignSystem.Colors.primary
        case .secondary:
            glowColor = UIDesignSystem.Colors.neonBlue
        case .outline:
            glowColor = UIDesignSystem.Colors.borderActive
        case .ghost:
            glowColor = UIDesignSystem.Colors.neonPurple
        }
        
        applyShadow(ShadowStyle(
            color: glowColor.withAlphaComponent(0.4),
            offset: CGSize(width: 0, height: 0),
            radius: 8,
            opacity: 1.0
        ))
    }
    
    private func setupPulseAnimation() {
        removeAllAnimations()
        
        if enablePulseAnimation {
            addTechPulseAnimation()
        }
    }
    
    // MARK: - Frame Update Methods
    
    private func updateGradientFrame() {
        gradientLayer?.frame = bounds
    }
    
    private func updateBorderFrame() {
        guard let border = borderLayer else { return }
        border.frame = bounds
        border.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
    // MARK: - Loading State Methods
    
    private func updateLoadingState() {
        switch loadingState {
        case .normal:
            showNormalState()
        case .loading:
            showLoadingState()
        case .success:
            showSuccessState()
        case .error:
            showErrorState()
        }
    }
    
    private func showNormalState() {
        isEnabled = true
        loadingIndicator?.stopAnimating()
        
        if let original = originalTitle {
            setTitle(original, for: .normal)
        }
        
        UIView.animate(withDuration: UIDesignSystem.Animation.fastDuration) {
            self.alpha = 1.0
        }
    }
    
    private func showLoadingState() {
        originalTitle = title(for: .normal)
        setTitle("", for: .normal)
        isEnabled = false
        loadingIndicator?.startAnimating()
        
        UIView.animate(withDuration: UIDesignSystem.Animation.fastDuration) {
            self.alpha = 0.8
        }
    }
    
    private func showSuccessState() {
        isEnabled = false
        loadingIndicator?.stopAnimating()
        setTitle("✓", for: .normal)
        
        UIView.animate(withDuration: UIDesignSystem.Animation.fastDuration) {
            self.backgroundColor = UIDesignSystem.Colors.success
        }
        
        // 2秒后自动恢复正常状态
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.loadingState = .normal
        }
    }
    
    private func showErrorState() {
        isEnabled = false
        loadingIndicator?.stopAnimating()
        setTitle("✗", for: .normal)
        
        UIView.animate(withDuration: UIDesignSystem.Animation.fastDuration) {
            self.backgroundColor = UIDesignSystem.Colors.error
        }
        
        // 添加震动效果
        addShakeAnimation()
        
        // 2秒后自动恢复正常状态
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.loadingState = .normal
        }
    }
    
    // MARK: - Touch Effects
    
    @objc private func touchDown() {
        UIView.animate(
            withDuration: UIDesignSystem.Animation.defaultDuration, delay: 1,
            options: UIDesignSystem.Animation.defaultCurve
        ) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.8
        }
    }
    
    @objc private func touchUp() {
        UIView.animate(
            withDuration: UIDesignSystem.Animation.fastDuration, delay: 1,
            options: UIDesignSystem.Animation.defaultCurve
        ) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
    
    // MARK: - Animation Methods
    
    private func addShakeAnimation() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 3
        shake.autoreverses = true
        shake.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 5, y: center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: center.x + 5, y: center.y))
        layer.add(shake, forKey: "shake")
    }
    
    /// 添加成功动画
    func animateSuccess(completion: (() -> Void)? = nil) {
        loadingState = .success
        
        // 添加缩放动画
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.8,
            options: [],
            animations: {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
        ) { _ in
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            } completion: { _ in
                completion?()
            }
        }
    }
    
    /// 添加错误动画
    func animateError(completion: (() -> Void)? = nil) {
        loadingState = .error
        completion?()
    }
}

// MARK: - Public Methods

extension TechButton {
    
    /// 设置按钮配置
    /// - Parameters:
    ///   - title: 按钮标题
    ///   - style: 按钮样式
    ///   - size: 按钮尺寸
    func configure(title: String, style: Style = .primary, size: Size = .medium) {
        setTitle(title, for: .normal)
        self.buttonStyle = style
        self.buttonSize = size
        setupAppearance()
    }
    
    /// 设置加载状态
    /// - Parameter isLoading: 是否加载中
    func setLoading(_ isLoading: Bool) {
        loadingState = isLoading ? .loading : .normal
    }
    
    /// 启用/禁用霓虹光效
    /// - Parameter enabled: 是否启用
    func setNeonGlowEnabled(_ enabled: Bool) {
        enableNeonGlow = enabled
        setupAppearance()
    }
    
    /// 启用/禁用脉冲动画
    /// - Parameter enabled: 是否启用
    func setPulseAnimationEnabled(_ enabled: Bool) {
        enablePulseAnimation = enabled
        setupPulseAnimation()
    }
} 
