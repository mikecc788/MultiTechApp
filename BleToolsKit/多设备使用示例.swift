//
//  多设备使用示例.swift
//  BleToolsKit
//
//  演示如何扫描多台设备并让用户选择连接
//

import Foundation
import BleToolsKit
import UIKit

// MARK: - 设备数据模型
struct BleDeviceInfo {
    let deviceId: String      // 设备唯一 ID
    let deviceName: String    // 设备名称
    let rssi: Int            // 信号强度
}

// MARK: - 多设备管理器
class MultiBleDeviceManager {
    
    // 存储扫描到的所有设备
    private var discoveredDevices: [BleDeviceInfo] = []
    
    // 当前连接的设备 ID
    private var connectedDeviceId: String?
    
    // UI 更新回调（用于刷新设备列表）
    var onDeviceListUpdated: (([BleDeviceInfo]) -> Void)?
    
    // MARK: - 初始化
    init() {
        setupBleCallbacks()
    }
    
    // MARK: - 设置蓝牙回调
    private func setupBleCallbacks() {
        // 1. 扫描到设备的回调 - 每扫描到一台设备就会调用一次
        BleAPI.shared.onDeviceFound = { [weak self] deviceId, deviceName, rssi in
            guard let self = self else { return }
            
            print("📱 扫描到设备:")
            print("   ID: \(deviceId)")
            print("   名称: \(deviceName)")
            print("   信号: \(rssi) dBm")
            
            // 创建设备信息
            let device = BleDeviceInfo(
                deviceId: deviceId,
                deviceName: deviceName,
                rssi: rssi
            )
            
            // 检查是否已存在（避免重复）
            if !self.discoveredDevices.contains(where: { $0.deviceId == deviceId }) {
                self.discoveredDevices.append(device)
                
                // 通知 UI 更新设备列表
                self.onDeviceListUpdated?(self.discoveredDevices)
            }
        }
        
        // 2. 连接成功的回调
        BleAPI.shared.onConnected = { [weak self] in
            print("✅ 设备连接成功！")
            print("✅ 已自动发送绑定指令")
            // 可以在这里更新 UI，显示连接成功状态
        }
        
        // 3. 收到数据的回调
        BleAPI.shared.onDataReceived = { hexString in
            print("📨 收到数据: \(hexString)")
            // 处理接收到的数据
        }
        
        // 4. 错误回调
        BleAPI.shared.onError = { error in
            print("❌ 错误: \(error)")
        }
    }
    
    // MARK: - 开始扫描
    func startScanning() {
        print("🔍 开始扫描设备...")
        
        // 清空之前的设备列表
        discoveredDevices.removeAll()
        onDeviceListUpdated?([])
        
        // 开始扫描
        BleAPI.shared.scan()
    }
    
    // MARK: - 停止扫描
    func stopScanning() {
        print("⏸️ 停止扫描")
        BleAPI.shared.stopScan()
    }
    
    // MARK: - 连接指定设备（用户选择后调用）
    func connectToDevice(deviceId: String) {
        print("🔗 正在连接设备: \(deviceId)")
        
        // 停止扫描
        stopScanning()
        
        // 记录连接的设备
        connectedDeviceId = deviceId
        
        // 连接设备
        BleAPI.shared.connect(deviceId: deviceId)
    }
    
    // MARK: - 断开连接
    func disconnect() {
        print("🔌 断开连接")
        BleAPI.shared.disconnect()
        connectedDeviceId = nil
    }
    
    // MARK: - 发送数据
    func sendData(_ hexString: String) {
        guard connectedDeviceId != nil else {
            print("❌ 未连接设备，无法发送数据")
            return
        }
        
        print("📤 发送数据: \(hexString)")
        BleAPI.shared.send(hexString)
    }
    
    // MARK: - 获取设备列表
    func getDeviceList() -> [BleDeviceInfo] {
        return discoveredDevices
    }
}

// MARK: - UIViewController 示例（SwiftUI 版本见下方）
class DeviceListViewController: UIViewController {
    
