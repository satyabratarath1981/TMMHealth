//
//  DashboardViewModel.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 05/01/26.
//

import SwiftUI
import Combine

/// ViewModel responsible for loading and managing
/// dashboard-related business logic and UI state.
@MainActor
final class DashboardViewModel: ObservableObject {

    /// Current UI state of the dashboard.
    /// Drives which view is rendered in `DashboardView`.
    @Published var state: DashboardState = .loading

    /// Holds the successfully loaded health summary.
    /// Optional to safely represent "no data" or loading states.
    @Published var summary: HealthSummary?
    
    /// Abstraction over the health data source.
    /// Enables dependency injection and testability.
    private let healthService: HealthService
    
    /// Designated initializer with dependency injection.
    /// Default implementation uses `HealthKitService`.
    init(healthService: HealthService = HealthKitService()) {
        self.healthService = healthService
    }

    /// Loads today's health summary asynchronously.
    /// Updates UI state on the main thread using `@MainActor`.
    func load() async {
        /// Ensure loading state is reflected immediately in the UI.
        state = .loading

        do {
            /// Fetch health data using async/await.
            let data = try await healthService.fetchTodaySummary()
            
            /// Update published properties once data is available.
            summary = data
            
            /// Determine final UI state based on data content.
            /// If steps are zero, treat it as an empty state.
            state = data.steps == 0 ? .empty : .loaded
        } catch {
            /// Handle failure gracefully with a user-friendly error state.
            state = .error("Health data unavailable")
        }
    }
}


