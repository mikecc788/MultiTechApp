//
//  ViewController.swift
//  HealthChat
//
//  Created by app on 2025/2/27.
//

import UIKit

/// 主页面视图控制器
class ViewController: UIViewController {
    
    // MARK: - UI 组件
    
    /// 导航按钮
    private let navigationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("前往详情页面", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - 生命周期方法
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    // MARK: - 私有方法
    
    /// 设置界面布局
    private func setupUI() {
        title = "主页面"
        view.backgroundColor = .white
        
        // 添加按钮到视图
        view.addSubview(navigationButton)
        
        // 设置按钮约束
        NSLayoutConstraint.activate([
            navigationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            navigationButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            navigationButton.widthAnchor.constraint(equalToConstant: 200),
            navigationButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    /// 设置按钮事件
    private func setupActions() {
        navigationButton.addTarget(self, action: #selector(navigateToDetailPage), for: .touchUpInside)
    }
    
    /// 导航到详情页面
    @objc private func navigateToDetailPage() {
        let detailVC = DetailViewController()
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

