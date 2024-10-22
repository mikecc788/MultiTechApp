//
//  Navigator.swift
//  NavigationExample
//
//  Created by Burak Kurtarır on 16.08.2024.
//

import Foundation
import SwiftUI

@Observable
class Navigator :ObservableObject{
    var path: [Routes] = []
    
    func push(to route: Routes) {
        path.append(route)
    }
    
    func pop() {
        if path.isEmpty {
            return
        }
        path.removeLast()
    }
}

extension EnvironmentValues {
    var navigator: Navigator {
        get { self[NavigatorKey.self] }
        set { self[NavigatorKey.self] = newValue }
    }
}

private struct NavigatorKey: EnvironmentKey {
    static var defaultValue: Navigator = Navigator()
}
