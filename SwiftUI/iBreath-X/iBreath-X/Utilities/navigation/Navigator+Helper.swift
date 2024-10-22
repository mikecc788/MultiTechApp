//
//  Navigator+Helper.swift
//  iBreath-X
//
//  Created by app on 2024/8/27.
//

import SwiftUI
import CoreBluetooth

extension View{
    func withRoutes() -> some View {
        self.navigationDestination(for: Routes.self) { route in
            switch route {
            case .publicAccount:
                PublicAccountView().toolbar(.hidden, for: .tabBar)
            case .offical:
                OfficialView().toolbar(.hidden, for: .tabBar)
            case .healthy:
                HealthQuestionView().toolbar(.hidden, for: .tabBar)
            }
        }
    }
    
    func profileRoutes() -> some View {
        self.navigationDestination(for: MyRoutes.self) { route in
            switch route {
            case .searchHistory:
                SearchHistoryView().toolbar(.hidden, for: .tabBar)
            case .reviewHistory:
                ReviewHistoryView().toolbar(.hidden, for: .tabBar)
            case .settings:
                SetView().toolbar(.hidden, for: .tabBar)
            }
        }
    }
    
    func homeRoutes() -> some View {
        self.navigationDestination(for: PeripheralRoutes.self) { route in
            switch route {
            case .atomizer (let peripheral):
                AtomizerView(peripheral: peripheral).toolbar(.hidden, for: .tabBar)
            case .airFitSmart:
                AirFitSmartView().toolbar(.hidden, for: .tabBar)
            case .defaultView:
                AirSmartExtraView().toolbar(.hidden, for: .tabBar)
            }
        }
    }
    
}
