//
//  TabBarIcon.swift
//  CustomTabBar
//
//  Created by app on 2022/12/27.
//

import SwiftUI

struct TabBarIcon: View {
    @StateObject var viewRouter: ViewRouter

    let assignedPage: Page

    let width, height: CGFloat

    let systemIconName, tabName: String

    var body: some View {
        VStack {
            Image(systemName: systemIconName).resizable().aspectRatio(contentMode: .fit).frame(width: width, height: height).padding(.top, 6)
            Text(tabName).font(.footnote).font(.system(size: 16))
            Spacer()
        }.padding(.horizontal,-2).onTapGesture {
            viewRouter.currentPage = assignedPage
        }.foregroundColor(viewRouter.currentPage == assignedPage ? .blue : .gray)
    }
}


