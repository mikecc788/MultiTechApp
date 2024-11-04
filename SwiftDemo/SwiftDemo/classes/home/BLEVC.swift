//
//  BLEVC.swift
//  SwiftDemo
//
//  Created by app on 2022/3/3.
//

import Foundation
import UIKit
import CoreBluetooth
class BLEVC:BaseViewController{
    @IBOutlet weak var tableView: UITableView!
    private var devices: [BLEDeviceModel] = []
    private var scanButton: UIButton!
    private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
        
        setupUI()
        setupBluetooth()
    }
    
    private func setupUI() {
          // 配置TableView
        tableView.rowHeight = 80
        tableView.register(DeviceTableViewCell.self, forCellReuseIdentifier: "DeviceCell")
          // 创建HeaderView
          let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 60))
          
          // 创建扫描按钮
          scanButton = UIButton(type: .system)
          scanButton.setTitle("开始扫描", for: .normal)
          scanButton.translatesAutoresizingMaskIntoConstraints = false
          scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
          
          // 创建活动指示器
          activityIndicator = UIActivityIndicatorView(style: .medium)
          activityIndicator.translatesAutoresizingMaskIntoConstraints = false
          activityIndicator.hidesWhenStopped = true
          
          // 添加子视图
          headerView.addSubview(scanButton)
          headerView.addSubview(activityIndicator)
          
          // 设置约束
          NSLayoutConstraint.activate([
              scanButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
              scanButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
              
              activityIndicator.leadingAnchor.constraint(equalTo: scanButton.trailingAnchor, constant: 8),
              activityIndicator.centerYAnchor.constraint(equalTo: scanButton.centerYAnchor)
          ])
          
          // 设置HeaderView
          tableView.tableHeaderView = headerView
      }
    
    private func setupBluetooth() {
        BLEManager.shared.delegate = self
        // 检查蓝牙状态
        if BLEManager.shared.isBluetoothAvailable {
            startScan()
        }
    }

    @objc func scanButtonTapped(){
        if BLEManager.shared.isCurrentlyScanning {
              BLEManager.shared.stopScanning()
              scanButton.setTitle("开始扫描", for: .normal)
              activityIndicator.stopAnimating()
        } else {
            startScan()
        }
    }
    
    private func startScan() {
       guard BLEManager.shared.isBluetoothAvailable else {
           showAlert(message: "请打开蓝牙")
           return
       }
       
       // 清空设备列表
       devices.removeAll()
       tableView.reloadData()
       
       // 更新 UI 状态
       scanButton.setTitle("停止扫描", for: .normal)
       activityIndicator.startAnimating()
       
       // 开始扫描
       BLEManager.shared.startScanning(withServices: nil)
    }
    
    func didUpdateState(_ state: CBManagerState) {
        print("BLEVC --> didUpdateState:\(state)")
        
    }
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "提示",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}
// MARK: - UITableViewDataSource
extension BLEVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as! DeviceTableViewCell
        let device = devices[indexPath.row]
        
        // 配置 cell
        cell.textLabel?.text = device.name
        
        // 构建详细信息
        var detailText = "RSSI: \(device.rssi) dBm"
        if #available(iOS 15.0, *) {
            detailText = device.detailInfo
        }
        cell.detailTextLabel?.text = detailText
        
        return cell
    }
}
// MARK: - UITableViewDelegate
extension BLEVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 // 设置cell高度
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let device = devices[indexPath.row]
        BLEManager.shared.connect(device.peripheral)
    }
}
// MARK: - BLEManagerDelegate
extension BLEVC: BLEManagerDelegate{
    func bleManagerDidUpdateState(_ state: CBManagerState) {
        switch state {
        case .poweredOn:
            print("蓝牙已开启")
            scanButton.isEnabled = true
        case .poweredOff:
            showAlert(message: "请开启蓝牙")
            scanButton.isEnabled = false
            activityIndicator.stopAnimating()
        default:
            scanButton.isEnabled = false
            activityIndicator.stopAnimating()
        }
    }
    
    func bleManagerDidStartScan() {
        DispatchQueue.main.async { [weak self] in
            self?.scanButton.setTitle("停止扫描", for: .normal)
            self?.activityIndicator.startAnimating()
        }
    }
    
    func bleManagerDidStopScan() {
        DispatchQueue.main.async { [weak self] in
            self?.scanButton.setTitle("开始扫描", for: .normal)
            self?.activityIndicator.stopAnimating()
        }
    }
    
    func bleManagerDidUpdateDevices(_ devices: [BLEDeviceModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.devices = devices
            self?.tableView.reloadData()
        }
    }
    
    func bleManagerDidConnect(_ peripheral: CBPeripheral) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(message: "设备已连接")
        }
    }
    
    func bleManagerDidDisconnect(_ peripheral: CBPeripheral, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            if let error = error {
                self?.showAlert(message: "设备断开连接: \(error.localizedDescription)")
            } else {
                self?.showAlert(message: "设备已断开连接")
            }
        }
    }
}

// MARK: - Custom TableViewCell (可选)
class DeviceTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
}
