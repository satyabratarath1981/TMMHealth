//
//  DashboardViewModel.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 05/01/26.
//

import SwiftUI
import Combine
import SwiftData

/// ViewModel responsible for:
/// - Loading Health data
/// - Managing cache + refresh logic
/// - Exposing UI-ready state for DashboardView
@MainActor
final class DashboardViewModel: ObservableObject {

    // MARK: - UI State

    /// Represents the overall screen state
    @Published var state: DashboardState = .loading
    
    @Published var weeklyTrends: [DailyTrend] = []

    /// Summary for today's activity
    @Published var summary: HealthSummary?

    /// Cached data for the last 7 days (used for charts)
    @Published var weeklyData: [DailyHealthCache] = []

    /// Currently selected metric for the trend chart
    @Published var selectedMetric: TrendMetric = .steps

    // MARK: - Dependencies

    /// Abstraction over HealthKit (makes ViewModel testable)
    private let healthService: HealthService

    /// Handles local persistence using SwiftData
    private var cacheService: HealthCacheService?

    /// SwiftData context injected from the View
    private var context: ModelContext?

    // MARK: - Initializer

    /// Default initializer with dependency injection
    /// Allows mocking HealthService for unit tests
    init(healthService: HealthService) {
        self.healthService = healthService
    }

    // MARK: - Context Injection (IMPORTANT)

    /// Injects SwiftData context once
    /// Prevents multiple initializations when View redraws
    func setContextIfNeeded(_ context: ModelContext) {
        guard self.context == nil else { return }
        self.context = context
        self.cacheService = HealthCacheService(context: context)
    }

    // MARK: - Public API

    /// Entry point called from the View
    /// Loads cached data first, then refreshes from HealthKit
    func load() async {
        state = .loading

        do {
            async let today = healthService.fetchTodaySummary()
            async let weekly = healthService.fetchWeeklyTrends()

            self.summary = try await today
            weeklyTrends = try await weekly

            state = self.summary?.steps == 0 ? .empty : .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    // MARK: - Refresh Logic

    /// Fetches fresh data from HealthKit
    /// Updates cache and UI state accordingly
    private func refresh() async {
        guard let cacheService else { return }

        do {
            // Fetch live HealthKit summary
            let data = try await healthService.fetchTodaySummary()

            // Update in-memory state
            summary = data

            // Persist latest data
            cacheService.save(summary: data)

            // Reload last 7 days from cache (includes today)
            weeklyData = cacheService.fetchLast7Days()

            // Decide UI state
            state = isEmpty(data) ? .empty : .loaded

        } catch {
            // Only show error if nothing was previously shown
            if summary == nil {
                state = .error("Health data unavailable")
            }
        }
    }

    // MARK: - Helpers

    /// Determines whether today's summary is effectively empty
    /// Used to decide between `.empty` and `.loaded` UI states
    private func isEmpty(_ data: HealthSummary) -> Bool {
        data.steps == 0 && data.activeCalories == 0
    }
}
