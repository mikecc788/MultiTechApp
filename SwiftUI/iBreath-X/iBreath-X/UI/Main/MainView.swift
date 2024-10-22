//
//  MainView.swift
//  iBreath-X
//
//  Created by app on 2024/8/22.
//

import SwiftUI

struct MainView: View {
    
    
    var body: some View {
        
        ExtractedView()
    }
}

#Preview {
    MainView()
}


struct ExtractedView: View {
    @State private var selectedTab: TabType = .home

    var body: some View {
        TabView(selection:$selectedTab){
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: TabType.home.image)
                    Text(TabType.home.title)
                }.tag(TabType.home)
            InfoView()
                .tabItem {
                    Image(systemName:TabType.info.image)
                    Text(TabType.info.title)
                }.tag(TabType.info)
            
            ProfileView()
                .tabItem {
                    Image(systemName: TabType.profile.image)
                    Text(TabType.profile.title)
                }.ignoresSafeArea().tag(TabType.profile)
        }.tint(Color.red).onAppear{
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5)
            UITabBarItem.appearance().setBadgeTextAttributes([.foregroundColor: UIColor.red, .font: UIFont.boldSystemFont(ofSize: 14)], for: .normal)
            UITabBarItem.appearance().setBadgeTextAttributes([.foregroundColor: UIColor.blue], for: .selected)
            UITabBar.appearance().unselectedItemTintColor = .systemBrown

        }
    }
}

/**
struct ExtractedTestView: View {
    @State private var selectedTab = 0
    var body: some View {
        VStack{
            TabView(selection: $selectedTab,
                    content:  {
                HomeView().tag(0)
                InfoView().tag(1)
                ProfileView().tag(2)
            }).tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Custom Tab Bar
            VStack {
                HStack {
                    Button(action: {
                        selectedTab = 0
                    }) {
                        VStack {
                            Image(selectedTab == 0 ? "homeGray" : "home").resizable().scaledToFit()
                            Text("Home").foregroundColor(selectedTab == 0 ? .blue : .gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    Button(action: {
                        selectedTab = 1
                    }) {
                        VStack {
                            Image(selectedTab == 1 ? "discoverGray" : "discover").resizable().scaledToFit()
                            Text("Settings").foregroundColor(selectedTab == 1 ? .blue : .gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Button(action: {
                        selectedTab = 2
                    }) {
                        VStack {
                            Image(selectedTab == 2 ? "myGray" : "my").resizable().scaledToFit()
                            Text("Profile").foregroundColor(selectedTab == 2 ? .blue : .gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }.padding().frame(height: 70).background(Color(hex: "E6E6FA"))
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
}
 */