    private let bleManager = MultiBleDeviceManager()
    private var tableView: UITableView!
    private var devices: [BleDeviceInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "选择设备"
        
        setupTableView()
        setupBleManager()
        
        // 开始扫描
        bleManager.startScanning()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func setupBleManager() {
        // 设备列表更新回调
        bleManager.onDeviceListUpdated = { [weak self] devices in
            DispatchQueue.main.async {
                self?.devices = devices
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableView Delegate & DataSource
extension DeviceListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let device = devices[indexPath.row]
        
        // 显示设备信息
        cell.textLabel?.text = "\(device.deviceName) (\(device.rssi) dBm)"
        cell.detailTextLabel?.text = device.deviceId
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = devices[indexPath.row]
        
        // 用户点击某个设备，连接该设备
        print("👆 用户选择了设备: \(device.deviceName)")
        bleManager.connectToDevice(deviceId: device.deviceId)
        
        // 可以跳转到下一个页面
        // navigationController?.pushViewController(DeviceControlViewController(), animated: true)
    }
}

// MARK: - SwiftUI 示例
#if canImport(SwiftUI)
import SwiftUI

struct DeviceListView: View {
    
    @StateObject private var viewModel = DeviceListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.devices, id: \.deviceId) { device in
                Button(action: {
                    // 用户点击设备，连接该设备
                    viewModel.connectToDevice(device)
                }) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(device.deviceName)
                            .font(.headline)
                        
                        HStack {
                            Text("信号: \(device.rssi) dBm")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text(device.deviceId)
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("选择设备 (\(viewModel.devices.count))")
            .navigationBarItems(trailing: Button(action: {
                viewModel.startScanning()
            }) {
                Image(systemName: "arrow.clockwise")
            })
        }
        .onAppear {
            viewModel.startScanning()
        }
    }
}

// SwiftUI ViewModel
class DeviceListViewModel: ObservableObject {
    
    @Published var devices: [BleDeviceInfo] = []
    private let bleManager = MultiBleDeviceManager()
    
    init() {
        bleManager.onDeviceListUpdated = { [weak self] devices in
            DispatchQueue.main.async {
                self?.devices = devices
            }
        }
    }
    
    func startScanning() {
        bleManager.startScanning()
    }
    
    func connectToDevice(_ device: BleDeviceInfo) {
        print("👆 用户选择了设备: \(device.deviceName)")
        bleManager.connectToDevice(deviceId: device.deviceId)
    }
}

#endif

// MARK: - 使用流程说明
/*
 
 ✅ 多设备支持完整流程：
 
 1️⃣ 开始扫描
    bleManager.startScanning()
    
 2️⃣ 扫描到设备时，会自动调用回调
    每扫描到一台设备，onDeviceFound 就会被调用一次
    可以扫描到多台设备，例如：
    - Air Smart Extra #1 (UUID: xxx-111)
    - Air Smart Extra #2 (UUID: xxx-222)  
    - Air Smart Extra #3 (UUID: xxx-333)
    
 3️⃣ 在 UI 上显示设备列表
    将扫描到的设备显示在 TableView 或 List 中
    显示设备名称、信号强度等信息
    
 4️⃣ 用户点击选择某个设备
    获取该设备的 deviceId
    调用 bleManager.connectToDevice(deviceId: deviceId)
    
 5️⃣ SDK 会连接到选中的设备
    自动发现服务和特征
    自动发送绑定指令
    连接成功后调用 onConnected 回调
    
 6️⃣ 开始通信
    通过 sendData() 发送数据
    通过 onDataReceived 接收数据
    
 */

// MARK: - 简单使用示例
/*
 
 // 创建管理器
 let bleManager = MultiBleDeviceManager()
 
 // 设置设备列表更新回调
 bleManager.onDeviceListUpdated = { devices in
     print("发现 \(devices.count) 台设备:")
     for device in devices {
         print("  - \(device.deviceName), 信号: \(device.rssi)")
     }
 }
 
 // 开始扫描
 bleManager.startScanning()
 
 // 等待用户选择设备...
 // 假设用户选择了第一个设备
 if let firstDevice = bleManager.getDeviceList().first {
     bleManager.connectToDevice(deviceId: firstDevice.deviceId)
 }
 
 */

// MARK: - 核心要点
/*
 
 🎯 多设备支持的关键：
 
 1. ✅ deviceId 是唯一的
    每台设备都有独特的 UUID，通过 deviceId 区分
    
 2. ✅ scannedDevices 字典保存所有设备
    SDK 内部会保存所有扫描到的设备
    
 3. ✅ onDeviceFound 会被多次调用
    每扫描到一台新设备，回调就会被调用一次
    
 4. ✅ connect(deviceId:) 连接指定设备
    通过 deviceId 参数指定要连接哪一台设备
    
 5. ✅ 支持先扫描后连接
    扫描阶段：收集所有设备信息
    连接阶段：用户选择后再连接
    
 */

