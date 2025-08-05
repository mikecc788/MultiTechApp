//
//  SnapKitExtensions.swift
//  DealMind
//
//  Created by app on 2025/7/8.
//

import UIKit


// MARK: - SnapKit相关扩展和便捷方法

extension UIView {
    
    /// 快速设置中心约束
    /// - Parameter view: 目标视图
    func centerIn(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    /// 快速设置填充约束
    /// - Parameters:
    ///   - view: 目标视图
    ///   - insets: 边距
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        guard let superview = superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: padding.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding.right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding.bottom)
        ])
    }
    
    /// 快速设置尺寸约束
    /// - Parameter size: 尺寸
    func size(_ size: CGSize) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
        ])
    }
    
    /// 快速设置高度约束
    /// - Parameter height: 高度
    func height(_ height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    /// 快速设置宽度约束
    /// - Parameter width: 宽度
    func width(_ width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    /// 快速设置顶部约束
    /// - Parameters:
    ///   - anchor: 目标锚点
    ///   - constant: 常量
    @discardableResult
    func top(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    /// 快速设置底部约束
    /// - Parameters:
    ///   - anchor: 目标锚点
    ///   - constant: 常量
    @discardableResult
    func bottom(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = bottomAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    /// 快速设置左侧约束
    /// - Parameters:
    ///   - anchor: 目标锚点
    ///   - constant: 常量
    @discardableResult
    func leading(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = leadingAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    /// 快速设置右侧约束
    /// - Parameters:
    ///   - anchor: 目标锚点
    ///   - constant: 常量
    @discardableResult
    func trailing(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = trailingAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    /// 快速设置中心X约束
    /// - Parameters:
    ///   - anchor: 目标锚点
    ///   - constant: 常量
    @discardableResult
    func centerX(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerXAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
    
    /// 快速设置中心Y约束
    /// - Parameters:
    ///   - anchor: 目标锚点
    ///   - constant: 常量
    @discardableResult
    func centerY(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerYAnchor.constraint(equalTo: anchor, constant: constant)
        constraint.isActive = true
        return constraint
    }
}

// MARK: - 安全区域扩展

extension UIView {
    
    /// 获取安全区域
    var safeArea: UILayoutGuide {
        return safeAreaLayoutGuide
    }
    
    /// 快速填充安全区域
    /// - Parameter padding: 边距
    func fillSafeArea(padding: UIEdgeInsets = .zero) {
        guard let superview = superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: padding.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding.right),
            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -padding.bottom)
        ])
    }
}

// MARK: - 便捷方法

extension UIEdgeInsets {
    
    /// 创建统一的边距
    /// - Parameter inset: 边距值
    init(all inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    /// 创建水平和垂直边距
    /// - Parameters:
    ///   - horizontal: 水平边距
    ///   - vertical: 垂直边距
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}

// MARK: - 动画扩展

extension UIView {
    
    /// 淡入动画
    /// - Parameters:
    ///   - duration: 动画时长
    ///   - completion: 完成回调
    func fadeIn(duration: TimeInterval = UIDesignSystem.Animation.defaultDuration, completion: (() -> Void)? = nil) {
        alpha = 0
        UIView.animate(withDuration: duration) {
            self.alpha = 1
        } completion: { _ in
            completion?()
        }
    }
    
    /// 淡出动画
    /// - Parameters:
    ///   - duration: 动画时长
    ///   - completion: 完成回调
    func fadeOut(duration: TimeInterval = UIDesignSystem.Animation.defaultDuration, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration) {
            self.alpha = 0
        } completion: { _ in
            completion?()
        }
    }
    
    /// 缩放动画
    /// - Parameters:
    ///   - scale: 缩放比例
    ///   - duration: 动画时长
    ///   - completion: 完成回调
    func scale(to scale: CGFloat, duration: TimeInterval = UIDesignSystem.Animation.defaultDuration, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: []) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        } completion: { _ in
            completion?()
        }
    }
    
    /// 滑入动画
    /// - Parameters:
    ///   - direction: 滑入方向
    ///   - distance: 滑入距离
    ///   - duration: 动画时长
    ///   - completion: 完成回调
    func slideIn(from direction: SlideDirection, distance: CGFloat = 50, duration: TimeInterval = UIDesignSystem.Animation.defaultDuration, completion: (() -> Void)? = nil) {
        let originalTransform = transform
        
        switch direction {
        case .left:
            transform = CGAffineTransform(translationX: -distance, y: 0)
        case .right:
            transform = CGAffineTransform(translationX: distance, y: 0)
        case .top:
            transform = CGAffineTransform(translationX: 0, y: -distance)
        case .bottom:
            transform = CGAffineTransform(translationX: 0, y: distance)
        }
        
        alpha = 0
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: []) {
            self.transform = originalTransform
            self.alpha = 1
        } completion: { _ in
            completion?()
        }
    }
}

// MARK: - 滑动方向枚举

enum SlideDirection {
    case left, right, top, bottom
} 
