//
//  INN+View.swift
//  AudioLatencyTester
//
//  Created by chenliao on 2021/10/29.
//

import Foundation
import UIKit

public extension UIView {
    
    // MARK: - .x
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var rect = self.frame
            rect.origin.x = newValue
            self.frame = rect
        }
    }
    
    // MARK: - .y
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var rect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
    }
    // MARK: - .maxX
    var maxX: CGFloat {
        get {
            return self.frame.maxX
        }
    }
    
    // MARK: - .maxY
    var maxY: CGFloat {
        get {
            return self.frame.maxY
        }
    }
    
    // MARK: - .centerX
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    // MARK: - .centerY
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    // MARK: - .width
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var rect = self.frame
            rect.size.width = newValue
            self.frame = rect
        }
    }
    // MARK: - .height
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var rect = self.frame
            rect.size.height = newValue
            self.frame = rect
        }
    }
    
    // MARK: - .size
    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var rect = self.frame
            rect.size = newValue
            self.frame = rect
        }
    }
    // MARK: - 画线
    private func drawBorder(rect: CGRect, color: UIColor){
        let line = UIBezierPath(rect: rect)
        let lineShape = CAShapeLayer()
        lineShape.path = line.cgPath
        lineShape.fillColor = color.cgColor
        self.layer.addSublayer(lineShape)
    }
    // MARK: - 获取当前所在的控制器
    var getCurrentViewController: UIViewController? {
        var parent: UIResponder? = self
        while parent != nil {
            parent = parent?.next
            if let viewController = parent as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    func cornerRadius(radius: CGFloat) -> UIView {
        self.clipsToBounds = true;
        self.layer.cornerRadius = radius;
        return self;
    }
    
    func borderWidth(width: CGFloat) -> UIView {
        self.layer.borderWidth = width;
        return self;
    }
    
    func borderColor(color: UIColor) -> UIView {
        self.layer.borderColor = color.cgColor;
        return self;
    }
    
    // MARK: - 添加约束当前 view 占满父view
    func inn_FillSuperview() {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = superview.translatesAutoresizingMaskIntoConstraints
        if translatesAutoresizingMaskIntoConstraints {
            autoresizingMask = [.flexibleWidth, .flexibleHeight]
            frame = superview.bounds
        } else {
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        }
    }
}
