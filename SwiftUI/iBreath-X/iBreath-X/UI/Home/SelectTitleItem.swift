//
//  SelectItem.swift
//  iBreath-X
//
//  Created by app on 2024/8/28.
//

import SwiftUI
//使用 CaseIterable 时，这个枚举就可以通过自动生成的 allCases 属性来获得所有枚举的值（案例）
enum HomeTitleTab :CaseIterable{
    case all
    case sort
    
    var title: String {
            switch self {
            case .all:
                return "All"
            case .sort:
                return "Sort"
            }
        }
    
}

struct HomeTitleItem: View {
    @Binding var isPressed: HomeTitleTab
    var body: some View {
        GeometryReader { geo in
            HStack (spacing:30){
                Spacer()
                ForEach(HomeTitleTab.allCases,id: \.self){tab in
                    VStack (spacing:5) {
                        Text(tab.title).font(.system(size: 16)).bold().foregroundStyle(isPressed == tab ? .blue : .brown).onTapGesture {
    //                        withAnimation {
    //                            
    //                        }
                            isPressed = tab
                        }
                        
                        if isPressed == tab {
                            RoundedRectangle(cornerRadius: 2)
                            .foregroundColor(.blue)
                            .frame(width: 40, height: 4)
                            .transition(.move(edge: .bottom))
                        }else {
                            Color.clear.frame(height: 4)
                        }
                    }
                   
                }
                Spacer()
            }.frame(width: geo.size.width)
        }
    }
}

#Preview {
    HomeTitleItem(isPressed: .constant(.all))
}

struct SelectItem: View {
    var title:String
    @Binding var isPressed: HomeTitleTab
    var currentTab: HomeTitleTab // 当前按钮的名称
    var body: some View {
        GeometryReader(content: { geometry in
            Text(title).font(.system(size: 18,weight: (isPressed == currentTab ? .bold : .regular ),design: .rounded)).foregroundStyle(isPressed == currentTab  ? Color.mainColor : .black).overlay {
                if isPressed == currentTab {
                    Rectangle()
                        .fill(.gray)
                        .frame(width: geometry.size.width,height: 2)
                        .offset(y: 13)
                }
            }.onTapGesture {
                // 更新选中状态为当前按钮
                isPressed = currentTab
            }
        }).frame(height: 30)
    }
}
