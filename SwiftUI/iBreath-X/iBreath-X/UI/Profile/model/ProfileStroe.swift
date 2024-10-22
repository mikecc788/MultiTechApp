//
//  ProfileStroe.swift
//  iBreath-X
//
//  Created by app on 2024/8/23.
//

import Foundation
//菜单数组是动态需要更新的情况
/**
@Observable
class ProfileStroe {
    // 定义菜单项数组
   let menuItems: [ProfileItem] = [
    ProfileItem(title: "Search History", imageName: "magnifyingglass"),
    ProfileItem(title: "Review History", imageName: "clock"),
    ProfileItem(title: "Settings", imageName: "gear")
   ]
}
 */

// 2. 创建一个静态数组存储所有菜单项
struct ProfileStroe {
    static let menuItems: [ProfileItem] = [
        ProfileItem(id: 1, title: "Search History", imageName: "路径 2", type: .searchHistory),
        ProfileItem(id: 2, title: "Review History", imageName: "路径 3", type: .reviewHistory),
        ProfileItem(id: 3, title: "Settings", imageName: "路径 4", type: .settings)
    ]
}

struct SetStroe {
    static let menuItems: [SetItem] = [
        SetItem( title: "Devices updates", imageName: "路径 5"),
        SetItem( title: "Country/Region", imageName: "路径 6"),
        SetItem( title: "Language", imageName: "路径 7"),
        SetItem( title: "About", imageName: "路径 8"),
        SetItem( title: "Delete Account", imageName: "路径 9")
    ]
}
