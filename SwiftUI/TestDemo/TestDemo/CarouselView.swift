//
//  CarouselView.swift
//  TestDemo
//
//  Created by app on 2024/8/21.
//

import SwiftUI

struct CarouselView: View {
    @State private var currentIndex: Int = 0
    let cards = [
        Card(id: 0, color: .red, design: .designOne),
        Card(id: 1, color: .blue, design: .designTwo),
        Card(id: 2, color: .pink, design: .designThree),
        Card(id: 3, color: .blue, design: .designTwo),
        Card(id: 4, color: .pink, design: .designThree)
    ]
    
    var body: some View {
        VStack(alignment:.center) {
            TabView(selection: $currentIndex,
                    content:  {
                ForEach(cards) { card in
//                    card.color.frame(width: 300, height: 200).cornerRadius(10)
                    ZStack {
                        Image("00\(card.id+1)").resizable().scaledToFill().frame(width: 300,height: 200).cornerRadius(20)
                    }.tag(card.id)
                }
            }).tabViewStyle(PageTabViewStyle()).frame(height: 200)
            
            HStack(content: {
                ForEach(0..<cards.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.black : Color.red)
                        .frame(width: 8, height: 8)
                }
            }).padding(.top,10)
        }
    }
}
struct Card: Identifiable {
    var id: Int
    var color: Color
    var design: CardDesign
}

enum CardDesign {
    case designOne
    case designTwo
    case designThree
    // Add more designs as needed
}

#Preview {
    CarouselView()
}
