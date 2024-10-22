//
//  HomeView.swift
//  WhyNotTry
//
//  Created by app on 2024/8/28.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(0...10,id: \.self){item in
                    NavigationLink(destination: SignInScreenView()) {
                        Text("item\(item)")
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
