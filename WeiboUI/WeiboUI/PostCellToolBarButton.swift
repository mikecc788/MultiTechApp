//
//  PostCellToolBarButton.swift
//  WeiboUI
//
//  Created by app on 2022/11/25.
//

import SwiftUI

struct PostCellToolBarButton: View {
    
    let image:String
    let text:String
    let color:Color
    
    let action:()->Void//clousure
    
    var body: some View {
        Button(action: action){
            HStack{
                Image(systemName: image).resizable().scaledToFit().frame(width: 18, height: 18)
                Text(text).font(.system(size: 15))
            }
        }.foregroundColor(color)
    }
}

struct PostCellToolBarButton_Previews: PreviewProvider {
    static var previews: some View {
        PostCellToolBarButton(image: "heart", text: "点赞", color: .red){
            print("like")
        }
    }
}
