//
//  ViewRouter.swift
//  CustomTabBar
//
//  Created by app on 2022/12/27.
//

import SwiftUI

enum Page{
    case home
    case my
}

class ViewRouter: ObservableObject {
    @Published var currentPage: Page = .home
}
