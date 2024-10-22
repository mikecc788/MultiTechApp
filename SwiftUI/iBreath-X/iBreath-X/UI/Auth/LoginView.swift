//
//  LoginView.swift
//  iBreath-X
//
//  Created by app on 2024/8/24.
//

import SwiftUI

struct LoginView: View {
    @State private var wakeUp = Date.now
    @EnvironmentObject private var appRootManager: AppRootManager
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Image("WechatIMG18").resizable().frame(width: 140, height: 140)
                
                Text("快捷登录").padding(.bottom, 20)
                HStack(alignment: .center, spacing: 30, content: {
                    Button(action: {
                        print("aaaaa")
                        appRootManager.currentRoot = .main
                    }) {
                        Image(systemName: "applelogo")
                    }
                    Button(action: {
                        print("bbbbb")
                        appRootManager.currentRoot = .main
                    }) {
                        Image("google")
                    }
                    Button(action: {
                        print("ccccc")
                        appRootManager.currentRoot = .main
                    }) {
                        Image("kakao")
                    }
                }).frame(maxWidth: .infinity)
                Spacer()
                NavigationLink(destination: SignUpView()) {
                    Text("Sign Up")
                        .foregroundColor(.blue)
                        .padding()
                }
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.darkBlue)
                    Button {
                        // TODO: PONER LA LOGICA DE CREAR UNA CUENTA
                    } label: {
                        Text("Log In")
                            .foregroundColor(.mainColor)
                    }
                }.padding()
                
            }
            .navigationTitle("Login")
            .background(MyColorScheme.bgColor).frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct SignUpView: View {
    var body: some View {
        Text("Sign Up View")
            .navigationTitle("Sign Up")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

#Preview {
    LoginView()
}
