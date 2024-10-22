//
//  PostDetailView.swift
//  WeiboUI
//
//  Created by app on 2022/11/25.
//

import SwiftUI

struct PostDetailView: View {
    let post:Post
    var body: some View {
        List{
            PostCell(post: post).listRowInsets(EdgeInsets())
            
            ForEach(1...10,id: \.self){i in
                Text("comment\(i)")
            }
        }.navigationBarTitleDisplayMode(.inline).navigationTitle("Detail")
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        PostDetailView(post: userData.recommendPostList.list[0]).environmentObject(userData)
    }
}
