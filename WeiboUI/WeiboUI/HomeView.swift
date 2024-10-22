//
//  HomeView.swift
//  WeiboUI
//
//  Created by app on 2022/11/28.
//

import SwiftUI

struct HomeView: View {
    @State private var leftPercent: CGFloat = 0
    
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().selectionStyle = .none
    }
    
//    ScrollView(.horizontal, showsIndicators: false) {
//        HStack {
//            PostListView(category: .recommend).frame(width:UIScreen.main.bounds.width)
//            PostListView(category: .hot).frame(width:UIScreen.main.bounds.width)
//        }
//    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                HScrollViewController(pageWidth: geometry.size.width, contentSize: CGSize(width: geometry.size.width * 2, height: geometry.size.height), leftPercent: self.$leftPercent) {
                    HStack {
                        PostListView(category: .recommend).frame(width:UIScreen.main.bounds.width)
                        PostListView(category: .hot).frame(width:UIScreen.main.bounds.width)
                    }
                }
            }.edgesIgnoringSafeArea(.bottom)
           .toolbar(content: {
               HomeNavigationBar(leftPercent: self.$leftPercent)
            }).navigationTitle("Home").navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserData())
    }
}
