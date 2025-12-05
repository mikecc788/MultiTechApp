//
//  ViewController.swift
//  BleToolsDemo
//
//  Created by app on 2025/10/20.
//

import UIKit
import BleToolsKit
import SnapKit
final class ViewController: UIViewController {

    // MARK: - UI
    private let scanBtn: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("开始扫描并连接", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        return b
    }()
    private let disconnectBtn: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("断开", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        return b
    }()
    private let logView: UITextView = {
        let t = UITextView()
        t.isEditable = false
        t.font = .monospacedSystemFont(ofSize: 13, weight: .regular)
        return t
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layoutUI()
        scanBtn.addTarget(self, action: #selector(onScan), for: .touchUpInside)
        disconnectBtn.addTarget(self, action: #selector(onDisconnect), for: .touchUpInside)
        append("App Ready.")
        // BLE SDK 回调配置
        BleAPI.shared.timeout = 10
        BleAPI.shared.onDeviceFound = { [weak self] deviceId, deviceName, rssi in
            self?.append("📱 发现设备: \(deviceName)  RSSI:\(rssi) id:\(deviceId)")
            if deviceName.contains("Air Smart Extra") {
                self?.append("🔗 自动连接目标设备: \(deviceName)")
                BleAPI.shared.stopScan()
                BleAPI.shared.connect(deviceId: deviceId)
            }
        }
        BleAPI.shared.onConnected = { [weak self] in
            self?.append("✅ 设备已连接")
        }
        BleAPI.shared.onDataReceived = { [weak self] hex in
            self?.append("📨 收到数据: \(hex)")
        }
        BleAPI.shared.onError = { [weak self] msg in
            self?.append("❌ 错误: \(msg)")
        }
    }

    private func layoutUI() {
        view.addSubview(scanBtn)
        view.addSubview(disconnectBtn)
        view.addSubview(logView)

        scanBtn.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

        disconnectBtn.snp.makeConstraints { make in
            make.top.equalTo(scanBtn.snp.bottom).offset(12)
            make.left.right.height.equalTo(scanBtn)
        }

        logView.snp.makeConstraints { make in
            make.top.equalTo(disconnectBtn.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }

    // MARK: - Actions

    @objc private func onScan() {
        append("🔍 开始扫描设备…")
        BleAPI.shared.scan()
    }

    @objc private func onDisconnect() {
        BleAPI.shared.disconnect()
        append("🔚 已断开连接")
    }

    // MARK: - log
    private func append(_ s: String) {
        DispatchQueue.main.async {
            let time = Self.ts()
            self.logView.text.append("[\(time)] \(s)\n")
            let range = NSMakeRange(self.logView.text.count - 1, 1)
            self.logView.scrollRangeToVisible(range)
        }
    }
    private static func ts() -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss"
        return f.string(from: Date())
    }
}
