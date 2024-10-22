//
//  LazyGridSample.swift
//  TestDemo
//
//  Created by app on 2024/8/20.
//

import SwiftUI

struct LazyGridSample: View {
//    let columns = [GridItem(.fixed(180)),GridItem(.fixed(100)),GridItem(.fixed(100))]
    let columns = [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    let columns1 = [GridItem(.adaptive(minimum: 10, maximum: 300)),GridItem(.adaptive(minimum: 50, maximum: 300))]
    var body: some View {
        ScrollView {
            Rectangle().fill(Color.orange).frame(height: 250)
            LazyVGrid(columns: columns,alignment: .center,spacing: 16,pinnedViews: [.sectionHeaders]) {
                Section {
                    ForEach(0..<20){ index in
                        Rectangle().fill().frame(height: 80)
                    }
                } header: {
                    Text("section1")
                }
                
                Section {
                    ForEach(0..<20){ index in
                        Rectangle().fill().frame(height: 80)
                    }
                } header: {
                    Text("section2")
                }
            }
        }
    }
}

#Preview {
    LazyGridSample()
}
