
import UIKit
import CoreBluetooth
import Combine
import SnapKit

class BLEDetailVC: UIViewController {

    // MARK: - Properties
    var peripheral: CBPeripheral!
    private var services: [CBService] = []
    private var cancellables = Set<AnyCancellable>()
    private let manager = BluetoothManager.shared
    
    // 用于聚合UI刷新请求，防止崩溃
    private let reloadDataSubject = PassthroughSubject<Void, Never>()

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.dataSource = self
        tv.delegate = self
        tv.register(CharacteristicCell.self, forCellReuseIdentifier: "CharacteristicCell")
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 120
        return tv
    }()

    // MARK: - Lifecycle
    deinit {
        print("BLEDetailVC deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindBluetoothEvents()
        
        // 开始发现服务（manager会作用于其内部的 connectedPeripheral）
        try? manager.discoverServices()
    }

    // MARK: - Setup
    private func setupUI() {
        title = peripheral.name ?? "设备详情"
        view.backgroundColor = .systemGroupedBackground
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private func bindBluetoothEvents() {
        // 1. 处理断开连接
        manager.disconnectedPublisher
            .filter { $0.0.identifier == self.peripheral.identifier }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (_, error) in
                self?.showAlert(title: "连接已断开", message: error?.localizedDescription ?? "设备已与您断开连接", pop: true)
            }
            .store(in: &cancellables)

        // 2. 处理服务发现
        manager.servicesDiscoveredPublisher
            .filter { $0.identifier == self.peripheral.identifier }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] peripheral in
                guard let self = self else { return }
                self.services = peripheral.services ?? []
                self.reloadDataSubject.send()
                
                // 自动为所有服务发现特征
                self.services.forEach { service in
                    try? self.manager.discoverCharacteristics(for: service.uuid)
                }
            }
            .store(in: &cancellables)

        // 3. 处理特征发现
        manager.characteristicsDiscoveredPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                // 收到新特征后，请求刷新UI
                self?.reloadDataSubject.send()
            }
            .store(in: &cancellables)

        // 4. 处理特征值更新
        manager.valueUpdatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (characteristic, _) in
                self?.updateCell(for: characteristic)
            }
            .store(in: &cancellables)

        // 5. 处理写入回执 (修正了Publisher名称)
        manager.writeAckPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (characteristic, error) in
                if let error = error {
                    self?.showAlert(title: "写入失败", message: error.localizedDescription)
                    return
                }
                print("写入成功: \(characteristic.uuid)")
                // 写入成功后主动读取一次，以刷新UI上的值
                try? self?.manager.readValue(for: characteristic.uuid, in: characteristic.service!.uuid)
            }
            .store(in: &cancellables)
            
        // 6. 处理订阅状态变更回执
        manager.notifyUpdatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (characteristic, error) in
                if let error = error {
                    self?.showAlert(title: "订阅失败", message: error.localizedDescription)
                    return
                }
                self?.reconfigureCell(for: characteristic)
            }
            .store(in: &cancellables)
            
        // 7. 订阅刷新请求，并用debounce防止UI崩溃
        reloadDataSubject
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Helpers
    private func showAlert(title: String, message: String, pop: Bool = false) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default) { [weak self] _ in
            if pop {
                self?.navigationController?.popViewController(animated: true)
            }
        })
        present(alert, animated: true)
    }
    
    private func updateCell(for characteristic: CBCharacteristic) {
        for (section, service) in services.enumerated() {
            if let row = service.characteristics?.firstIndex(where: { $0.uuid == characteristic.uuid }) {
                let indexPath = IndexPath(row: row, section: section)
                if let cell = tableView.cellForRow(at: indexPath) as? CharacteristicCell {
                    cell.update(with: characteristic)
                }
            }
        }
    }
    
    private func reconfigureCell(for characteristic: CBCharacteristic) {
        for (section, service) in services.enumerated() {
            if let row = service.characteristics?.firstIndex(where: { $0.uuid == characteristic.uuid }) {
                let indexPath = IndexPath(row: row, section: section)
                if let cell = tableView.cellForRow(at: indexPath) as? CharacteristicCell {
                    cell.configure(with: characteristic)
                }
            }
        }
    }
}

// MARK: -UITableViewDataSource & Delegate
extension BLEDetailVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return services.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services[section].characteristics?.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "服务: \(services[section].uuid.uuidString)"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacteristicCell", for: indexPath) as! CharacteristicCell
        if let characteristic = services[indexPath.section].characteristics?[indexPath.row] {
            cell.configure(with: characteristic)
        }
        return cell
    }
}


