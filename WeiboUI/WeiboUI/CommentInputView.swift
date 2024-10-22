//
//  CommentInputView.swift
//  WeiboUI
//
//  Created by app on 2022/11/30.
//

import SwiftUI

struct CommentInputView: View {
    let post:Post
    @State private var text:String = ""
    @EnvironmentObject var userData: UserData
    @Environment(\.presentationMode) var presentationMode
     
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    var body: some View {
        VStack(spacing:0){
            CommentTextView(text: $text, beginEditingOnAppear: true)
            HStack(spacing: 0){
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel").padding()
                }
                Spacer()
                Button {
                    print(self.text)
                    var post = self.post
                    post.commentCount += 1
                    self.userData.update(post)
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Send").padding()
                }

            }.font(.system(size: 18)).foregroundColor(.black)
        }.overlay {
            Text("评论不能为空")
        }.padding(.bottom,keyboardResponder.keyboardheight).edgesIgnoringSafeArea(keyboardResponder.keyboardShow ? .bottom :[])
        
    }
}

struct CommentInputView_Previews: PreviewProvider {
    static var previews: some View {
        CommentInputView(post: UserData().recommendPostList.list[0])
    }
}
