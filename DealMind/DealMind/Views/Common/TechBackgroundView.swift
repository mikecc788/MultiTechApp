//
//  TechBackgroundView.swift
//  DealMind
//
//  Created by app on 2025/7/8.
//

import UIKit

/// 科技感背景视图
/// 支持动态粒子效果、网格线、渐变背景等
@IBDesignable
class TechBackgroundView: UIView {
    
    // MARK: - Public Properties
    
    /// 背景效果类型
    enum EffectType {
        case gradient      // 渐变背景
        case particles     // 粒子效果
        case grid          // 网格线效果
        case wave          // 波浪效果
        case combination   // 组合效果
    }
    
    // MARK: - Configuration
    
    var effectType: EffectType = .combination {
        didSet {
            setupEffect()
        }
    }
    
    /// 是否启用动画
    @IBInspectable var enableAnimation: Bool = true {
        didSet {
            if enableAnimation {
                startAnimations()
            } else {
                stopAnimations()
            }
        }
    }
    
    /// 粒子数量
    @IBInspectable var particleCount: Int = 50 {
        didSet {
            setupParticles()
        }
    }
    
    /// 网格线密度
    @IBInspectable var gridDensity: CGFloat = 50 {
        didSet {
            setupGrid()
        }
    }
    
    // MARK: - Private Properties
    
    private let gradientLayer = CAGradientLayer()
    private let particleLayer = CAEmitterLayer()
    private let gridLayer = CAShapeLayer()
    private let waveLayer = CAShapeLayer()
    
    private var animationTimer: Timer?
    private var waveOffset: CGFloat = 0
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayers()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    deinit {
        stopAnimations()
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        backgroundColor = UIDesignSystem.Colors.backgroundPrimary
        setupLayers()
        setupEffect()
        
        if enableAnimation {
            startAnimations()
        }
    }
    
    private func setupLayers() {
        // 渐变层
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
        
        // 网格层
        gridLayer.frame = bounds
        gridLayer.fillColor = UIColor.clear.cgColor
        gridLayer.strokeColor = UIDesignSystem.Colors.borderSecondary.withAlphaComponent(0.3).cgColor
        gridLayer.lineWidth = 0.5
        layer.addSublayer(gridLayer)
        
        // 波浪层
        waveLayer.frame = bounds
        waveLayer.fillColor = UIColor.clear.cgColor
        waveLayer.strokeColor = UIDesignSystem.Colors.neonBlue.withAlphaComponent(0.2).cgColor
        waveLayer.lineWidth = 1.0
        layer.addSublayer(waveLayer)
        
        // 粒子层
        particleLayer.frame = bounds
        layer.addSublayer(particleLayer)
    }
    
    private func setupEffect() {
        switch effectType {
        case .gradient:
            setupGradient()
            hideOtherEffects()
            
        case .particles:
            setupParticles()
            hideOtherEffects(except: .particles)
            
        case .grid:
            setupGrid()
            hideOtherEffects(except: .grid)
            
        case .wave:
            setupWave()
            hideOtherEffects(except: .wave)
            
        case .combination:
            setupGradient()
            setupParticles()
            setupGrid()
            setupWave()
        }
    }
    
    private func hideOtherEffects(except: EffectType? = nil) {
        gradientLayer.isHidden = except != .gradient && except != nil
        particleLayer.isHidden = except != .particles && except != nil
        gridLayer.isHidden = except != .grid && except != nil
        waveLayer.isHidden = except != .wave && except != nil
    }
    
