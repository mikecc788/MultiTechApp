//
//  CardView.swift
//  WeiboUI
//
//  Created by app on 2022/12/29.
//

import SwiftUI

struct CardView: View {
    var emojis = ["🛬","🚗","🚚","🚛","🚜","🚑","🚞","🚁","🚀","🚢"]
    @State var emojiCount = 7
    
    var body: some View {
        VStack {
            HStack {
                
                ForEach(emojis[0..<emojiCount] , id: \.self) { emoji in
                    CardTestView(content: emoji)
                }
                
    //            CardTestView(content: emojis[0])
    //            CardTestView(content:emojis[1])
    //            CardTestView(content:emojis[2])
    //            CardTestView(content:emojis[3])
            }
            HStack{
                Button {
                    emojiCount -= 1
                } label: {
                    VStack {
                        Text("Remove")
                        Text("Card")
                    }
                }
                Spacer()
                Button {
                    emojiCount += 1
                } label: {
                    VStack {
                        Text("Add")
                        Text("Card")
                    }
                }
                
               
            }.padding(.horizontal)
          

        }.padding(.horizontal).foregroundColor(.red)
    }
}

struct CardTestView:View {
    var content:String
    @State var isFaceUp:Bool = true
    var body: some View{
        ZStack {
            var shape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp{
                shape.fill().foregroundColor(.white)
                shape.stroke(lineWidth: 3)
                Text(content)
                .font(.largeTitle)
            }else{
                shape.fill()
            }
        }.onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
            .preferredColorScheme(.light)
    }
}
