//
//  TrendMetric.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 06/01/26.
//

import Foundation

/// Represents the selectable metrics shown in the dashboard trend chart.
/// Used by:
/// - Metric toggle buttons
/// - Chart Y-axis labeling
enum TrendMetric: String, CaseIterable {

    /// Daily step count
    case steps = "Steps"

    /// Active calories burned
    case calories = "Calories"
}
