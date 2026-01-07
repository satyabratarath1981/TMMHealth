//
//  MockHealthService.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 04/01/26.
//

import Foundation

/// Mock implementation of `HealthService`.
/// Used for previews, unit tests, and development
/// without relying on HealthKit or real device data.
final class MockHealthService: HealthService {

    /// Controls whether authorization should succeed or fail.
    /// Allows testing both granted and denied permission flows.
    let shouldGrantPermission: Bool

    /// Initializes the mock service.
    /// - Parameter shouldGrantPermission: Determines the simulated
    ///   authorization result. Defaults to `true`.
    init(shouldGrantPermission: Bool = true) {
        self.shouldGrantPermission = shouldGrantPermission
    }

    /// Simulates a HealthKit authorization request.
    /// Introduces an artificial delay to mimic real async behavior.
    func requestAuthorization() async throws -> HealthAuthorizationStatus {
        try await Task.sleep(for: .seconds(1))
        return shouldGrantPermission ? .authorized : .denied
    }
    
    /// Returns a deterministic health summary.
    /// Useful for predictable UI rendering and unit testing.
    func fetchTodaySummary() async throws -> HealthSummary {
        
        HealthSummary(
            steps: 8234,
            activeCalories: 486
        )
        print("🧪 MockHealthService.fetchTodaySummary CALLED")
            return HealthSummary(steps: 8234, activeCalories: 486)
    }
    
    func fetchWeeklyTrends() async throws -> [DailyTrend] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        // Deterministic 7-day mock data (like Apple Health)
        return (0..<7).map { offset in
            let date = calendar.date(byAdding: .day, value: -offset, to: today)!

            return DailyTrend(
                date: date,
                steps: Int.random(in: 2000...10000),
                activeCalories: Double.random(in: 150...600)
            )
        }
        .reversed()
    }
}

