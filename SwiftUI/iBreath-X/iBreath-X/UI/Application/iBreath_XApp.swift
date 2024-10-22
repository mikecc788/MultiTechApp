//
//  iBreath_XApp.swift
//  iBreath-X
//
//  Created by app on 2024/8/22.
//

import SwiftUI
import SwiftData

@main
struct iBreath_XApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    let persistenceController = PersistenceController.shared
    
    @StateObject private var appRootManager = AppRootManager()
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appRootManager.currentRoot{
                case .intro:
                    IntroView()
                    
                case .main:
                    MainView()
                case .login:
                    LoginView()
                }
            }.environmentObject(appRootManager)
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
