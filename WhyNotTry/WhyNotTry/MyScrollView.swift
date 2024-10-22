//
//  MyScrollView.swift
//  WhyNotTry
//
//  Created by app on 2024/1/24.
//

import SwiftUI

struct MyScrollView: View {
    var body: some View {
        ScrollView (.horizontal){
            LazyHStack{
                
                ForEach(1...10,id: \.self){count in
                    Text("count \(count)").onAppear{
                        print("LazyHStack count: \(count)")
                    }
                }
            }
        }.frame(height: 100).background(.green)
    }
}

#Preview {
    MyScrollView()
}
