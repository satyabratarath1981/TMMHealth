//
//  HealthCacheService.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 05/01/26.
//

import SwiftData
import Foundation

/// Service responsible for reading and writing
/// daily health summaries to local SwiftData storage.
/// Acts as a cache layer between HealthKit and the UI.
@MainActor
final class HealthCacheService {

    // MARK: - Dependencies

    /// SwiftData context used to perform fetch and save operations.
    /// Injected to keep the service testable and decoupled.
    private let context: ModelContext

    // MARK: - Initializer

    /// Designated initializer with dependency injection.
    /// - Parameter context: SwiftData `ModelContext`
    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Fetch Today

    /// Fetches the cached health summary for today, if available.
    /// - Returns: `DailyHealthCache` for today or `nil` if not found.
    func fetchToday() -> DailyHealthCache? {

        /// Normalize current date to the start of the day
        /// to ensure date equality comparisons work correctly.
        let startOfDay = Calendar.current.startOfDay(for: Date())

        /// SwiftData fetch descriptor with a predicate
        /// that ensures only today's record is returned.
        let descriptor = FetchDescriptor<DailyHealthCache>(
            predicate: #Predicate {
                $0.date == startOfDay
            }
        )

        /// Fetch and return the first matching record
        return try? context.fetch(descriptor).first
    }

    // MARK: - Save / Update Today

    /// Saves or updates today's health summary in the cache.
    /// - Parameter summary: Aggregated health data for today.
    func save(summary: HealthSummary) {
        let startOfDay = Calendar.current.startOfDay(for: Date())

        if let existing = fetchToday() {
            /// Update existing cache entry
            existing.steps = summary.steps
            existing.activeCalories = Double(summary.activeCalories)
        } else {
            /// Insert a new cache entry for today
            let cache = DailyHealthCache(
                date: startOfDay,
                steps: summary.steps,
                activeCalories: Double(summary.activeCalories)
            )
            context.insert(cache)
        }
    }

    // MARK: - Fetch Last 7 Days

    /// Fetches cached health summaries for the last 7 days (including today).
    /// - Returns: Sorted array of `DailyHealthCache` by date (ascending).
    func fetchLast7Days() -> [DailyHealthCache] {

        /// Calculate the start date (6 days ago + today = 7 days)
        let startDate = Calendar.current.date(
            byAdding: .day,
            value: -6,
            to: Calendar.current.startOfDay(for: Date())
        )!

        /// Fetch all records from startDate onwards,
        /// sorted chronologically for chart rendering.
        let descriptor = FetchDescriptor<DailyHealthCache>(
            predicate: #Predicate {
                $0.date >= startDate
            },
            sortBy: [SortDescriptor(\.date)]
        )

        /// Return cached results or empty array if fetch fails
        return (try? context.fetch(descriptor)) ?? []
    }
}
