//
//  ListBackgroundModifier.swift
//  iBreath-X
//
//  Created by app on 2024/8/28.
//

import SwiftUI

// ViewModifier 是 SwiftUI 中的一个协议，它允许我们创建可以重用的、用于修改视图的方法。
struct ListBackgroundModifier: ViewModifier {
    @ViewBuilder
   func body(content: Content) -> some View {
       if #available(iOS 16.0, *) {
           content
               .scrollContentBackground(.hidden)
       } else {
           content
       }
   }
}


