//
//  AppRootView.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 03/01/26.
//

import SwiftUI

/// Root container view of the application.
/// Responsible for deciding which high-level flow
/// (Onboarding or Dashboard) should be shown.
struct AppRootView: View {
    
    /// `AppState` is the single source of truth for app-level navigation.
    /// `@StateObject` ensures the instance is created once
    /// and survives view re-rendering.
    @StateObject private var appState = AppState()
    
    var body: some View {
        /// `NavigationStack` manages navigation for the entire app.
        /// It replaces `NavigationView` and supports programmatic navigation.
        NavigationStack {
            
            /// Switch on the current app flow to decide
            /// which screen should be presented.
            switch appState.flow {
                
            case .onBoarding:
                /// Onboarding flow shown for first-time users.
                /// `appState` is injected as an `EnvironmentObject`
                /// so child views can update global navigation state.
                OnboardingView()
                    .environmentObject(appState)
                
            case .dashboard:
                /// Main dashboard shown after onboarding completes
                /// or when the user is already authenticated.
                DashboardView()
            }
        }
    }
}
