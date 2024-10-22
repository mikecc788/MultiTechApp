//
//  HomeNavigationBar.swift
//  WeiboUI
//
//  Created by app on 2022/11/28.
//

import SwiftUI
private let kLabelWidth: CGFloat = 60
private let kButtonHeight: CGFloat = 24
struct HomeNavigationBar: View {
    @Binding var leftPercent: CGFloat
    var body: some View {
        
        HStack (alignment: .top, spacing: 0){
            Button {
                print("Click camera button")
            } label: {
                Image(systemName: "camera")
                    .resizable()
                    .scaledToFit()
                    .frame(width: kButtonHeight, height: kButtonHeight)
                    .padding(.horizontal, 15)
                    .padding(.top, 0)
                    .foregroundColor(.black)
            }
            Spacer()
            
            VStack (spacing:3){
                HStack(spacing:0) {
                    withAnimation {
                        Text("推荐").bold().frame(width: kLabelWidth, height: kButtonHeight, alignment: .center).onTapGesture {
                            self.leftPercent = 0
                        }
                    }
                    Spacer()
                    Text("热门").bold().frame(width: kLabelWidth, height: kButtonHeight, alignment: .center)
                }.font(.system(size: 20)).onTapGesture {
                    self.leftPercent = 1
                }
                
    //            GeometryReader { geometry in
    //                RoundedRectangle(cornerRadius: 2).foregroundColor(.orange).frame(width: 30, height: 4).offset(x: geometry.size.width * (self.leftPercent - 0.5) + kLabelWidth * (0.5 - self.leftPercent))
    //            }.frame(height:6)
                
                RoundedRectangle(cornerRadius: 2).foregroundColor(.orange).frame(width: 30, height: 4).offset(x: UIScreen.main.bounds.width * 0.5 * (self.leftPercent - 0.5) + kLabelWidth * (0.5 - self.leftPercent)).frame(height:6)
            }.frame(width: UIScreen.main.bounds.width * 0.5)
            Spacer()
            Button {
                print("Click camera button")
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: kButtonHeight, height: kButtonHeight)
                    .padding(.horizontal, 15)
                    .padding(.top, 0)
                    .foregroundColor(.orange)
            }
        }.frame(width:UIScreen.main.bounds.width)
        
    }
}

struct HomeNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        HomeNavigationBar(leftPercent: .constant(0))
    }
}
