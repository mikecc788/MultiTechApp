//
//  DeviceCell.swift
//  BleToolsDemo
//
//  Created by app on 2025/12/10.
//

import UIKit
import SnapKit

/// 设备列表单元格
class DeviceCell: UITableViewCell {
    static let identifier = "DeviceCell"
    
    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .medium)
        l.textColor = .label
        return l
    }()
    
    private let rssiLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .regular)
        l.textColor = .secondaryLabel
        return l
    }()
    
    private let signalLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12)
        return l
    }()
    
    private let idLabel: UILabel = {
        let l = UILabel()
        l.font = .monospacedSystemFont(ofSize: 11, weight: .regular)
        l.textColor = .tertiaryLabel
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(rssiLabel)
        contentView.addSubview(signalLabel)
        contentView.addSubview(idLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(12)
            make.right.equalTo(signalLabel.snp.left).offset(-8)
        }
        
        signalLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalTo(nameLabel)
        }
        
        rssiLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
        
        idLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(rssiLabel.snp.bottom).offset(2)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(with device: BleDevice) {
        nameLabel.text = device.displayName
        rssiLabel.text = device.rssiDisplayText
        signalLabel.text = device.signalStrength
        idLabel.text = device.deviceId
        
        // 已连接设备高亮显示
        if device.isSystemConnected {
            nameLabel.textColor = .systemGreen
            rssiLabel.textColor = .systemGreen
        } else {
            nameLabel.textColor = .label
            rssiLabel.textColor = .secondaryLabel
        }
    }
}

