//
//  UIDesignSystem.swift
//  DealMind
//
//  Created by app on 2025/7/8.
//

import UIKit

/// UI设计系统 - 定义应用的视觉规范
struct UIDesignSystem {
    
    // MARK: - Colors 颜色系统
    
    struct Colors {
        /// 主题色彩
        static let primary = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)           // #007AFF
        static let primaryDark = UIColor(red: 0.0, green: 0.35, blue: 0.8, alpha: 1.0)      // #0056CC
        static let secondary = UIColor(red: 0.5, green: 0.0, blue: 1.0, alpha: 1.0)         // #8000FF
        static let accent = UIColor(red: 0.0, green: 0.8, blue: 0.6, alpha: 1.0)            // #00CC99
        
        /// 科技感渐变色
        static let techGradientStart = UIColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1.0)  // #0D0D26
        static let techGradientEnd = UIColor(red: 0.1, green: 0.1, blue: 0.25, alpha: 1.0)      // #1A1A40
        
        /// 霓虹光效色彩
        static let neonBlue = UIColor(red: 0.0, green: 0.7, blue: 1.0, alpha: 1.0)          // #00B3FF
        static let neonPurple = UIColor(red: 0.6, green: 0.2, blue: 1.0, alpha: 1.0)       // #9933FF
        static let neonGreen = UIColor(red: 0.0, green: 1.0, blue: 0.5, alpha: 1.0)        // #00FF80
        
        /// 背景色彩
        static let backgroundPrimary = UIColor(red: 0.03, green: 0.03, blue: 0.08, alpha: 1.0)  // #080814
        static let backgroundSecondary = UIColor(red: 0.08, green: 0.08, blue: 0.16, alpha: 1.0) // #141428
        static let backgroundCard = UIColor(red: 0.12, green: 0.12, blue: 0.22, alpha: 1.0)     // #1F1F38
        
        /// 文本色彩
        static let textPrimary = UIColor.white
        static let textSecondary = UIColor(red: 0.7, green: 0.7, blue: 0.8, alpha: 1.0)     // #B3B3CC
        static let textTertiary = UIColor(red: 0.5, green: 0.5, blue: 0.6, alpha: 1.0)      // #808099
        
        /// 状态色彩
        static let success = UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 1.0)           // #00CC66
        static let warning = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)           // #FF9900
        static let error = UIColor(red: 1.0, green: 0.2, blue: 0.3, alpha: 1.0)             // #FF3350
        
        /// 边框色彩
        static let borderPrimary = UIColor(red: 0.2, green: 0.2, blue: 0.3, alpha: 1.0)     // #33334D
        static let borderSecondary = UIColor(red: 0.15, green: 0.15, blue: 0.25, alpha: 1.0) // #262640
        static let borderActive = neonBlue
    }
    
    // MARK: - Typography 字体系统
    
    struct Typography {
        /// 标题字体
        static let largeTitle = UIFont.systemFont(ofSize: 34, weight: .bold)
        static let title1 = UIFont.systemFont(ofSize: 28, weight: .bold)
        static let title2 = UIFont.systemFont(ofSize: 22, weight: .semibold)
        static let title3 = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        /// 正文字体
        static let headline = UIFont.systemFont(ofSize: 17, weight: .semibold)
        static let body = UIFont.systemFont(ofSize: 17, weight: .regular)
        static let bodyEmphasized = UIFont.systemFont(ofSize: 17, weight: .medium)
        static let callout = UIFont.systemFont(ofSize: 16, weight: .regular)
        static let subheadline = UIFont.systemFont(ofSize: 15, weight: .regular)
        static let footnote = UIFont.systemFont(ofSize: 13, weight: .regular)
        static let caption1 = UIFont.systemFont(ofSize: 12, weight: .regular)
        static let caption2 = UIFont.systemFont(ofSize: 11, weight: .regular)
        
        /// 科技感字体
        static let techTitle = UIFont.monospacedSystemFont(ofSize: 24, weight: .bold)
        static let techBody = UIFont.monospacedSystemFont(ofSize: 16, weight: .medium)
        static let techCaption = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
    }
    
    // MARK: - Spacing 间距系统
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let xxxl: CGFloat = 64
    }
    
    // MARK: - Corner Radius 圆角半径
    
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
        static let pill: CGFloat = 1000 // 胶囊形状
    }
    
    // MARK: - Shadows 阴影效果
    
    struct Shadows {
        static let small = ShadowStyle(
            color: UIColor.black.withAlphaComponent(0.1),
            offset: CGSize(width: 0, height: 2),
            radius: 4,
            opacity: 1.0
        )
        
        static let medium = ShadowStyle(
            color: UIColor.black.withAlphaComponent(0.15),
            offset: CGSize(width: 0, height: 4),
            radius: 8,
            opacity: 1.0
        )
        
        static let large = ShadowStyle(
            color: UIColor.black.withAlphaComponent(0.2),
            offset: CGSize(width: 0, height: 8),
            radius: 16,
            opacity: 1.0
        )
        
        /// 科技感霓虹阴影
        static let neonGlow = ShadowStyle(
            color: Colors.neonBlue.withAlphaComponent(0.5),
            offset: CGSize(width: 0, height: 0),
            radius: 12,
            opacity: 1.0
        )
        
        static let neonGlowPurple = ShadowStyle(
            color: Colors.neonPurple.withAlphaComponent(0.5),
            offset: CGSize(width: 0, height: 0),
            radius: 12,
            opacity: 1.0
        )
    }
    
    // MARK: - Animation 动画配置
    
    struct Animation {
        static let defaultDuration: TimeInterval = 0.3
        static let fastDuration: TimeInterval = 0.2
        static let slowDuration: TimeInterval = 0.5
        
        static let defaultCurve: UIView.AnimationOptions = .curveEaseInOut
        static let springCurve: UIView.AnimationOptions = .curveEaseOut
        
        /// 科技感动画时长
        static let techGlowDuration: TimeInterval = 2.0
        static let techPulseDuration: TimeInterval = 1.5
    }
}

// MARK: - ShadowStyle 阴影样式

struct ShadowStyle {
    let color: UIColor
    let offset: CGSize
    let radius: CGFloat
    let opacity: Float
}

// MARK: - UIView Extension 视图扩展

extension UIView {
    
    /// 应用阴影样式
    func applyShadow(_ style: ShadowStyle) {
        layer.shadowColor = style.color.cgColor
        layer.shadowOffset = style.offset
        layer.shadowRadius = style.radius
        layer.shadowOpacity = style.opacity
        layer.masksToBounds = false
    }
    
    /// 应用科技感渐变背景
    func applyTechGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIDesignSystem.Colors.techGradientStart.cgColor,
            UIDesignSystem.Colors.techGradientEnd.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = bounds
        
        // 移除旧的渐变层
        layer.sublayers?.removeAll { $0 is CAGradientLayer }
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /// 添加霓虹光效动画
    func addNeonGlowAnimation(color: UIColor = UIDesignSystem.Colors.neonBlue) {
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = 0.3
        animation.toValue = 1.0
        animation.duration = UIDesignSystem.Animation.techGlowDuration
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 12
        layer.add(animation, forKey: "neonGlow")
    }
    
    /// 添加科技感脉冲动画
    func addTechPulseAnimation() {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 1.05
        scaleAnimation.duration = UIDesignSystem.Animation.techPulseDuration
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = .infinity
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        layer.add(scaleAnimation, forKey: "techPulse")
    }
    
    /// 移除所有动画
    func removeAllAnimations() {
        layer.removeAllAnimations()
    }
} 