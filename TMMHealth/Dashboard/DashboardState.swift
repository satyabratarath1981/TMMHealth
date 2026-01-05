//
//  DashboardState.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 05/01/26.
//

import Foundation

/// Represents the UI state of the Dashboard screen.
/// Used to drive view rendering based on data availability and errors.
enum DashboardState {
    
    /// Data is currently being fetched or processed.
    case loading
    
    /// No data is available to display.
    /// Typically used when an API returns an empty response.
    case empty
    
    /// Data was successfully loaded and is ready to be displayed.
    case loaded
    
    /// An error occurred while loading data.
    /// Associated value provides a user-friendly error message.
    case error(String)
}
