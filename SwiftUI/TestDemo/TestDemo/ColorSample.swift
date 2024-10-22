//
//  ColorSample.swift
//  TestDemo
//
//  Created by app on 2024/8/20.
//

import SwiftUI

struct ColorSample: View {
    var color = #colorLiteral(red: 0, green: 0.8470588235, blue: 0.6431372549, alpha: 1)

    var body: some View {
//        RoundedRectangle(cornerRadius: 25.0)
//                   .fill(Color(color))
//                   .frame(width: 100, height: 100)
        
//        HStack (spacing:0){
//            Rectangle().fill(.red).frame(width: UIScreen.main.bounds.width * 0.8)
//            Rectangle().fill(Color.blue)
//        }.ignoresSafeArea()
        
        VStack{
            ScrollView (.horizontal,showsIndicators: false) {
                HStack{
                    ForEach(0..<5) { i in
                        GeometryReader { geo in
                            Image("00\(i+1)").resizable().scaledToFill().frame(width: 300,height: 200).cornerRadius(20).rotation3DEffect(
                                Angle(degrees: getPercentage(geo: geo) * 40), axis: (x: 0.0, y: 1.0, z: 0.0))
                        }.frame(width: 300,height: 200).padding()
                    }
                }
            }
            Spacer()
        }
    }
}

func getPercentage(geo:GeometryProxy) -> Double {
    let maxDistance = UIScreen.main.bounds.width / 2
    let currentX = geo.frame(in: .global).midX
    return Double(1 - (currentX / maxDistance))
}
#Preview {
    ColorSample()
}
