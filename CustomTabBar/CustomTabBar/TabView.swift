//
//  TabView.swift
//  CustomTabBar
//
//  Created by app on 2022/12/29.
//

import SwiftUI

struct TabView: View {
    @State private var selectIndex = 0
    var body: some View {
        VStack {
            Text("aaa")
            AsyncImage(url: URL(string: "https://picsum.photos/200")) {image in
                image.resizable().frame(width:200,height: 300)
            } placeholder: {
                ProgressView()
            }

        }
        
    }
}

struct ChatListView:View{
    var body: some View{
        Text("Chat")
    }
    
}
struct AddressBookView:View{
    var body: some View{
        Text("Address")
    }
    
}
struct DiscoverView:View{
    var body: some View{
        Text("Discover")
    }
    
}
struct MineView:View{
    var body: some View{
        Text("Mine")
    }
    
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView()
    }
}
