//
//  INN+UILabel.swift
//  AudioLatencyTester
//
//  Created by chenliao on 2021/10/29.
//

import UIKit

extension UILabel {
    /**
     封装的UILabel 初始化
     
     - parameter frame:      大小位置
     - parameter textString: 文字
     - parameter font:       字体
     - parameter textColor:  字体颜色
     
     - returns: UILabel
     */
    public class func getLabel(frame:CGRect? = nil, textString:String? = nil, font:UIFont, textColor:UIColor? = nil) -> UILabel {
        let aLabel = UILabel()
        aLabel.backgroundColor = UIColor.clear
        aLabel.text = textString
        aLabel.font = font
        aLabel.textColor = textColor
        if let frame = frame {
            aLabel.frame = frame
        }
        return aLabel
    }
}
