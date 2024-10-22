//
//  TabBarView.swift
//  WhyNotTry
//
//  Created by app on 2024/1/20.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        NavigationStack {
            TabView {
                HomeView().tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                InfoView().tabItem {
                    Image(systemName: "info.circle")
                    Text("Info")
                }
                
            }.navigationTitle("")
        }
    }
}

#Preview {
    TabBarView()
}
