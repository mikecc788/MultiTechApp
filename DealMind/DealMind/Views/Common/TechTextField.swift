//
//  TechTextField.swift
//  DealMind
//
//  Created by app on 2025/7/8.
//

import UIKit
import SnapKit

/// 科技感输入框组件
/// 支持霓虹光效、验证状态、占位符动画、密码切换等
@IBDesignable
class TechTextField: UIView {
    
    // MARK: - Public Properties
    
    /// 输入框类型
    enum FieldType {
        case text       // 普通文本
        case email      // 邮箱
        case password   // 密码
        case phone      // 手机号
        case code       // 验证码
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .text, .password: return .default
            case .email: return .emailAddress
            case .phone: return .phonePad
            case .code: return .numberPad
            }
        }
        
        var contentType: UITextContentType? {
            switch self {
            case .text: return nil
            case .email: return .emailAddress
            case .password: return .password
            case .phone: return .telephoneNumber
            case .code: return .oneTimeCode
            }
        }
    }
    
    /// 验证状态
    enum ValidationState {
        case normal     // 正常状态
        case valid      // 验证通过
        case invalid    // 验证失败
        case focused    // 获得焦点
        
        var borderColor: UIColor {
            switch self {
            case .normal: return UIDesignSystem.Colors.borderPrimary
            case .valid: return UIDesignSystem.Colors.success
            case .invalid: return UIDesignSystem.Colors.error
            case .focused: return UIDesignSystem.Colors.borderActive
            }
        }
        
        var glowColor: UIColor {
            switch self {
            case .normal: return UIDesignSystem.Colors.borderPrimary
            case .valid: return UIDesignSystem.Colors.success
            case .invalid: return UIDesignSystem.Colors.error
            case .focused: return UIDesignSystem.Colors.neonBlue
            }
        }
    }
    
    // MARK: - Public Configuration
    
    var fieldType: FieldType = .text {
        didSet {
            setupFieldType()
        }
    }
    
    var validationState: ValidationState = .normal {
        didSet {
            updateValidationState()
        }
    }
    
    /// 输入框文本
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    /// 占位符文本
    @IBInspectable var placeholder: String = "" {
        didSet {
            updatePlaceholder()
        }
    }
    
    /// 是否启用霓虹光效
    @IBInspectable var enableNeonGlow: Bool = true {
        didSet {
            updateAppearance()
        }
    }
    
    /// 是否启用占位符动画
    @IBInspectable var enablePlaceholderAnimation: Bool = true {
        didSet {
            updatePlaceholder()
        }
    }
    
    /// 错误提示信息
    var errorMessage: String? {
        didSet {
            updateErrorMessage()
        }
    }
    
    // MARK: - Private Properties
    
    private let containerView = UIView()
    private let textField = UITextField()
    private let animatedPlaceholderLabel = UILabel()
    private let borderLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private let iconImageView = UIImageView()
    private let toggleButton = UIButton(type: .custom)
    private let errorLabel = UILabel()
    
    private var isPasswordVisible = false
    private var hasContent: Bool {
        !(textField.text?.isEmpty ?? true)
    }
    
    // MARK: - Callbacks
    
    var textChanged: ((String?) -> Void)?
    var editingBegan: (() -> Void)?
    var editingEnded: (() -> Void)?
    var shouldReturn: (() -> Bool)?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    convenience init(type: FieldType, placeholder: String) {
        self.init(frame: .zero)
        self.fieldType = type
        self.placeholder = placeholder
        setupFieldType()
        updatePlaceholder()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayers()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
        updateAppearance()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        setupHierarchy()
        setupConstraints()
        setupAppearance()
        setupActions()
        setupFieldType()
        updatePlaceholder()
    }
    
    private func setupHierarchy() {
        addSubview(containerView)
        addSubview(errorLabel)
        
        containerView.addSubview(textField)
        containerView.addSubview(animatedPlaceholderLabel)
        containerView.addSubview(iconImageView)
        containerView.addSubview(toggleButton)
    }
    
    private func setupConstraints() {
        // Container约束
        containerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
        
        // 图标约束
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(UIDesignSystem.Spacing.md)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        
        // 切换按钮约束
        toggleButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(UIDesignSystem.Spacing.md)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        // 输入框约束
        textField.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(UIDesignSystem.Spacing.sm)
            make.trailing.equalTo(toggleButton.snp.leading).offset(-UIDesignSystem.Spacing.sm)
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
        }
        
        // 动画占位符约束
        animatedPlaceholderLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(textField)
            make.centerY.equalTo(textField)
        }
        
        // 错误标签约束
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(UIDesignSystem.Spacing.xs)
            make.leading.trailing.equalToSuperview().inset(UIDesignSystem.Spacing.md)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupAppearance() {
        backgroundColor = UIColor.clear
        
        // Container样式
        containerView.layer.cornerRadius = UIDesignSystem.CornerRadius.medium
        containerView.layer.masksToBounds = false
        
        // 背景层
        backgroundLayer.fillColor = UIDesignSystem.Colors.backgroundCard.cgColor
        backgroundLayer.strokeColor = UIColor.clear.cgColor
        containerView.layer.insertSublayer(backgroundLayer, at: 0)
        
        // 边框层
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = validationState.borderColor.cgColor
        borderLayer.lineWidth = 1.0
        containerView.layer.addSublayer(borderLayer)
        
        // 输入框样式
        textField.backgroundColor = UIColor.clear
        textField.textColor = UIDesignSystem.Colors.textPrimary
        textField.font = UIDesignSystem.Typography.body
        textField.tintColor = UIDesignSystem.Colors.primary
        textField.borderStyle = .none
        
        // 动画占位符样式
        animatedPlaceholderLabel.textColor = UIDesignSystem.Colors.textTertiary
        animatedPlaceholderLabel.font = UIDesignSystem.Typography.body
        animatedPlaceholderLabel.backgroundColor = UIColor.clear
        
        // 图标样式
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIDesignSystem.Colors.textSecondary
        
        // 切换按钮样式
        toggleButton.tintColor = UIDesignSystem.Colors.textSecondary
        toggleButton.isHidden = true
        
        // 错误标签样式
        errorLabel.textColor = UIDesignSystem.Colors.error
        errorLabel.font = UIDesignSystem.Typography.caption1
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        
        updateAppearance()
    }
    
    private func setupActions() {
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        textField.delegate = self
        
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        // 添加点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerTapped))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    private func setupFieldType() {
        textField.keyboardType = fieldType.keyboardType
        textField.textContentType = fieldType.contentType
        
        switch fieldType {
        case .text:
            iconImageView.image = UIImage(systemName: "person")
            textField.isSecureTextEntry = false
            toggleButton.isHidden = true
            
        case .email:
            iconImageView.image = UIImage(systemName: "envelope")
            textField.isSecureTextEntry = false
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            toggleButton.isHidden = true
            
        case .password:
            iconImageView.image = UIImage(systemName: "lock")
            textField.isSecureTextEntry = true
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            toggleButton.isHidden = false
            updatePasswordToggleButton()
            
        case .phone:
            iconImageView.image = UIImage(systemName: "phone")
            textField.isSecureTextEntry = false
            toggleButton.isHidden = true
            
        case .code:
            iconImageView.image = UIImage(systemName: "number")
            textField.isSecureTextEntry = false
            toggleButton.isHidden = true
        }
    }
    
    // MARK: - Update Methods
    
    private func updateAppearance() {
        if enableNeonGlow {
            containerView.applyShadow(ShadowStyle(
                color: validationState.glowColor.withAlphaComponent(0.3),
                offset: CGSize(width: 0, height: 0),
                radius: 8,
                opacity: 1.0
            ))
        } else {
            containerView.layer.shadowOpacity = 0
        }
    }
    
    private func updateLayers() {
        let bounds = containerView.bounds
        let cornerRadius = containerView.layer.cornerRadius
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        backgroundLayer.frame = bounds
        backgroundLayer.path = path.cgPath
        
        borderLayer.frame = bounds
        borderLayer.path = path.cgPath
    }
    
    private func updateValidationState() {
        borderLayer.strokeColor = validationState.borderColor.cgColor
        
        // 动画更新边框颜色
        CATransaction.begin()
        CATransaction.setAnimationDuration(UIDesignSystem.Animation.fastDuration)
        borderLayer.strokeColor = validationState.borderColor.cgColor
        CATransaction.commit()
        
        updateAppearance()
    }
    
    private func updatePlaceholder() {
        animatedPlaceholderLabel.text = placeholder
        
        if enablePlaceholderAnimation {
            animatePlaceholder()
        } else {
            textField.placeholder = placeholder
            animatedPlaceholderLabel.isHidden = true
        }
    }
    
    private func updateErrorMessage() {
        if let error = errorMessage, !error.isEmpty {
            errorLabel.text = error
            errorLabel.isHidden = false
            validationState = .invalid
        } else {
            errorLabel.isHidden = true
            if validationState == .invalid {
                validationState = .normal
            }
        }
    }
    
    private func updatePasswordToggleButton() {
        let imageName = isPasswordVisible ? "eye.slash" : "eye"
        toggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    // MARK: - Animation Methods
    
    private func animatePlaceholder() {
        let shouldMoveUp = hasContent || textField.isFirstResponder
        
        UIView.animate(
            withDuration: UIDesignSystem.Animation.fastDuration,
            delay: 0,
            options: [.curveEaseInOut, .beginFromCurrentState],
            animations: {
                if shouldMoveUp {
                    // 移动到上方
                    self.animatedPlaceholderLabel.transform = CGAffineTransform(translationX: 0, y: -20)
                    self.animatedPlaceholderLabel.font = UIDesignSystem.Typography.caption1
                    self.animatedPlaceholderLabel.textColor = self.validationState.borderColor
                } else {
                    // 恢复到中央
                    self.animatedPlaceholderLabel.transform = .identity
                    self.animatedPlaceholderLabel.font = UIDesignSystem.Typography.body
                    self.animatedPlaceholderLabel.textColor = UIDesignSystem.Colors.textTertiary
                }
            }
        )
    }
    
    // MARK: - Action Methods
    
    @objc private func textFieldDidChange() {
        textChanged?(textField.text)
        
        if enablePlaceholderAnimation {
            animatePlaceholder()
        }
        
        // 清除错误状态
        if validationState == .invalid {
            errorMessage = nil
        }
    }
    
    @objc private func textFieldDidBeginEditing() {
        validationState = .focused
        editingBegan?()
        
        if enablePlaceholderAnimation {
            animatePlaceholder()
        }
    }
    
    @objc private func textFieldDidEndEditing() {
        validationState = hasContent ? .valid : .normal
        editingEnded?()
        
        if enablePlaceholderAnimation {
            animatePlaceholder()
        }
    }
    
    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        textField.isSecureTextEntry = !isPasswordVisible
        updatePasswordToggleButton()
        
        // 保持光标位置
        if let existingText = textField.text, textField.isFirstResponder {
            textField.deleteBackward()
            textField.insertText(existingText)
        }
    }
    
    @objc private func containerTapped() {
        textField.becomeFirstResponder()
    }
}

// MARK: - UITextFieldDelegate

extension TechTextField: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return shouldReturn?() ?? true
    }
}

// MARK: - Public Methods

extension TechTextField {
    
    /// 设置输入框配置
    /// - Parameters:
    ///   - type: 输入框类型
    ///   - placeholder: 占位符文本
    ///   - enableNeon: 是否启用霓虹光效
    func configure(type: FieldType, placeholder: String, enableNeon: Bool = true) {
        self.fieldType = type
        self.placeholder = placeholder
        self.enableNeonGlow = enableNeon
        setupFieldType()
        updatePlaceholder()
        updateAppearance()
    }
    
    /// 设置验证状态
    /// - Parameter state: 验证状态
    func setValidationState(_ state: ValidationState) {
        validationState = state
    }
    
    /// 显示错误信息
    /// - Parameter message: 错误信息
    func showError(_ message: String) {
        errorMessage = message
    }
    
    /// 清除错误信息
    func clearError() {
        errorMessage = nil
    }
    
    /// 开始编辑
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    /// 结束编辑
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
} 
