//
//  TestDemoApp.swift
//  TestDemo
//
//  Created by app on 2024/8/20.
//

import SwiftUI
import SwiftData

@main
struct TestDemoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
//            ContentView()
//            LazyGridSample()
//            ColorSample()
//            NavigationStackSample()
//            CarouselView()
//            FocusStateSample()
            ViewManipulationDemo()
        }
        .modelContainer(sharedModelContainer)
    }
}
