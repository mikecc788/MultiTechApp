//
//  SetView.swift
//  iBreath-X
//
//  Created by app on 2024/8/23.
//

import SwiftUI
import PopupView
struct SetView: View {
    @State private var isShowingPopup = false
    var body: some View {
        VStack {
            List {
                ForEach(SetStroe.menuItems){items in
                    Button (action: {
                        // 在这里添加点击每一行的动作
                        print("Clicked on \(items.title)")
                    }){
                        HStack {
                            Image(items.imageName)
                            Spacer().frame(width:20)
                            Text(items.title)
//                                Spacer()
                        }.padding(.vertical,10)
                    }
                }
            }.modifier(ListBackgroundModifier())
            Spacer()
            Button("Edit",action: {
                isShowingPopup = true
            }).popup(isPresented: $isShowingPopup, view: {
                Text("Heelll")
               .frame(width: 200, height: 60)
               .background(Color(red: 0.85, green: 0.8, blue: 0.95))
               .cornerRadius(30.0)
            },customize: {
                $0.position(.bottom).autohideIn(1)
            })
            
        }.padding().background(MyColorScheme.bgColor)
    }
}

#Preview {
    SetView()
}
