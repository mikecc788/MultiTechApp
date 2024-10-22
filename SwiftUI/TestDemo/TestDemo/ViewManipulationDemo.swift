//
//  ScrollViewTest.swift
//  TestDemo
//
//  Created by app on 2024/8/22.
//

import SwiftUI

struct ViewManipulationDemo: View {
    var body: some View {
        Image(systemName: "dog.fill").resizable().frame(width: 60,height: 60).padding(.all,30).foregroundStyle(.white).background(Circle().fill(.black))
    }
}

#Preview {
    ViewManipulationDemo()
}
