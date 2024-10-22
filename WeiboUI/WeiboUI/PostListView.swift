//
//  PostListView.swift
//  WeiboUI
//
//  Created by app on 2022/11/25.
//

import SwiftUI

struct PostListView: View {
    
    let category:PostListCategory
    
    @EnvironmentObject var userData:UserData
    

    var body: some View {
//        List(postList.list,id:\.id){ post in
//            PostCell(post: post).listRowInsets(EdgeInsets())
//        }
        
        List{
            ForEach(userData.postList(for: category).list ,id:\.id){ post in
                ZStack {
                    PostCell(post: post)
                    NavigationLink(destination: PostDetailView(post: post)){
                        EmptyView()
                    }.hidden()
                }.listRowInsets(EdgeInsets())
               
            }
            
        }
        
    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PostListView(category: .recommend).environmentObject(UserData()).navigationTitle("Title").navigationBarHidden(true)
        }
    }
}
