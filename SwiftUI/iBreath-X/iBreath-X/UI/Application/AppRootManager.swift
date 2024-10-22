//
//  AppRootManager.swift
//  iBreath-X
//
//  Created by app on 2024/8/22.
//

import Foundation
final class AppRootManager: ObservableObject {
    @Published var currentRoot: AppRoots = .main
    enum AppRoots {
        case intro
        case main
        case login

    }
}
