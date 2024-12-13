//
//  AnimationVC.swift
//  SwiftDemo
//
//  Created by app on 2024/12/12.
//

import Foundation
import UIKit
class AnimationVC: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        UIView.animate(withDuration: 1.0, animations: {
            self.view.alpha = 0.0
        }){ _ in
            UIView.animate(withDuration: 1.0, animations: {
                self.view.alpha = 1.0
                self.view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) // 缩放到110%
            }){_ in
                // 缩放完成后，恢复原始大小并添加旋转效果
                UIView.animate(withDuration: 1.0) {
                    self.view.transform = CGAffineTransform.identity // 恢复到原始大小
                    self.view.transform = self.view.transform.rotated(by: .pi / 18) // 旋转π/18弧度
                }
            }
        }
    }
    
}
