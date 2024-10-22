//
//  ImageTextView.swift
//  iBreath-X
//
//  Created by app on 2024/8/28.
//

import SwiftUI
// 定义一个图文排列的方向枚举
enum ImageTextAlignment {
    case leftImage // 图左文右
    case rightImage // 图右文左
    case topImage // 图上文下
    case bottomImage // 图下文上
}
struct ImageTextView: View {
    var imageName: String
    var text: String
    var alignment: ImageTextAlignment // 排列方式
    var action: () -> Void // 点击事件
    
    var body: some View {
        Button (action: action){
            content
        }.buttonStyle(PlainButtonStyle()) // 去掉默认的按钮样式

    }
    
    // 根据排列方式生成不同的视图布局
    @ViewBuilder
    private var content:some View {
        switch alignment {
            case .leftImage:
                HStack {
                    Image(systemName: imageName)
                    Text(text)
                }
            case .rightImage:
                HStack {
                    Text(text).font(.system(size: 24))
                    Image(systemName: imageName)
                }
            case .topImage:
                VStack {
                    Image(systemName: imageName)
                    Text(text)
                }
            case .bottomImage:
                VStack {
                    Text(text)
                    Image(systemName: imageName)
                }
        }
    }
}

