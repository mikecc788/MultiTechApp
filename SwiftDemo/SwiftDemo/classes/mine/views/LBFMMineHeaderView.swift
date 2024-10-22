//
//  LBFMMineHeaderView.swift
//  SwiftDemo
//
//  Created by chenliao on 2021/12/29.
//

import UIKit

/// 添加按钮点击代理方法
protocol LBFMMineHeaderViewDelegate:NSObjectProtocol {
    func shopBtnClick(tag:Int)
}

class LBFMMineHeaderView: UIView {
    weak var delegate : LBFMMineHeaderViewDelegate?
    
    /// 上下浮动的vip标签view
    private lazy var animationView:LBFMVipAnimationView = {
        let view = LBFMVipAnimationView()
        return view
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setUpLayout()
        setUpShopView()
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpLayout(){
        
        self.addSubview(self.animationView)
        self.animationView.layer.masksToBounds = true
        self.animationView.layer.cornerRadius = 10
        self.animationView.snp.makeConstraints { (make) in
            make.width.equalTo(120)
            make.height.equalTo(80)
            make.top.equalTo(120)
            make.right.equalToSuperview().offset(-20)
        }
        /// vip动画view的旋转角度
        self.animationView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 12)
    }
    
    /// 开始动画
    func setAnimationViewAnimation(){
        let yorig:CGFloat = 100.0 + 64
        let opts: UIView.AnimationOptions = [.autoreverse , .repeat]
        UIView.animate(withDuration: 1, delay: 1, options: opts, animations: {
            self.animationView.center.y -= 20
        }) { _ in
            self.animationView.center.y = yorig
        }
    }
    // 停止动画
    func stopAnimationViewAnimation(){
        self.animationView.layer.removeAllAnimations()
    }
    
    func setUpShopView(){
        
    }
}
