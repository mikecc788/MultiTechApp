//
//  PostVipBadge.swift
//  WeiboUI
//
//  Created by app on 2022/11/23.
//

import SwiftUI

struct PostVipBadge: View {
    let vip:Bool
    var body: some View {
        Group{
            if(vip){
                Text("V").frame(width: 15, height: 15).foregroundColor(Color.yellow).background(Color.red).clipShape(Circle()).overlay(RoundedRectangle(cornerRadius: 7.5).stroke(Color.white))
            }
        }
        
       
    }
}

struct PostVipBadge_Previews: PreviewProvider {
    static var previews: some View {
        PostVipBadge(vip: true)
    }
}
