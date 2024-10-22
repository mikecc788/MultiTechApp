//
//  INN+Xib.swift
//  AudioLatencyTester
//
//  Created by chenliao on 2021/10/29.
//

import UIKit

// MARK: -  协议静态值
public protocol inn_NibInstantiatable {
    static var inn_NibName: String { get }
    static var inn_NibBundle: Bundle { get }
    static var inn_NibOwner: Any? { get }
    static var inn_NibOptions: [UINib.OptionsKey: Any]? { get }
    static var inn_InstantiateIndex: Int { get }
}

// MARK: -  静态值赋默认值可在 view 类里面重新定义修改
public extension inn_NibInstantiatable where Self: NSObject {
    static var inn_NibName: String { return inn_ClassName }
    static var inn_NibBundle: Bundle { return Bundle(for: self) }
    static var inn_NibOwner: Any? { return self }
    static var inn_NibOptions: [UINib.OptionsKey: Any]? { return nil }
    static var inn_InstantiateIndex: Int { return 0 }
}

public extension inn_NibInstantiatable where Self: UIView {
    static func lgf() -> Self {
        let nib = UINib(nibName: inn_NibName, bundle: inn_NibBundle)
        return nib.instantiate(withOwner: inn_NibOwner, options: inn_NibOptions)[inn_InstantiateIndex] as! Self
    }
}

// 嵌入某个 view
public protocol inn_EmbeddedNibInstantiatable {
    associatedtype inn_Embedded: inn_NibInstantiatable
}

public extension inn_EmbeddedNibInstantiatable where Self: UIView, inn_Embedded: UIView {
    var embedded: inn_Embedded { return subviews[0] as! inn_Embedded }
    // 在 override func awakeFromNib() {} 中添加该方法
    func inn_ConfigureEmbededView() {
        let view = inn_Embedded.lgf()
        insertSubview(view, at: 0)
        view.inn_FillSuperview()
    }
}

/**
 final class NibView: UIView, NibInstantiatable {
     @IBOutlet weak var label: UILabel!
 }
 
 final class SecondaryNibView: UIView, NibInstantiatable {
     static var nibName: String { return NibView.className }
     static var instantiateIndex: Int { return 1 }
 
     @IBOutlet weak var label: UILabel!
 }
 
 final class EmbeddedView: UIView, NibInstantiatable {
     @IBOutlet weak var label: UILabel!
 }
 
 @IBDesignable
 final class IBEmbeddedView: UIView, EmbeddedNibInstantiatable {
     typealias Embedded = EmbeddedView
 
     override func awakeFromNib() {
         super.awakeFromNib()
         configureEmbededView()
     }
 }
 
 final class SuperviewOfEmbeddedView: UIView, NibInstantiatable {
 static var nibName: String { return NibView.className }
 static var instantiateIndex: Int { return 2 }
 
 @IBOutlet weak var embeddedView: IBEmbeddedView!
 }
 
 class NibInstantiatableTests: XCTestCase {
 
 func testInstantiate() {
     let view = NibView.lgf()
     view.label.text = "lgf"
 }
 
 func testInstantiateSecondaryView() {
     let view = SecondaryNibView.lgf()
     view.label.text = "lgf"
 }
 
 func testInstantiateSuperviewOfOwnerView() {
     let view = SuperviewOfEmbeddedView.lgf()
     view.embeddedView.embedded.label.text = "lgf"
 }
 }
 **/
