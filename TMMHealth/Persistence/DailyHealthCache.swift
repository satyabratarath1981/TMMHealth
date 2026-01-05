//
//  DailyHealthCache.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 05/01/26.
//

import Foundation
import SwiftData

/// SwiftData model used to cache daily health metrics locally.
/// Enables offline access, fast loading, and reduced HealthKit queries.
@Model
final class DailyHealthCache {

    /// The date representing the day for which data is cached.
    /// Marked as unique to ensure only one record per day exists.
    @Attribute(.unique)
    var date: Date

    /// Total number of steps recorded for the day.
    var steps: Int

    /// Total active calories burned for the day.
    var activeCalories: Double

    /// Designated initializer for creating a cached daily record.
    /// - Parameters:
    ///   - date: The specific day being cached.
    ///   - steps: Total step count.
    ///   - activeCalories: Total active calories burned.
    init(date: Date, steps: Int, activeCalories: Double) {
        self.date = date
        self.steps = steps
        self.activeCalories = activeCalories
    }
}
