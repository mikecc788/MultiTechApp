//
//  IntroView.swift
//  iBreath-X
//
//  Created by app on 2024/8/22.
//

import SwiftUI

struct IntroView: View {
    @State private var currentPage: Int = 0
    @EnvironmentObject private var appRootManager: AppRootManager
    let pages = IntroItem.introStore;
    
    var body: some View {
        content.onAppear()
    }
    
    var content :some View{
        VStack {
            HStack{
                if currentPage > 0 {
                    Button {
                        if currentPage > 0 {
                            currentPage -= 1
                        } else if currentPage == 0 {
                            currentPage = 0
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.mainColor)
                            .bold()
                    }
                }
                
                Spacer()
                Button {
                    // TODO: PONER LA LOGICA para llevarlo a incio de sesion
                    
                    appRootManager.currentRoot = .login
                } label: {
                    Text("Skip")
                        .foregroundColor(.mainColor)
                }
            }
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 250, height: 250)
                .foregroundColor(.textFieldColor)
            
            HStack {
                ForEach(pages.indices,id: \.self){index in
                    if index == currentPage {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 20, height: 10)
                            .foregroundColor(.mainColor)
                    }else {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(.textFieldColor)
                    }
                }
            }
            
            Spacer().frame(height: 50)
            Text(pages[currentPage].title)
                .font(.system(size: 32,weight: .bold, design: .rounded))
                .foregroundColor(.darkBlue)
            Text(pages[currentPage].description)
                .font(.system(size: 18,weight: .medium, design: .rounded))
                .foregroundColor(.darkBlue)
                .padding(10)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            Spacer()
            Button {
                if currentPage < pages.count - 1 {
                    currentPage += 1
                } else {
                    // TODO: PONER LA LOGICA para llevarlo a incio de sesion
                }
            } label: {
                Text(pages[currentPage].buttonTitle)
                    .foregroundStyle(.white)
                    .font(.system(size: 16, design: .rounded))
            }
            .defaultButtonStyle()
        }.padding().animation(.bouncy,value: currentPage).gesture(DragGesture().onEnded({   value in
            if value.translation.width < -50 {
                print("Swipe left")
                withAnimation {
                    if currentPage < pages.count - 1 {
                        currentPage += 1
                    }
                }
            }else if value.translation.width > 50 {
                // deslizo a la derecha
                print("Swipe right")
                withAnimation {
                    if currentPage > 0 {
                        currentPage -= 1
                    }
                }
                
            }
        }))
    }
    
}

#Preview {
    IntroView()
}


