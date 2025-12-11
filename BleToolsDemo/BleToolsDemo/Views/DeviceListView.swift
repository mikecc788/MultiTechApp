//
//  DeviceListView.swift
//  BleToolsDemo
//
//  Created by app on 2025/12/10.
//

import UIKit
import SnapKit

/// 设备列表选择视图
class DeviceListView: UIView {
    
    // MARK: - Properties
    var onDeviceSelected: ((BleDevice) -> Void)?
    var onClose: (() -> Void)?
    
    private var devices: [BleDevice] = []
    private var backgroundTapGesture: UITapGestureRecognizer!
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBackground
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        return v
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "选择设备"
        l.font = .systemFont(ofSize: 18, weight: .bold)
        l.textAlignment = .center
        return l
    }()
    
    private let closeButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("✕", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        return b
    }()
    
    private let tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.register(DeviceCell.self, forCellReuseIdentifier: DeviceCell.identifier)
        t.rowHeight = UITableView.automaticDimension
        t.estimatedRowHeight = 80
        t.separatorStyle = .singleLine
        return t
    }()
    
    private let emptyLabel: UILabel = {
        let l = UILabel()
        l.text = "正在扫描设备...\n请稍候"
        l.font = .systemFont(ofSize: 15, weight: .regular)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()
    
    private let rescanButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("重新扫描", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return b
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(closeButton)
        containerView.addSubview(tableView)
        containerView.addSubview(emptyLabel)
        containerView.addSubview(rescanButton)
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(32)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(rescanButton.snp.top).offset(-12)
        }
        
        rescanButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(tableView)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(onCloseTapped), for: .touchUpInside)
        rescanButton.addTarget(self, action: #selector(onRescanTapped), for: .touchUpInside)
        
        backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(onBackgroundTapped))
        backgroundTapGesture.delegate = self
        addGestureRecognizer(backgroundTapGesture)
    }
    
    // MARK: - Public Methods
    func updateDevices(_ devices: [BleDevice]) {
        self.devices = devices
        tableView.reloadData()
        emptyLabel.isHidden = !devices.isEmpty
        tableView.isHidden = devices.isEmpty
    }
    
    func show(in view: UIView) {
        view.addSubview(self)
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 动画显示
        self.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.alpha = 1
            self.containerView.transform = .identity
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    // MARK: - Actions
    @objc private func onCloseTapped() {
        dismiss()
        onClose?()
    }
    
    @objc private func onRescanTapped() {
        devices.removeAll()
        tableView.reloadData()
        emptyLabel.isHidden = false
        tableView.isHidden = true
        onClose?()
    }
    
    @objc private func onBackgroundTapped() {
        // 由于已经在 gestureRecognizer:shouldReceive: 中判断了点击区域
        // 这里被调用时一定是点击了背景区域
        onCloseTapped()
    }
}

// MARK: - UITableViewDelegate & DataSource
extension DeviceListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DeviceCell.identifier, for: indexPath) as? DeviceCell else {
            return UITableViewCell()
        }
        let device = devices[indexPath.row]
        cell.configure(with: device)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let device = devices[indexPath.row]
        onDeviceSelected?(device)
        dismiss()
    }
}

// MARK: - UIGestureRecognizerDelegate
extension DeviceListView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // 如果点击的是 tableView、containerView 或它们的子视图，不触发手势
        let location = touch.location(in: self)
        if containerView.frame.contains(location) {
            return false
        }
        return true
    }
}

