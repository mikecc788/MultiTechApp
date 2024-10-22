//
//  SignInScreenView.swift
//  WhyNotTry
//
//  Created by app on 2024/1/20.
//

import SwiftUI

struct SignInScreenView: View {
    @State private var rotationDegrees = 0.0        // NEED TO UPDATE
    @State private var rotationDegrees2 = 360.0     // NEED TO UPDATE
    @State private var swingAngle: Double = 5
    @State private var scale: CGFloat = 1.0
    var body: some View {
        Spacer(minLength: 24)
        NavigationStack {
            VStack {
                NavigationLink(destination: TestView()) {
                   Text("Push")
                       .font(.largeTitle)
                       .foregroundColor(.blue)
               }

                ZStack {
                    Image(.otpOuterCircle)
                        .customScaleResize(widthScale: 0.5)
                        .rotationEffect(.degrees(rotationDegrees))
                        .onAppear() {
                            withAnimation(Animation.linear(duration: 60).repeatForever(autoreverses: false)) {
                                rotationDegrees = 360
                            }
                        }
                    Image(.otpInnerCircle)
                        .customScaleResize(widthScale: 0.5)
                        .rotationEffect(.degrees(rotationDegrees2))
                        .onAppear() {
                            withAnimation(Animation.linear(duration: 60).repeatForever(autoreverses: false)) {
                                rotationDegrees2 = 0
                            }
                        }
                    Image(.otpHand)
                        .customScaleResize(widthScale: 0.5)
                        .rotationEffect(.degrees(swingAngle))
                        .scaleEffect(scale)
                        .onAppear() {
                            withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                                swingAngle = -5
                                scale = 1.1
                            }
                        }
                }
            }
        }
      
    }
}

#Preview {
    SignInScreenView()
}
