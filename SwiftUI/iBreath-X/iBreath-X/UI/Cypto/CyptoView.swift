//
//  CyptoView.swift
//  iBreath-X
//
//  Created by app on 2024/8/27.
//

import SwiftUI

struct CyptoView: View {
    @State private var showPortfolio: Bool = false
    @EnvironmentObject private var vm: CyptoViewModel
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            Text("Hello, World!")
        }
    }
}

#Preview {
    CyptoView()
}
