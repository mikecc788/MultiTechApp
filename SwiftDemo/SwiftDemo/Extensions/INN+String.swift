//
//  INN+String.swift
//  AudioLatencyTester
//
//  Created by chenliao on 2021/10/29.
//

import UIKit

public extension String{
    // MARK: - 去除特殊字符
    func clearSpecialChar() -> String{
        let pattern: String = "[^a-zA-Z0-9\u{4e00}-\u{9fa5}]"
        let express = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        return express.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.count), withTemplate: "")
    }
    // MARK: - 判断字符串中有没有中文字符
    func isIncludeChinese() -> Bool {
        for ch in self.unicodeScalars {
            // 中文字符范围：0x4e00 ~ 0x9fff
            if (0x4e00 < ch.value  && ch.value < 0x9fff) {
                return true
            }
        }
        return false
    }
    // MARK: - 获取拼音首字母（大写字母）
    func getPinyinHead() -> String {
        // 字符串转换为首字母大写
        let pinyin = inn_TransformToPinyin().capitalized
        return pinyin.first?.description ?? ""
    }
    // MARK: - 获取汉字拼音
    private func inn_TransformToPinyin() -> String {
        if isIncludeChinese() {
            let stringRef = NSMutableString(string: self) as CFMutableString
            // 转换为带音标的拼音
            CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false);
            // 去掉音标
            CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false);
            var pinyin = stringRef as String;
            // 去掉空格
            pinyin = pinyin.replacingOccurrences(of: " ", with: "")
            return pinyin
        } else {
            return self
        }
    }
    
    // MARK: - 是否为空
    func inn_isNull() -> Bool {
        let str: String = self.trimmingCharacters(in: .whitespaces)
        if str.count == 0 {
            return true
        } else {
            return false
        }
    }
    // MARK: - 获取字符串宽度
    func getStrWidth(_ font: UIFont, _ height: CGFloat) -> CGFloat {
        return self.lgf_TextSizeWithFont(font: font, constrainedToSize:CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: height)).width + 1.0
    }
    // MARK: - 获取字符串 size
    private func lgf_TextSizeWithFont(font: UIFont, constrainedToSize size:CGSize) -> CGSize {
        var textSize:CGSize!
        if size.equalTo(CGSize.zero) {
            let attributes = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
            textSize = self.size(withAttributes: attributes as? [NSAttributedString.Key : Any])
        } else {
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            let attributes = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
            let stringRect = self.boundingRect(with: size, options: option, attributes: attributes as? [NSAttributedString.Key : Any], context: nil)
            textSize = stringRect.size
        }
        return textSize
    }
}

