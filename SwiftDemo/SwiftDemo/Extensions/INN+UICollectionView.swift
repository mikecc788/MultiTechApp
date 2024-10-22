//
//  INN+UICollectionView.swift
//  AudioLatencyTester
//
//  Created by chenliao on 2021/10/29.
//

import Foundation
import UIKit
public extension UICollectionView{
    // MARK: - 快捷注册 Xib cell
    /// cellIdentifier == 类名.self
    func inn_RegisterXib(cellType: UICollectionViewCell.Type, bundle: Bundle? = nil) {
        let className = String(describing: cellType.classForCoder())
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: className)
    }
    // MARK: - 批量注册 Xib cell
    func inn_RegisterXibs(cellTypes: [UICollectionViewCell.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { inn_RegisterXib(cellType: $0, bundle: bundle) }
    }
    // MARK: - 快捷注册 cell
    /// cellIdentifier == 类名.self
    func inn_Register(cellType: UICollectionViewCell.Type) {
        let className = String(describing: cellType.classForCoder())
        register(cellType, forCellWithReuseIdentifier: className)
    }
    
    // MARK: - 批量注册 cell
    func inn_Registers(cellTypes: [UICollectionViewCell.Type]) {
        cellTypes.forEach { inn_Register(cellType: $0) }
    }
    // MARK: - 快捷注册 ReusableView
    func inn_Register(reusableViewType: UICollectionReusableView.Type,
                      ofKind kind: String = UICollectionView.elementKindSectionHeader,
                      bundle: Bundle? = nil) {
        let className = String(describing: reusableViewType.classForCoder())
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
    }
}

public extension UICollectionView {
    // MARK: 1.1、移动 item
    /// 允许手势移动Item，默认不允许
    func allowsMoveItem() {
        // 长点击事件，做移动cell操作
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGestureMove))
        self.addGestureRecognizer(longPressGesture)
    }
    
    // MARK: 长点击事件
    @objc private func handleLongGestureMove(_ gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        // 开始移动
        case UIGestureRecognizer.State.began:
            let point = gesture.location(in: gesture.view!)
            if let selectedIndexPath = self.indexPathForItem(at: point) {
                // 开始移动
                self.beginInteractiveMovementForItem(at: selectedIndexPath)
            }
        case UIGestureRecognizer.State.changed:
            // 移动中
            let point = gesture.location(in: gesture.view!)
            self.updateInteractiveMovementTargetPosition(point)
        case UIGestureRecognizer.State.ended:
            // 结束移动
            self.endInteractiveMovement()
        default:
            // 取消移动
            self.cancelInteractiveMovement()
        }
    }
}
