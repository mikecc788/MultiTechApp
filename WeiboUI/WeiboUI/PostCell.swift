//
//  PostCell.swift
//  WeiboUI
//
//  Created by app on 2022/11/23.
//

import SwiftUI

struct PostCell: View {
    let post:Post
    @State var presentComment: Bool = false
    
    @EnvironmentObject var userData:UserData
    var bindingPost:Post{
        userData.post(forId: post.id)!
    }
    
    var body: some View {
        var post = bindingPost
        return VStack (alignment: .leading, spacing: 10){
            HStack(spacing: 5){
                post.avatarImage.resizable().scaledToFill().frame(width: 50, height: 50).clipShape(Circle()).overlay(PostVipBadge(vip: post.vip).offset(x: 16, y: 16))
                
                VStack(alignment: .leading, spacing: 5){
                    Text(post.name).font(Font.system(size: 20)).foregroundColor(Color.red).lineLimit(1)
                    Text(post.date).font(Font.system(size: 11))
                }.padding(.leading,10)
                
                if !post.isFollowed{
                    Spacer()
                    Button(action: {
                        debugPrint("click follow")
                        post.isFollowed = true
                        self.userData.update(post)
                    }){
                        Text("follow").font(Font.system(size: 18)).frame(width: 50, height: 26).overlay(RoundedRectangle(cornerRadius: 13).stroke(Color.orange))
                    }.buttonStyle(BorderlessButtonStyle())
                }
               
                
            }
            
            Text(post.text).font(.system(size: 17))
            if !post.images.isEmpty{
                PostImageCell(images: post.images, width: UIScreen.main.bounds.width-30)
            }
            Divider()
            
            HStack(spacing: 0){
                PostCellToolBarButton(image: "message", text: post.commentCountText, color: .black, action: {
                    print("comment")
                    self.presentComment = true
                }).buttonStyle(BorderlessButtonStyle()).sheet(isPresented: $presentComment) {
                    CommentInputView(post: post).environmentObject(self.userData)
                }
                Spacer()
                PostCellToolBarButton(image: post.isLiked ? "heart.fill" : "heart", text: post.likeCountText, color: post.isLiked ? .red : .black, action: {
                    print("like")
                    if post.isLiked {
                        post.isLiked = false
                        post.likeCount -= 1
                    }else{
                        post.isLiked = true
                        post.likeCount += 1
                    }
                    userData.update(post)
                }).buttonStyle(BorderlessButtonStyle())
                Spacer()
                
            }
            
            Rectangle().padding(.horizontal,-15)
                .frame(height:10).foregroundColor(.init(red: 238 / 255, green: 238 / 255, blue: 238 / 255))
            
        }.padding(.horizontal,15).padding(.top,15)
       
    }
}

struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        PostCell(post: userData.recommendPostList.list[0]).environmentObject(userData)
    }
}
