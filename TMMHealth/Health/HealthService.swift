//
//  HealthService.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 03/01/26.
//

import Foundation

/// Represents the current authorization state for accessing health data.
/// Used to drive permission flows and conditional UI.
enum HealthAuthorizationStatus {
    
    /// User has not yet been prompted for health permissions.
    case notDetermined
    
    /// Access to health data is restricted
    /// (e.g., parental controls or device policies).
    case restricted
    
    /// User has granted permission to access health data.
    case authorized
    
    /// User has explicitly denied permission to access health data.
    case denied
}

/// Abstraction layer for health data operations.
/// Allows swapping HealthKit with mocks or other implementations
/// without affecting the ViewModel or UI layers.
protocol HealthService {
    
    /// Requests authorization to access health-related data.
    /// - Returns: The resulting authorization status.
    /// - Throws: `HealthError` if authorization fails unexpectedly.
    func requestAuthorization() async throws -> HealthAuthorizationStatus
    
    /// Fetches today's aggregated health summary.
    /// - Returns: A `HealthSummary` domain model.
    /// - Throws: `HealthError` or underlying service errors.
    func fetchTodaySummary() async throws -> HealthSummary
    
    func fetchWeeklyTrends() async throws -> [DailyTrend]
}

