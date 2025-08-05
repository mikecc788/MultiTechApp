//
//  ViewController.swift
//  AudioTest
//
//  Created by app on 2025/6/17.
//

import UIKit
import AVFoundation
import SnapKit

class ViewController: UIViewController {
    // MARK: - 音频相关属性
    private let sampleRate: Double = 44100.0 // 采样率 44.1kHz
    private let pulseDuration: Double = 0.02 // 脉冲音时长 20ms
    private let recordDuration: Double = 2.0 // 录音时长 2秒
    private var audioEngine: AVAudioEngine?
    private var audioFile: AVAudioFile?
    private var recordedBuffer: AVAudioPCMBuffer?
    private var isTesting = false
    
    // MARK: - UI 组件
    private let delayLabel: UILabel = {
        let label = UILabel()
        label.text = "请点击下方按钮开始测试"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let testButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("开始测试", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.addTarget(nil, action: #selector(startTest), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupAudioSession()
    }
    
    private func setupUI() {
        view.addSubview(delayLabel)
        view.addSubview(testButton)
        delayLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        testButton.snp.makeConstraints { make in
            make.top.equalTo(delayLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(50)
        }
    }
    
    /// 配置音频会话
    private func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true)
            // 请求麦克风权限
            session.requestRecordPermission { [weak self] allowed in
                DispatchQueue.main.async {
                    if !allowed {
                        self?.delayLabel.text = "请在设置中允许使用麦克风"
                        self?.testButton.isEnabled = false
                    }
                }
            }
        } catch {
            print("音频会话设置失败: \(error)")
            delayLabel.text = "音频初始化失败"
            testButton.isEnabled = false
        }
    }
    
    @objc private func startTest() {
        guard !isTesting else { return }
        isTesting = true
        delayLabel.text = "正在测试，请稍候..."
        startAudioTest()
    }
    
    /// 启动音频测试流程
    private func startAudioTest() {
        // 1. 初始化 AVAudioEngine
        let engine = AVAudioEngine()
        let input = engine.inputNode
        let mainMixer = engine.mainMixerNode
        
        // 设置音频格式
        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1) else {
            delayLabel.text = "音频格式初始化失败"
            isTesting = false
            return
        }
        
        // 2. 生成脉冲音 buffer
        let pulseBuffer = generatePulseBuffer(format: format)
        
