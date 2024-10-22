//
//  WelcomeScreenView.swift
//  WhyNotTry
//
//  Created by app on 2024/1/17.
//

import SwiftUI

struct WelcomeScreenView: View {
    @State private var contentOpacity: Double = 0
    @State private var rotationDegrees = 360.0
    @State private var isMovingRight = true

    var body: some View {
        NavigationView{
            VStack{
                Spacer().frame(height: 100)
                
                VStack(content: {
                    Image(.logoWithText).customScaleResize(widthScale: 0.5)
                    Spacer()
                    WelcomeTextView()
                    Spacer().frame(height: 32)
                    Image(.welcomeBackground).customScaleResize(widthScale: 0.8)
                }).opacity(contentOpacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.5)) {
                            contentOpacity = 1
                        }
                }
                Spacer().frame(height: 100)
               
                NavigationLink(destination: SignInScreenView()) {
                    Text("Sign In").foregroundStyle(Color(.customBackground)).font(.title3.bold()).padding().frame(width: 200,height: 50).background(.white).cornerRadius(25)
                }
            }.padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.customBackground)
        }
        
    }
}

extension Image{
    func customScaleResize(widthScale: Float) -> some View {
        
        let outputWidth = Float(UIScreen .main.bounds.size.width) * widthScale
        
        return self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: CGFloat(outputWidth))
    }
    
    func customFixedResize(width: CGFloat? = nil, height: CGFloat? = nil) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
    }
}

#Preview {
    WelcomeScreenView()
}
