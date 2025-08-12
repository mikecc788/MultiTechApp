//
//  BLEViewModel.swift
//  SwiftDemo
//
//  Created by app on 2025/8/12.
//

import Foundation
import Combine
import CoreBluetooth

// 1. 定义一个明确的扫描状态机
enum ScanState {
    case idle
    case scanning
    case stopped
    case error(String)
}

final class BLEViewModel {
    
    // MARK: - Outputs for View
    @Published private(set) var devices: [DiscoveredPeripheral] = []
    @Published private(set) var scanState: ScanState = .idle // 2. 使用状态机替代布尔值
    @Published private(set) var isBluetoothPoweredOn: Bool = false
    
    let navigationPublisher = PassthroughSubject<CBPeripheral, Never>()
    let alertPublisher = PassthroughSubject<String, Never>()

    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let manager = BluetoothManager.shared
    private var isConnecting = false

    // MARK: - Lifecycle
    init() {
        bindManagerEvents()
        handleStateUpdate(manager.statePublisher.value)
    }

    // MARK: - Inputs from View
    
    /// 响应按钮点击
    func toggleScan() {
        switch scanState {
        case .scanning:
            manager.stopScan()
            scanState = .stopped
        case .idle, .stopped, .error:
            startScanProcess()
        }
    }
    
    /// 响应下拉刷新
    func refreshScan() {
        // 无论当前是什么状态，下拉刷新都应该强制开始一次新的扫描
        startScanProcess()
    }
    
    func connect(to device: DiscoveredPeripheral) {
        if device.isConnected {
            navigationPublisher.send(device.peripheral)
        } else {
            isConnecting = true
            manager.connect(device.peripheral)
        }
    }

    // MARK: - Private: Binding & Logic Handlers
    
    private func startScanProcess() {
        guard isBluetoothPoweredOn else {
            scanState = .error("请开启蓝牙")
            alertPublisher.send("请开启蓝牙")
            return
        }
        
        // 3. 确保清除数据和开始扫描是原子操作
        devices.removeAll()
        scanState = .scanning
        
        if let connected = manager.connectedPeripheral {
            let item = DiscoveredPeripheral(peripheral: connected, adv: [:], rssi: 0, isConnected: true)
            handleDiscovery(item)
        }

        var filter = BLEScanFilter()
        filter.namePrefix = ""
        manager.startScan(filter: filter)
    }
    
    private func bindManagerEvents() {
        manager.statePublisher
            .sink { [weak self] state in self?.handleStateUpdate(state) }
            .store(in: &cancellables)

        manager.discoveredPublisher
            .sink { [weak self] item in self?.handleDiscovery(item) }
            .store(in: &cancellables)

        manager.connectedPublisher
            .sink { [weak self] peripheral in self?.handleConnect(for: peripheral) }
            .store(in: &cancellables)
            
        manager.failedToConnectPublisher
            .sink { [weak self] (_, error) in
                self?.isConnecting = false
                self?.alertPublisher.send("连接失败: \(error?.localizedDescription ?? "请重试")")
            }
            .store(in: &cancellables)

        manager.disconnectedPublisher
            .sink { [weak self] (peripheral, _) in self?.handleDisconnect(for: peripheral) }
            .store(in: &cancellables)
    }
    
    private func handleStateUpdate(_ state: CBManagerState) {
        isBluetoothPoweredOn = (state == .poweredOn)
    }

    private func handleDiscovery(_ item: DiscoveredPeripheral) {
        // 1. 获取设备名称（优先用 peripheral.name，其次用广播名）
        let name = item.peripheral.name ?? item.adv.localName
        
        // 2. 检查名称是否存在且不为空，如果无效则直接返回，不处理该设备
        guard let deviceName = name, !deviceName.isEmpty else {
            return
        }
        
        if let idx = devices.firstIndex(where: { $0.peripheral.identifier == item.peripheral.identifier }) {
            devices[idx] = item
        } else {
            devices.append(item)
        }
    }

    private func handleConnect(for peripheral: CBPeripheral) {
        if let idx = devices.firstIndex(where: { $0.peripheral.identifier == peripheral.identifier }) {
            devices[idx].isConnected = true
        }
        if isConnecting {
            isConnecting = false
            navigationPublisher.send(peripheral)
        }
    }

    private func handleDisconnect(for peripheral: CBPeripheral) {
        if let idx = devices.firstIndex(where: { $0.peripheral.identifier == peripheral.identifier }) {
            devices[idx].isConnected = false
        }
    }
}
