//
//  TMMHealthApp.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 03/01/26.
//

import SwiftUI

/// Application entry point.
/// Responsible for setting up the root scene and launching the app.
@main
struct TMMHealthApp: App {
    
    var body: some Scene {
        /// `WindowGroup` creates the main app window.
        /// On iOS, this represents the primary app scene.
        WindowGroup {
            /// `AppRootView` acts as the root coordinator
            /// and determines the initial navigation flow.
            AppRootView()
        }
    }
}