        // 3. 录音缓冲区
        let frameCapacity = AVAudioFrameCount(recordDuration * sampleRate)
        guard let recordBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCapacity) else {
            delayLabel.text = "录音缓冲区初始化失败"
            isTesting = false
            return
        }
        recordBuffer.frameLength = frameCapacity
        var currentFrame: AVAudioFrameCount = 0
        
        // 4. 配置音频引擎连接
        engine.connect(mainMixer, to: engine.outputNode, format: nil)
        
        // 5. 安装 tap 录音
        input.removeTap(onBus: 0)
        input.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            guard let self = self else { return }
            let copyCount = min(buffer.frameLength, frameCapacity - currentFrame)
            if copyCount > 0 {
                let src = buffer.floatChannelData![0]
                let dst = recordBuffer.floatChannelData![0] + Int(currentFrame)
                dst.assign(from: src, count: Int(copyCount))
                currentFrame += copyCount
            }
            if currentFrame >= frameCapacity {
                // 录音结束
                self.audioEngine?.inputNode.removeTap(onBus: 0)
                engine.stop()
                DispatchQueue.main.async {
                    self.isTesting = false
                    self.recordedBuffer = recordBuffer
                    self.analyzeDelay(pulseBuffer: pulseBuffer, recordBuffer: recordBuffer)
                }
            }
        }
        
        // 6. 启动引擎
        do {
            try engine.start()
            self.audioEngine = engine
            
            // 7. 播放脉冲音
            let player = AVAudioPlayerNode()
            engine.attach(player)
            engine.connect(player, to: mainMixer, format: format)
            player.scheduleBuffer(pulseBuffer, at: nil, options: [])
            player.play()
        } catch {
            print("音频引擎启动失败: \(error)")
            delayLabel.text = "音频引擎启动失败"
            isTesting = false
            return
        }
    }
    
    /// 生成一个短促的脉冲音（点击声）
    private func generatePulseBuffer(format: AVAudioFormat) -> AVAudioPCMBuffer {
        let frameCount = AVAudioFrameCount(pulseDuration * sampleRate)
        let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)!
        buffer.frameLength = frameCount
        let channel = buffer.floatChannelData![0]
        // 生成一个短正弦波脉冲
        let freq: Float = 2000 // 2kHz
        for i in 0..<Int(frameCount) {
            let t = Float(i) / Float(sampleRate)
            // 衰减包络，避免爆音
            let envelope = exp(-8 * t)
            channel[i] = sin(2 * .pi * freq * t) * envelope * 0.8
        }
        return buffer
    }
    
    /// 分析录音，计算延迟
    private func analyzeDelay(pulseBuffer: AVAudioPCMBuffer, recordBuffer: AVAudioPCMBuffer) {
        delayLabel.text = "正在分析录音..."
        
        // 1. 获取音频数据
        guard let pulseData = pulseBuffer.floatChannelData?[0],
              let recordData = recordBuffer.floatChannelData?[0] else {
            delayLabel.text = "音频数据获取失败"
            return
        }
        
        let pulseLength = Int(pulseBuffer.frameLength)
        let recordLength = Int(recordBuffer.frameLength)
        
        // 2. 执行交叉相关分析
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            // 计算相关性数组
            var correlations = [Float](repeating: 0, count: recordLength - pulseLength)
            
            // 对每个可能的偏移位置计算相关性
            for offset in 0..<correlations.count {
                var correlation: Float = 0
                
                // 计算当前偏移位置的相关性得分
                for i in 0..<pulseLength {
                    correlation += pulseData[i] * recordData[offset + i]
                }
                
                // 归一化相关性得分
                correlation = correlation / Float(pulseLength)
                correlations[offset] = correlation
            }
            
            // 3. 查找最大相关性位置
            var maxCorrelation: Float = 0
            var maxOffset = 0
            
            for (offset, correlation) in correlations.enumerated() {
                if correlation > maxCorrelation {
                    maxCorrelation = correlation
                    maxOffset = offset
                }
            }
            
            // 4. 计算延迟时间（毫秒）
            let delayInSamples = maxOffset
            let delayInSeconds = Double(delayInSamples) / self!.sampleRate ?? 44100.0
            let delayInMilliseconds = delayInSeconds * 1000.0
            
            // 5. 在主线程更新UI
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                // 检查相关性得分是否足够高（避免错误匹配）
                if maxCorrelation > 0.1 { // 相关性阈值，可根据实际测试调整
                    let formattedDelay = String(format: "%.1f", delayInMilliseconds)
                    self.delayLabel.text = "耳机延迟：\(formattedDelay) 毫秒\n"
                    
                    // 添加延迟等级评估
                    let delayLevel = self.evaluateDelayLevel(delayInMilliseconds)
                    self.delayLabel.text?.append(delayLevel)
                } else {
                    self.delayLabel.text = "未能检测到明显的回声，请确保:\n1. 耳机已正确连接\n2. 音量适中\n3. 环境安静"
                }
            }
        }
    }
    
    /// 评估延迟等级
    private func evaluateDelayLevel(_ delay: Double) -> String {
        switch delay {
        case ..<50:
            return "延迟等级：极佳 ⭐️⭐️⭐️⭐️⭐️"
        case 50..<100:
            return "延迟等级：良好 ⭐️⭐️⭐️⭐️"
        case 100..<150:
            return "延迟等级：一般 ⭐️⭐️⭐️"
        case 150..<200:
            return "延迟等级：较差 ⭐️⭐️"
        default:
            return "延迟等级：很差 ⭐️"
        }
    }
}

