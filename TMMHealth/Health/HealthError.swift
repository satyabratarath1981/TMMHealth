//
//  Untitled.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 04/01/26.
//

import Foundation

/// Domain-specific errors related to health data access.
/// Used to provide meaningful error handling across services and ViewModels.
enum HealthError: Error {
    
    /// Health data is unavailable on the device
    /// (e.g., HealthKit not supported or data not present).
    case healthDataUnavailable
    
    /// User has denied permission to access health data.
    case authorizationDenied
    
    /// A fallback case for unexpected or uncategorized errors.
    case unknown
}
