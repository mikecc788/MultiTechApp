//
//  ContentView.swift
//  CustomTabBar
//
//  Created by app on 2022/12/27.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewRouter: ViewRouter
    
    var body: some View {
        GeometryReader {geometry in
            VStack {
               
                Spacer()
                ZStack {
                    HStack {
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .home, width: geometry.size.width/5, height: geometry.size.height/32, systemIconName: "chart.pie.fill", tabName: "Home").frame(maxWidth: .infinity)
                        
                        TabBarIcon(viewRouter: viewRouter, assignedPage: .my,width: geometry.size.width/5, height: geometry.size.height/32,systemIconName: "person.crop.circle.fill", tabName: "我的").frame(maxWidth: .infinity)
                        
                    }.frame(width: geometry.size.width,height: geometry.size.height/9)
                }
            }.ignoresSafeArea(edges: .bottom)
        }
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewRouter: ViewRouter())
    }
}
