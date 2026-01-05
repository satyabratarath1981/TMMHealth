//
//  Colors.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 03/01/26.
//

import SwiftUI

/// Centralized color palette for the app.
/// Defines semantic colors instead of hard-coded values,
/// making the UI consistent and easy to maintain.
extension Color {
    
    /// Primary background color for main screens.
    /// Automatically adapts to Light and Dark Mode.
    static let backgroundPrimary = Color(.systemBackground)
    
    /// Secondary background color used for cards,
    /// grouped content, and elevated surfaces.
    /// Automatically adapts to Light and Dark Mode.
    static let backgroundSecondary = Color(.secondarySystemBackground)
    
    /// Primary accent color used for highlights,
    /// icons, and call-to-action elements.
    static let accentPrimary = Color.blue
    
    /// Primary text color for high-emphasis content.
    /// Automatically adapts to Light and Dark Mode.
    static let textPrimary = Color.primary
    
    /// Secondary text color for supporting or
    /// less prominent textual content.
    /// Automatically adapts to Light and Dark Mode.
    static let textSecondary = Color.secondary
}
