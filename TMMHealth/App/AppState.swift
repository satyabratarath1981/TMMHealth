//
//  AppState.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 05/01/26.
//

import Foundation
import SwiftUI
import Combine

/// Represents the high-level navigation flow of the app.
/// This enum drives which root screen is displayed.
enum AppFlow {
    
    /// Shown to first-time users or users who haven’t completed setup.
    case onBoarding
    
    /// Main application flow shown after onboarding or authentication.
    case dashboard
}

/// Global application state object.
/// Acts as a single source of truth for app-wide navigation and state.
final class AppState: ObservableObject {
    
    /// Published property that controls the current app flow.
    /// Any SwiftUI view observing this object will automatically
    /// re-render when `flow` changes.
    @Published var flow: AppFlow = .onBoarding
}
