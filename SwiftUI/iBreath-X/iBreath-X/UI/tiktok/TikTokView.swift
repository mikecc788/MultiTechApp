//
//  TikTokView.swift
//  iBreath-X
//
//  Created by app on 2024/8/27.
//

import SwiftUI

struct TikTokView: View {
    // 使用一个变量来管理当前选中的按钮
    @State private var selectedTab: SelectedTab = .explorar
    @State private var isPressedMoreText: Bool = false
    var body: some View {
        VStack {
            HStack (spacing:15){
                HeaderImageButton(image: "4k.tv.fill")
                HeaderTextButton(title: "Explorar", isPressed: $selectedTab, currentTab: .explorar)
                HeaderTextButton(title: "Siguiendo", isPressed: $selectedTab,currentTab: .siguiendo)
                HeaderTextButton(title: "Para ti", isPressed: $selectedTab, currentTab:.paraTi)
                Spacer().frame(width: 16)
                HeaderImageButton(image: "magnifyingglass")
            }.frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 10)
                .padding(.horizontal, 2)
            Spacer()
            
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    TitleAndDescriptionFooter(isPressedMoreText: $isPressedMoreText, title: "Ivancito 😎", description: """
                                              Milieruistas de la semana
                                              Hoy vamos a hablar sobre las mejores canciones
                                              """)
                }.frame(width: 250, alignment: .leading)
                Spacer()
                VStack(alignment: .center,spacing: 20, content: {
                    ProfilePictureRightBar(image: "ivan")
                    CommentsRightBar()
                })
            }.padding(.horizontal,10)
            
            
        }.background(Image("fondo").resizable().scaledToFill().ignoresSafeArea()).frame(maxWidth: .infinity,alignment: .center)
    }
}

struct ProfilePictureRightBar: View {
    
    var image: String
    var body: some View {
        
        Image(image)
            .resizable()
            .scaledToFill()
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .overlay{
                Circle().stroke(.white, lineWidth: 1)
            }
            .overlay {
                Circle().fill(.pink)
                    .frame(width: 23, height: 23)
                    .offset(x: 0, y: 30)
                    .overlay {
                        Image(systemName: "plus")
                            .font(.system(size: 12))
                            .foregroundStyle(.white)
                            .offset(x: 0, y: 30)
                    }
            }
    }
}

struct CommentsRightBar: View {
    var body: some View {
        VStack {
            Image(systemName: "ellipsis.message.fill")
                .font(.system(size: 40))
                .foregroundStyle(.white)
                .scaleEffect(0.9)
            Text("2 mil")
                .font(.system(size: 14, weight: .bold,design: .rounded))
                .foregroundStyle(.white)
        }
    }
}
struct TitleAndDescriptionFooter: View {
    
    @Binding var isPressedMoreText: Bool
    
    var title: String
    var description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 18, weight: .bold,design: .rounded))
                .foregroundStyle(.white)
            HStack {
                Text(description)
                    .font(.system(size: 14, weight: .regular,design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(isPressedMoreText ? 5 : 2)
                Button {
                    isPressedMoreText.toggle()
                } label: { Text(isPressedMoreText ? "menos" : "más")
                        .font(.system(size: 14, weight: .bold,design: .rounded))
                        .foregroundStyle(.white)
                }
            }.animation(.easeInOut, value: isPressedMoreText)
        }
    }
}
struct HeaderTextButton: View {
    var title:String
    @Binding var isPressed: SelectedTab
    var currentTab: SelectedTab // 当前按钮的名称
    var body: some View {
        Text(title).font(.system(size: 18,weight: (isPressed == currentTab ? .bold : .regular ),design: .rounded)).foregroundStyle(isPressed == currentTab  ? .white : .gray).overlay {
            if isPressed == currentTab {
                Rectangle()
                    .fill(.white)
                    .frame(width: 30,height: 2)
                    .offset(y: 13)
            }
        }.onTapGesture {
            // 更新选中状态为当前按钮
            isPressed = currentTab
        }
    }
}
enum SelectedTab {
    case explorar
    case siguiendo
    case paraTi
}
#Preview {
    TikTokView()
}


