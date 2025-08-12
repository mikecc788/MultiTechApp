//
//  DeviceTableViewCell.swift
//  SwiftDemo
//
//  Created by app on 2025/8/12.
//

import UIKit

final class DeviceTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        // 使用 .subtitle 样式来方便地显示主标题和副标题
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    private func setupCell() {
        textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        detailTextLabel?.font = .systemFont(ofSize: 12)
        detailTextLabel?.textColor = .gray
        detailTextLabel?.numberOfLines = 0
        accessoryType = .disclosureIndicator
    }

    func configure(with device: DiscoveredPeripheral) {
        let name = device.peripheral.name ?? (device.adv.localName ?? "未知设备")
        textLabel?.text = name

        if device.isConnected {
            detailTextLabel?.text = "已连接"
            detailTextLabel?.textColor = .systemBlue
        } else {
            detailTextLabel?.text = "RSSI: \(device.rssi) dBm"
            detailTextLabel?.textColor = .gray
        }
    }
}
