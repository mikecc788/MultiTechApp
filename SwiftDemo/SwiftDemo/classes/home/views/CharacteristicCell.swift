//
//  CharacteristicCell.swift
//  SwiftDemo
//
//  Created by app on 2025/8/12.
//

import UIKit
import CoreBluetooth
import SnapKit

final class CharacteristicCell: UITableViewCell {
    // MARK: UI
    private let uuidLabel = UILabel()
    private let propertiesLabel = UILabel()
    private let valueLabel = UILabel()
    private let actionStackView = UIStackView()
    private let container = UIStackView()
    private let manager = BluetoothManager.shared

    // MARK: Data
    private var characteristic: CBCharacteristic?

    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellUI()
        setupConstraints()
    }
    required init?(coder: NSCoder) { super.init(coder: coder); setupCellUI(); setupConstraints() }

    // MARK: Configure
    func configure(with characteristic: CBCharacteristic) {
        self.characteristic = characteristic
        uuidLabel.text = "特征: \(characteristic.uuid.uuidString)"
        propertiesLabel.text = "属性: \(characteristic.properties.stringRepresentation)"
        update(with: characteristic)

        // 动态动作按钮
        actionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if characteristic.properties.contains(.read) {
            actionStackView.addArrangedSubview(createButton(title: "读取", action: #selector(readTapped)))
        }
        if characteristic.properties.contains(.write) || characteristic.properties.contains(.writeWithoutResponse) {
            actionStackView.addArrangedSubview(createButton(title: "写入", action: #selector(writeTapped)))
        }
        if characteristic.properties.contains(.notify) {
            let title = characteristic.isNotifying ? "取消订阅" : "订阅通知"
            actionStackView.addArrangedSubview(createButton(title: title, action: #selector(notifyTapped)))
        }
    }

    func update(with characteristic: CBCharacteristic) {
        if let value = characteristic.value {
            let hexString = value.map { String(format: "%02X", $0) }.joined()
            let ascii = String(data: value, encoding: .utf8) ?? "非文本"
            valueLabel.text = "值: \(hexString) (\(ascii))"
        } else {
            valueLabel.text = "值: (空)"
        }
    }

    // MARK: Actions
    @objc private func readTapped() {
        guard let ch = characteristic, let service = ch.service else { return }
        do { try manager.readValue(for: ch.uuid, in: service.uuid) } catch { print("读取失败: \(error)") }
    }

    @objc private func writeTapped() {
        guard let ch = characteristic, let service = ch.service else { return }
        let alert = UIAlertController(title: "写入数据", message: "请输入要写入的16进制字符串", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "发送", style: .default, handler: { [weak self] _ in
            guard
                let hexString = alert.textFields?.first?.text,
                let data = Data(hexString: hexString)
            else { print("无效的16进制字符串"); return }
            do {
                let type: CBCharacteristicWriteType = ch.properties.contains(.write) ? .withResponse : .withoutResponse
                try self?.manager.write(data, to: ch.uuid, in: service.uuid, type: type)
            } catch { print("写入失败: \(error)") }
        }))
        nearestViewController()?.present(alert, animated: true)
    }

    @objc private func notifyTapped() {
        guard let ch = characteristic, let service = ch.service else { return }
        do { try manager.setNotify(!ch.isNotifying, for: ch.uuid, in: service.uuid) } catch { print("设置通知失败: \(error)") }
    }

    // MARK: Private UI
    private func setupCellUI() {
        selectionStyle = .none
        contentView.backgroundColor = .systemBackground

        uuidLabel.font = .boldSystemFont(ofSize: 13)
        uuidLabel.textColor = .label
        uuidLabel.numberOfLines = 0

        propertiesLabel.font = .systemFont(ofSize: 12)
        propertiesLabel.textColor = .secondaryLabel
        propertiesLabel.numberOfLines = 0

        valueLabel.font = .systemFont(ofSize: 12)
        valueLabel.textColor = .systemBlue
        valueLabel.numberOfLines = 0

        actionStackView.axis = .horizontal
        actionStackView.alignment = .fill
        actionStackView.distribution = .fillProportionally
        actionStackView.spacing = 8

        container.axis = .vertical
        container.alignment = .fill
        container.distribution = .fill
        container.spacing = 8

        [uuidLabel, propertiesLabel, valueLabel, actionStackView].forEach { container.addArrangedSubview($0) }
        contentView.addSubview(container)
    }

    private func setupConstraints() {
        container.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(12)
            make.bottom.equalTo(contentView.snp.bottom).inset(12)
            make.left.equalTo(contentView.snp.left).offset(16)
            make.right.equalTo(contentView.snp.right).inset(16)
        }
        // 让按钮高度更易点
        actionStackView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(36)
        }
    }

    private func createButton(title: String, action: Selector) -> UIButton {
        let b = UIButton(type: .system)
        b.setTitle(title, for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        b.backgroundColor = .systemGray6
        b.layer.cornerRadius = 8
        b.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        b.addTarget(self, action: action, for: .touchUpInside)
        return b
    }

    private func nearestViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let r = responder {
            if let vc = r as? UIViewController { return vc }
            responder = r.next
        }
        return nil
    }
}




