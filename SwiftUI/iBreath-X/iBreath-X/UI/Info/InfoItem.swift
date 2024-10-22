//
//  InfoItem.swift
//  iBreath-X
//
//  Created by app on 2024/8/23.
//

import Foundation
struct InfoItem :Identifiable,Hashable{
    let id = UUID()
    let title: String  // 菜单项的标题
    let imageName: String
    let type: Routes // 添加一个类型属性
}

struct InfoStore {
    static let infoItems: [InfoItem] = [
        InfoItem( title: "Public account", imageName: "组件", type: .publicAccount),
        InfoItem( title: "Official website", imageName: "国际化", type: .offical),
        InfoItem( title: "Health question", imageName: "帮助", type: .healthy),
    ]
}

enum InfoType {
    case publicAccount
    case offical
    case healthy
}
