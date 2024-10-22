//
//  ContentView.swift
//  WhyNotTry
//
//  Created by app on 2024/1/16.
//

import SwiftUI

struct ContentView: View {
    var activities = ["Archery", "Baseball", "Basketball", "Bowling", "Boxing", "Cricket", "Curling", "Fencing", "Golf", "Hiking", "Lacrosse", "Rugby", "Squash"]
    var colors: [Color] = [.blue, .cyan, .gray, .green, .indigo, .mint, .orange, .pink, .purple, .red]
    @State private var id = 1

    @State private var selected = "Archery"
    var body: some View {
        VStack{
            Text("SwiftUI").font(.largeTitle.bold())
            Circle().fill(colors.randomElement() ?? .blue).padding(20).overlay( Image(systemName: "figure.\(selected.lowercased())").font(.system(size: 144)).foregroundColor(.white))
            Text("Archery!").font(.title)
            Spacer()
            Button("Try again") {
                withAnimation(.easeInOut(duration: 1)){
                    selected = activities.randomElement() ?? "Archery"
                    id += 1
                }
            }.buttonStyle(.borderedProminent)
        }.transition(.slide).id(id)
    }
}

#Preview {
    ContentView()
}
