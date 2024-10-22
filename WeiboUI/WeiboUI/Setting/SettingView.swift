//
//  SettingView.swift
//  WeiboUI
//
//  Created by app on 2022/12/26.
//

import SwiftUI

private var backToMineView:some View{
    Button {
        
    } label: {
        Image(systemName: "arrow.backward").foregroundColor(.black)
    }

}
// 个人信息
private var mineMessageView: some View {
    Button {
        
    } label: {
        HStack{
            Image(uiImage: UIImage(named: "d0c21786ly8fsax1ftiifj20ro0ro43g.jpg")!).resizable().aspectRatio(contentMode: .fit).frame(width: 60).clipShape(Circle()).overlay(Circle().stroke(Color(.systemGray5),lineWidth: 2))
            VStack{
                Text("Last").font(.system(size: 17)).foregroundColor(.black)
                Text("CEOO").font(.system(size: 14)).foregroundColor(.gray)
            }
        }.padding(.vertical,10)
    }
        
}
// MARK: 栏目结构
struct listItemView: View {
    var itemImage: String
    var itemName: String
    var itemContent: String
    var body: some View {
        Button {
            
        } label: {
            HStack{
                Image(systemName: itemImage).font(.system(size: 17)).foregroundColor(.black)
                Text(itemName).foregroundColor(.black).font(.system(size: 17))
                Spacer()
                Text(itemContent).font(.system(size: 14)).foregroundColor(.gray)
            }.padding(.vertical,15)
            
        }

    }
}
private var signOutView: some View {
    Button {
        
    } label: {
        Text("退出登录").font(.system(size: 17)).frame(minWidth: 0,maxWidth: .infinity).foregroundColor(.red).cornerRadius(8).padding(.vertical,10)
    }

}
struct SettingView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 246 / 255, green: 246 / 255, blue: 246 / 255).edgesIgnoringSafeArea(.all)
                Form{
                    Section(header: Text("User Info")) {
                        mineMessageView
                    }
                    Section {
                        listItemView(itemImage: "lock", itemName: "账号绑定", itemContent: "已绑定")
                        listItemView(itemImage: "gear.circle", itemName: "通用设置", itemContent: "")
                        listItemView(itemImage: "briefcase", itemName: "简历管理", itemContent: "未上传")
                        listItemView(itemImage: "icloud.and.arrow.down", itemName: "版本更新", itemContent: "Version 6.2.8")
                        listItemView(itemImage: "leaf", itemName: "清理缓存", itemContent: "0.00MB")
                        listItemView(itemImage: "person", itemName: "关于掘金", itemContent: "")
                    }
                    Section{
                        signOutView
                    }
                }
            }.navigationTitle("设置").navigationBarTitleDisplayMode(.inline).toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    backToMineView
                }
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
