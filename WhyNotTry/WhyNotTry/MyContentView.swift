//
//  MyContentView.swift
//  WhyNotTry
//
//  Created by app on 2024/1/17.
//

import SwiftUI

struct MyContentView: View {
    @State private var showLaunchAnimation = true
    
    var body: some View {
        WelcomeScreenView()
    }
}

#Preview {
    MyContentView()
}