    // MARK: - Effect Setup Methods
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIDesignSystem.Colors.techGradientStart.cgColor,
            UIDesignSystem.Colors.techGradientEnd.cgColor,
            UIDesignSystem.Colors.backgroundPrimary.cgColor
        ]
        gradientLayer.locations = [0.0, 0.6, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.isHidden = false
    }
    
    private func setupParticles() {
        particleLayer.isHidden = false
        
        // 粒子单元配置
        let cell = CAEmitterCell()
        cell.birthRate = Float(particleCount) / 10.0
        cell.lifetime = 10.0
        cell.velocity = 20
        cell.velocityRange = 10
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 4
        cell.spinRange = CGFloat.pi
        cell.scale = 0.1
        cell.scaleRange = 0.05
        cell.alphaSpeed = -0.1
        cell.alphaRange = 0.3
        
        // 粒子颜色
        cell.color = UIDesignSystem.Colors.neonBlue.cgColor
        cell.redRange = 0.2
        cell.greenRange = 0.2
        cell.blueRange = 0.2
        
        // 粒子图像 (使用圆形)
        let size = CGSize(width: 4, height: 4)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIDesignSystem.Colors.neonBlue.setFill()
        UIBezierPath(ovalIn: CGRect(origin: .zero, size: size)).fill()
        cell.contents = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        UIGraphicsEndImageContext()
        
        particleLayer.emitterCells = [cell]
        particleLayer.emitterPosition = CGPoint(x: bounds.width / 2, y: 0)
        particleLayer.emitterSize = CGSize(width: bounds.width, height: 1)
        particleLayer.emitterShape = .line
    }
    
    private func setupGrid() {
        gridLayer.isHidden = false
        
        let path = UIBezierPath()
        let spacing = gridDensity
        
        // 垂直线
        var x: CGFloat = 0
        while x <= bounds.width {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: bounds.height))
            x += spacing
        }
        
        // 水平线
        var y: CGFloat = 0
        while y <= bounds.height {
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: bounds.width, y: y))
            y += spacing
        }
        
        gridLayer.path = path.cgPath
    }
    
    private func setupWave() {
        waveLayer.isHidden = false
        updateWave()
    }
    
    private func updateWave() {
        let path = UIBezierPath()
        let amplitude: CGFloat = 20
        let frequency: CGFloat = 0.02
        let phaseShift = waveOffset
        
        // 创建波浪路径
        for i in 0...3 {
            let yOffset = bounds.height * 0.3 + CGFloat(i) * 80
            let wave1 = createWavePath(
                width: bounds.width,
                height: amplitude,
                frequency: frequency,
                phase: phaseShift + CGFloat(i) * CGFloat.pi / 4,
                yOffset: yOffset
            )
            path.append(wave1)
            
            let wave2 = createWavePath(
                width: bounds.width,
                height: amplitude * 0.7,
                frequency: frequency * 1.5,
                phase: -phaseShift + CGFloat(i) * CGFloat.pi / 6,
                yOffset: yOffset + 40
            )
            path.append(wave2)
        }
        
        waveLayer.path = path.cgPath
    }
    
    private func createWavePath(width: CGFloat, height: CGFloat, frequency: CGFloat, phase: CGFloat, yOffset: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        
        for x in stride(from: 0, to: width, by: 2) {
            let y = yOffset + height * sin(frequency * x + phase)
            
            if x == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
    
    // MARK: - Animation Methods
    
    private func startAnimations() {
        stopAnimations()
        
        if effectType == .wave || effectType == .combination {
            startWaveAnimation()
        }
        
        if effectType == .particles || effectType == .combination {
            startParticleAnimation()
        }
        
        if effectType == .gradient || effectType == .combination {
            startGradientAnimation()
        }
    }
    
    private func stopAnimations() {
        animationTimer?.invalidate()
        animationTimer = nil
        
        layer.sublayers?.forEach { $0.removeAllAnimations() }
    }
    
    private func startWaveAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.waveOffset += 0.1
            self.updateWave()
        }
    }
    
    private func startParticleAnimation() {
        // 粒子发射位置动画
        let animation = CABasicAnimation(keyPath: "emitterPosition")
        animation.fromValue = NSValue(cgPoint: CGPoint(x: 0, y: 0))
        animation.toValue = NSValue(cgPoint: CGPoint(x: bounds.width, y: 0))
        animation.duration = 15.0
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        particleLayer.add(animation, forKey: "particlePosition")
    }
    
    private func startGradientAnimation() {
        // 渐变动画
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = gradientLayer.colors
        animation.toValue = [
            UIDesignSystem.Colors.backgroundPrimary.cgColor,
            UIDesignSystem.Colors.techGradientEnd.cgColor,
            UIDesignSystem.Colors.techGradientStart.cgColor
        ]
        animation.duration = 8.0
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        gradientLayer.add(animation, forKey: "gradientColors")
    }
    
    // MARK: - Update Methods
    
    private func updateLayers() {
        gradientLayer.frame = bounds
        particleLayer.frame = bounds
        gridLayer.frame = bounds
        waveLayer.frame = bounds
        
        particleLayer.emitterPosition = CGPoint(x: bounds.width / 2, y: 0)
        particleLayer.emitterSize = CGSize(width: bounds.width, height: 1)
        
        setupGrid()
        updateWave()
    }
}

// MARK: - Public Methods

extension TechBackgroundView {
    
    /// 设置背景效果
    /// - Parameter type: 效果类型
    func setEffect(_ type: EffectType) {
        effectType = type
    }
    
    /// 开始动画
    func startEffect() {
        enableAnimation = true
    }
    
    /// 停止动画
    func stopEffect() {
        enableAnimation = false
    }
    
    /// 添加脉冲效果
    func addPulseEffect() {
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.fromValue = 0.3
        pulseAnimation.toValue = 1.0
        pulseAnimation.duration = 2.0
        pulseAnimation.repeatCount = .infinity
        pulseAnimation.autoreverses = true
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        layer.add(pulseAnimation, forKey: "backgroundPulse")
    }
    
    /// 移除脉冲效果
    func removePulseEffect() {
        layer.removeAnimation(forKey: "backgroundPulse")
    }
} 