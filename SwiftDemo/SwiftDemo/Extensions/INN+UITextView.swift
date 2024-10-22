//
//  INN+UITextView.swift
//  AudioLatencyTester
//
//  Created by chenliao on 2021/10/29.
//

import Foundation
import UIKit

public extension UITextView {
    // MARK: - 添加链接文本（链接为空时则表示普通文本）
    func inn_AppendLinkString(_ string:String, _ withURLString: String = "") {
        //原来的文本内容
        let attrString:NSMutableAttributedString = NSMutableAttributedString()
        attrString.append(self.attributedText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 12
        paragraphStyle.maximumLineHeight = 20
        //新增的文本内容（使用默认设置的字体样式）
        let attrs = [NSAttributedString.Key.font : self.font!, NSAttributedString.Key.paragraphStyle : paragraphStyle,NSAttributedString.Key.backgroundColor:string.hasPrefix(" ") ? UIColor.clear: UIColor.lightGray]
        let appendString = NSMutableAttributedString(string: string, attributes:attrs)
        //判断是否是链接文字
        if withURLString != "" {
            let range:NSRange = NSMakeRange(0, appendString.length)
            appendString.beginEditing()
            appendString.addAttribute(NSAttributedString.Key.link, value:withURLString, range:range)
            appendString.endEditing()
        }
        //合并新的文本
        attrString.append(appendString)
        //设置合并后的文本
        self.attributedText = attrString
    }
    
    // MARK: - 添加链接文本（链接为空时则表示普通文本）
    func inn_AppendLinkString(_ string:String, _ withURLString:String = "", _ backGroundColor: UIColor) {
        //原来的文本内容
        let attrString:NSMutableAttributedString = NSMutableAttributedString()
        attrString.append(self.attributedText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 12
        paragraphStyle.maximumLineHeight = 20
        let fontSize:CGFloat = self.font?.pointSize ?? 14.0
        self.font = UIFont(name: "PingFang SC", size: fontSize)
        //新增的文本内容（使用默认设置的字体样式）
        let attrs = [NSAttributedString.Key.font: self.font!, NSAttributedString.Key.paragraphStyle: paragraphStyle,NSAttributedString.Key.backgroundColor: backGroundColor]
        
        let appendString = NSMutableAttributedString(string: string, attributes:attrs)
        //判断是否是链接文字
        if withURLString != "" {
            let range:NSRange = NSMakeRange(0, appendString.length)
            appendString.beginEditing()
            appendString.addAttribute(NSAttributedString.Key.link, value:withURLString, range:range)
            appendString.endEditing()
        }
        //合并新的文本
        attrString.append(appendString)
        
        //设置合并后的文本
        self.attributedText = attrString
    }
}

