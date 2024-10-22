//
//  TestView.swift
//  WeiboUI
//
//  Created by app on 2022/11/25.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 39/255, green: 46/255, blue: 71/255).edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 0, content: {
                    VStack {
                        Text("付费会员卡").bold().padding(.bottom, 4)
                            .foregroundColor(Color(red: 231/255, green: 200/255, blue: 153/255))
                    }
                    
                    Spacer()
                    HStack(alignment: .bottom, spacing: 0) {
                        Text("3").bold().padding(.bottom, -4).font(.system(size: 24))
                         Text("天·9月27日到期").font(.system(size: 10))
                        // 空白区域填充，使文字居左
                        Spacer(minLength: 0)
                    }.foregroundColor(Color(red: 231/255, green: 200/255, blue: 153/255))
                }).padding().frame(height: 180).background(RadialGradient(
                    gradient: Gradient(
                        colors: [
                            Color(red: 56/255, green: 81/255, blue: 116/255),
                            Color(red: 39/255, green: 46/255, blue: 71/255),
                            Color(red: 231/255, green: 200/255, blue: 153/255),
                            Color(red: 39/255, green: 46/255, blue: 71/255),
                        ]
                    ),
                    center: .center,
                    startRadius: 2,
                    endRadius: 650)
                ).overlay(RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color(red: 231/255, green: 200/255, blue: 153/255), lineWidth: 1)).padding(.bottom, 520)
                
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack() {
                                Image(systemName: "infinity")
                                Text("付费会员卡").bold()
                            }.padding(.bottom, -5)
                            
                            Divider().overlay(Color.gray)
                            Text("全场出版书畅读")
                            Text("全场有声书畅听")
                            Text("书架无上限")
                            Text("离线下载无上限")
                            Text("时长可兑换体验卡和书币")
                            Text("专属阅读背景和字体")
                        }.padding().foregroundColor(Color(red: 231/255, green: 200/255, blue: 153/255))
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 20) {
                            HStack() {
                                Image(systemName: "infinity")
                                Text("体验卡")
                            }.padding(.bottom, -5)
                                Divider().overlay(Color.gray)
                                Text("部分出版书畅读")
                                Text("仅可收盘 AI 朗读")
                                Text("书架 500 本上限")
                                Text("每月可下载 3 本")
                                Text("仅可兑换体验卡")
                                Text("-")
                        }.padding().foregroundColor(Color.gray)
                    }.font(.system(size: 16))
                }.background(Color(red: 47/255, green: 54/255, blue: 77/255))
                    .cornerRadius(12)
            }.safeAreaInset(edge: .bottom) {
                
            }.navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
       TestView()
    }
}
