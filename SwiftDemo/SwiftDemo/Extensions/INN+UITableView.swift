//
//  INN+UITableView.swift
//  AudioLatencyTester
//
//  Created by chenliao on 2021/10/29.
//

import Foundation
import UIKit

public extension UITableView{
    // MARK: - 快捷注册 Xib cell
    /// cellIdentifier == 类名.self
    func inn_RegisterXib(cellType: UITableViewCell.Type, bundle: Bundle? = nil) {
        let className = String(describing: cellType.classForCoder())
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }
    // MARK: - 批量注册 Xib cell
    func inn_RegisterXibs(cellTypes: [UITableViewCell.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { inn_RegisterXib(cellType: $0, bundle: bundle) }
    }
    // MARK: - 快捷注册 cell
    /// cellIdentifier == 类名.self
    func inn_Register(cellType: UITableViewCell.Type) {
        let className = String(describing: cellType.classForCoder())
        register(cellType, forCellReuseIdentifier: className)
    }
    
    // MARK: - 批量注册 cell
    /// [cellIdentifier] == [类名.self]
    func inn_Registers(cellTypes: [UITableViewCell.Type]) {
        cellTypes.forEach { inn_Register(cellType: $0) }
    }
}
