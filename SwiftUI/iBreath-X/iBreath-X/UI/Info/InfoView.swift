//
//  InfoView.swift
//  iBreath-X
//
//  Created by app on 2024/8/22.
//

import SwiftUI

struct InfoView: View {
 
    init() {
//        UICollectionView.appearance().backgroundColor = .clear
    }
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(InfoStore.infoItems){items in
                        NavigationLink(value: items.type) {
                            HStack {
                                Image(items.imageName)
                                Spacer().frame(width:20)
                                Text(items.title)
                                Spacer()
                            }.padding(.vertical,10)
                        }
                    }
                }.listRowSpacing(20).navigationTitle("Info").navigationBarTitleDisplayMode(.large).modifier(ListBackgroundModifier())
            }.withRoutes().background(MyColorScheme.bgColor)
        }
    }
}

#Preview {
    InfoView()
}


