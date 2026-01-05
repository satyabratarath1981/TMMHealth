//
//  HealthSummary.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 05/01/26.
//

import Foundation

/// Domain model representing a user's health activity summary.
/// Encapsulates aggregated metrics for a specific time period
/// (e.g., today).
struct HealthSummary {
    
    /// Total number of steps taken.
    let steps: Int
    
    /// Total active calories burned.
    let activeCalories: Int
}
