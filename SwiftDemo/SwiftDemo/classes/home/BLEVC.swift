//
//  BLEVC.swift
//  SwiftDemo
//
//  Created by app on 2022/3/3.
//

import Foundation
import UIKit
import CoreBluetooth
import Combine
import SnapKit

final class BLEVC: BaseViewController {
    
    // MARK: - UI Properties
    @IBOutlet weak var tableView: UITableView!
    private var scanButton: UIButton!
    private var activityIndicator: UIActivityIndicatorView!
    private let refreshControl = UIRefreshControl()
    
    // MARK: - ViewModel
    private let viewModel = BLEViewModel()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupUI()
        bindViewModel()
        
        // 视图加载后自动开始扫描
        viewModel.refreshScan()
    }

    // MARK: - UI Setup
    private func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        tableView.register(DeviceTableViewCell.self, forCellReuseIdentifier: "DeviceCell")
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        tableView.refreshControl = refreshControl
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 60.adapted))
        scanButton = UIButton(type: .system)
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
        headerView.addSubview(scanButton)
        headerView.addSubview(activityIndicator)
        scanButton.snp.makeConstraints { make in make.center.equalToSuperview() }
        activityIndicator.snp.makeConstraints { make in
            make.leading.equalTo(scanButton.snp.trailing).offset(8)
            make.centerY.equalTo(scanButton)
        }
        tableView.tableHeaderView = headerView
    }

    // MARK: - ViewModel Binding
    private func bindViewModel() {
        // 订阅设备列表变化 -> 刷新表格
        viewModel.$devices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.tableView.reloadData() }
            .store(in: &cancellables)
            
        // 1. 订阅新的 scanState 来驱动UI更新
        viewModel.$scanState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                
                // 停止刷新动画
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                
                switch state {
                case .scanning:
                    self.scanButton.setTitle("停止扫描", for: .normal)
                    self.activityIndicator.startAnimating()
                case .idle, .stopped, .error:
                    self.scanButton.setTitle("开始扫描", for: .normal)
                    self.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
            
        // 订阅蓝牙电源状态 -> 更新按钮可用性
        viewModel.$isBluetoothPoweredOn
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: scanButton)
            .store(in: &cancellables)
            
        // 订阅导航事件 -> 执行页面跳转
        viewModel.navigationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] peripheral in self?.navigateToDetail(for: peripheral) }
            .store(in: &cancellables)
            
        // 订阅弹窗事件 -> 显示提示
        viewModel.alertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in self?.showAlert(message: message) }
            .store(in: &cancellables)
    }

    // MARK: - Actions
    @objc private func scanButtonTapped() {
        viewModel.toggleScan()
    }
    
    @objc private func handleRefreshControl() {
        viewModel.refreshScan()
    }

    // MARK: - Navigation & Helpers
    private func navigateToDetail(for peripheral: CBPeripheral) {
        guard let navController = navigationController else {
            showAlert(message: "无法导航到详情页。")
            return
        }
        let detailVC = BLEDetailVC()
        detailVC.peripheral = peripheral
        navController.pushViewController(detailVC, animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource & Delegate
extension BLEVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.devices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as! DeviceTableViewCell
        cell.configure(with: viewModel.devices[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.connect(to: viewModel.devices[indexPath.row])
    }
}

