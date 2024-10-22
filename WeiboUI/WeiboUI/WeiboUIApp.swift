//
//  WeiboUIApp.swift
//  WeiboUI
//
//  Created by app on 2022/11/23.
//

import SwiftUI

@main
struct WeiboUIApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView().environmentObject(UserData())
        }
    }
}
