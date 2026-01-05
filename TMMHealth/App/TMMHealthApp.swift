//
//  TMMHealthApp.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 03/01/26.
//

import SwiftUI
import SwiftData

/// Application entry point using the SwiftUI lifecycle.
/// Configures global app dependencies such as SwiftData.
@main
struct TMMHealthApp: App {

    var body: some Scene {
        /// Main app window scene.
        WindowGroup {
            /// Root coordinator view that controls
            /// high-level navigation and app flow.
            AppRootView()
        }
        /// Registers the SwiftData model container.
        /// Makes `DailyHealthCache` available throughout the app
        /// via `@Environment(\.modelContext)`.
        .modelContainer(for: DailyHealthCache.self)
    }
}
