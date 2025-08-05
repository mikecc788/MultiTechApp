//
//  DetailViewController.swift
//  HealthChat
//
//  Created by app on 2025/2/27.
//

import UIKit

/// 详情页面视图控制器
class DetailViewController: UIViewController {
    private let streamManager = StreamManager()
    
    /// 页面标签
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "这是详情页面"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        streamManager.cancelCurrentRequest()
    }
    
    deinit{
        streamManager.cancelCurrentRequest()
    }
    // MARK: - 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        handleAnalysisData()
    }
    
    private func handleAnalysisData(){
        streamManager.getChatAIResponse(for: "请分析以下肺部测量数据，并给出简短的结果分析和建议：测量数据 FVC:1.30 L,FEV1:1.30 L,PEF:2.25 L/s ") { [weak self] response in
            self?.handleAIResponse(response)
        }
    }
    private func handleAIResponse(_ response: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

             self.infoLabel.text = response ?? "未收到有效响应"
        }
        
        
    }
    
    // MARK: - 私有方法
    
    /// 设置界面布局
    private func setupUI() {
        title = "详情页面"
        view.backgroundColor = .white
        
        // 添加标签到视图
        view.addSubview(infoLabel)
        
        // 设置标签约束
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
