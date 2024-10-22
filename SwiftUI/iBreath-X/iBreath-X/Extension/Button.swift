//
//  ButtonStyle.swift
//  iBreath-X
//
//  Created by app on 2024/8/24.
//

import Foundation
import SwiftUI
extension View {
    func defaultButtonStyle() -> some View {
        self
            .padding()
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .background(Color.mainColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func CircleButtonStyle() -> some View {
        self
            .padding()
            .foregroundColor(.white)
            .background(Color.mainColor).cornerRadius(16)
    }
}

struct HeaderImageButton: View {
    var image: String
    var body: some View {
        Image(systemName: image)
            .font(.system(size: 23))
            .foregroundStyle(.white)
    }
}

