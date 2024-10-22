//
//  ButtonView.swift
//  WeiboUI
//
//  Created by app on 2022/12/29.
//

import SwiftUI

struct ButtonView: View {
    var body: some View {
        VStack {
            ButtonStyle()
            ButtonTintColor()
        }
    }
}

struct ButtonStyle: View {
    var body: some View {
        Button(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/){
            
        }.buttonStyle(.bordered)
    }
}
struct ButtonTintColor: View {
    var body: some View {
        Button(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/){
            
        }.buttonStyle(.bordered).tint(.red)
    }
}
struct ButtonRole: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView()
    }
}