// MARK: - 正则表达式
public extension String {
    /**
     1、匹配中文:[\u4e00-\u9fa5]
     
     2、英文字母:[a-zA-Z]
     
     3、数字:[0-9]
     
     4、匹配中文，英文字母和数字及下划线：^[\u4e00-\u9fa5_a-zA-Z0-9]+$
     同时判断输入长度：
     [\u4e00-\u9fa5_a-zA-Z0-9_]{4,10}
     
     5、
     (?!_)　　不能以_开头
     (?!.*?_$)　　不能以_结尾
     [a-zA-Z0-9_\u4e00-\u9fa5]+　　至少一个汉字、数字、字母、下划线
     $　　与字符串结束的地方匹配
     
     6、只含有汉字、数字、字母、下划线，下划线位置不限：
     ^[a-zA-Z0-9_\u4e00-\u9fa5]+$
     
     7、由数字、26个英文字母或者下划线组成的字符串
     ^\w+$
     
     8、2~4个汉字
     "^[\u4E00-\u9FA5]{2,4}$";
     
     9、最长不得超过7个汉字，或14个字节(数字，字母和下划线)正则表达式
     ^[\u4e00-\u9fa5]{1,7}$|^[\dA-Za-z_]{1,14}$
     
     
     10、匹配双字节字符(包括汉字在内)：[^x00-xff]
     评注：可以用来计算字符串的长度（一个双字节字符长度计2，ASCII字符计1）
     
     11、匹配空白行的正则表达式：ns*r
     评注：可以用来删除空白行
     
     12、匹配HTML标记的正则表达式：<(S*?)[^>]*>.*?|<.*? />
     评注：网上流传的版本太糟糕，上面这个也仅仅能匹配部分，对于复杂的嵌套标记依旧无能为力
     
     13、匹配首尾空白字符的正则表达式：^s*|s*$
     评注：可以用来删除行首行尾的空白字符(包括空格、制表符、换页符等等)，非常有用的表达式
     
     14、匹配Email地址的正则表达式：^[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$
     
     评注：表单验证时很实用
     
     15、手机号：^((13[0-9])|(14[0-9])|(15[0-9])|(17[0-9])|(18[0-9]))\d{8}$
     
     16、身份证：(^\d{15}$)|(^\d{17}([0-9]|X|x)$)
     
     17、匹配网址URL的正则表达式：[a-zA-z]+://[^s]*
     评注：网上流传的版本功能很有限，上面这个基本可以满足需求
     
     18、匹配帐号是否合法(字母开头，允许5-16字节，允许字母数字下划线)：^[a-zA-Z][a-zA-Z0-9_]{4,15}$
     评注：表单验证时很实用
     
     
     19、匹配国内电话号码：d{3}-d{8}|d{4}-d{7}
     评注：匹配形式如 0511-4405222 或 021-87888822
     
     20、匹配腾讯QQ号：[1-9][0-9]{4,}
     评注：腾讯QQ号从10000开始
     
     21、匹配中国邮政编码：[1-9]d{5}(?!d)
     评注：中国邮政编码为6位数字
     
     22、匹配身份证：d{15}|d{18}
     评注：中国的身份证为15位或18位
     
     23、匹配ip地址：d+.d+.d+.d+
     评注：提取ip地址时有用
     
     
     24、匹配特定数字：
     ^[1-9]d*$　 　 //匹配正整数
     ^-[1-9]d*$ 　 //匹配负整数
     ^-?[1-9]d*$　　 //匹配整数
     ^[1-9]d*|0$　 //匹配非负整数（正整数 + 0）
     ^-[1-9]d*|0$　　 //匹配非正整数（负整数 + 0）
     ^[1-9]d*.d*|0.d*[1-9]d*$　　 //匹配正浮点数
     ^-([1-9]d*.d*|0.d*[1-9]d*)$　 //匹配负浮点数
     ^-?([1-9]d*.d*|0.d*[1-9]d*|0?.0+|0)$　 //匹配浮点数
     ^[1-9]d*.d*|0.d*[1-9]d*|0?.0+|0$　　 //匹配非负浮点数（正浮点数 + 0）
     ^(-([1-9]d*.d*|0.d*[1-9]d*))|0?.0+|0$　　//匹配非正浮点数（负浮点数 + 0）
     评注：处理大量数据时有用，具体应用时注意修正
     
     
     25、匹配特定字符串：
     ^[A-Za-z]+$　　//匹配由26个英文字母组成的字符串
     ^[A-Z]+$　　//匹配由26个英文字母的大写组成的字符串
     ^[a-z]+$　　//匹配由26个英文字母的小写组成的字符串
     ^[A-Za-z0-9]+$　　//匹配由数字和26个英文字母组成的字符串
     ^w+$　　//匹配由数字、26个英文字母或者下划线组成的字符串
     
     26、
     在使用RegularExpressionValidator验证控件时的验证功能及其验证表达式介绍如下:
     只能输入数字：“^[0-9]*$”
     只能输入n位的数字：“^d{n}$”
     只能输入至少n位数字：“^d{n,}$”
     只能输入m-n位的数字：“^d{m,n}$”
     只能输入零和非零开头的数字：“^(0|[1-9][0-9]*)$”
     只能输入有两位小数的正实数：“^[0-9]+(.[0-9]{2})?$”
     只能输入有1-3位小数的正实数：“^[0-9]+(.[0-9]{1,3})?$”
     只能输入非零的正整数：“^+?[1-9][0-9]*$”
     只能输入非零的负整数：“^-[1-9][0-9]*$”
     只能输入长度为3的字符：“^.{3}$”
     只能输入由26个英文字母组成的字符串：“^[A-Za-z]+$”
     只能输入由26个大写英文字母组成的字符串：“^[A-Z]+$”
     只能输入由26个小写英文字母组成的字符串：“^[a-z]+$”
     只能输入由数字和26个英文字母组成的字符串：“^[A-Za-z0-9]+$”
     只能输入由数字、26个英文字母或者下划线组成的字符串：“^w+$”
     验证用户密码:“^[a-zA-Z]w{5,17}$”正确格式为：以字母开头，长度在6-18之间，
     只能包含字符、数字和下划线。
     验证是否含有^%&',;=?$"等字符：“[^%&',;=?$x22]+”
     只能输入汉字：“^[u4e00-u9fa5],{0,}$”
     验证Email地址：“^w+[-+.]w+)*@w+([-.]w+)*.w+([-.]w+)*$”
     验证InternetURL：“^http://([w-]+.)+[w-]+(/[w-./?%&=]*)?$”
     验证身份证号（15位或18位数字）：“^d{15}|d{}18$”
     验证一年的12个月：“^(0?[1-9]|1[0-2])$”正确格式为：“01”-“09”和“1”“12”
     验证一个月的31天：“^((0?[1-9])|((1|2)[0-9])|30|31)$”
     正确格式为：“01”“09”和“1”“31”。
     匹配中文字符的正则表达式： [u4e00-u9fa5]
     匹配双字节字符(包括汉字在内)：[^x00-xff]
     匹配空行的正则表达式：n[s| ]*r
     匹配HTML标记的正则表达式：/<(.*)>.*|<(.*) />/
     匹配首尾空格的正则表达式：(^s*)|(s*$)
     匹配Email地址的正则表达式：w+([-+.]w+)*@w+([-.]w+)*.w+([-.]w+)*
     匹配网址URL的正则表达式：http://([w-]+.)+[w-]+(/[w- ./?%&=]*)?
     */
    func inn_NSPredicate(_ reg: String) -> Bool {
        let pre = NSPredicate(format: "SELF MATCHES %@", reg)
        if pre.evaluate(with: self) {
            return true
        } else {
            return false
        }
    }
    
    /// 以下这几种情况都认为的空
    func isEmptyString(str: String?) -> Bool {
        if str == nil {
            return true
        } else if (str == "") {
            return true
        } else if (str == "<null>") {
            return true
        } else if (str == "(null)") {
            return true
        } else if (str == "null") {
            return true
        }
        return false
    }
}
