//
//  ProfileItem.swift
//  iBreath-X
//
//  Created by app on 2024/8/23.
//

import SwiftUI
import SwiftData

//Identifiable 是一个协议，它的主要作用是为集合中的每个元素提供唯一标识 SwiftUI 使用这个唯一标识来高效地更新视图。通过遵循 Identifiable 协议，SwiftUI 能够跟踪数据源中的每个元素，从而只更新那些需要更新的部分，而不是整个视图
struct ProfileItem:Identifiable {
    let id:Int  // 为了使每个模型在ForEach中唯一标识
    let title: String  // 菜单项的标题
    let imageName: String  // 菜单项的图片名称
    let type : MyRoutes
    
}


final class SetItem :ObservableObject, Identifiable{
    @Published var title: String  // 菜单项的标题
    @Published var imageName: String  // 菜单项的图片名称
    init(title: String, imageName: String) {
        self.title = title
        self.imageName = imageName
    }
}
