//
//  Spacing.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 03/01/26.
//

import SwiftUI

/// Centralized spacing system for the app.
/// Provides consistent layout spacing across all views
/// and avoids the use of magic numbers.
enum Spacing {
    
    /// Extra-small spacing.
    /// Typically used for tight layouts or minor gaps.
    static let xs: CGFloat = 4
    
    /// Small spacing.
    /// Used between closely related UI elements.
    static let sm: CGFloat = 8
    
    /// Medium spacing.
    /// Default spacing for most vertical and horizontal stacks.
    static let md: CGFloat = 16
    
    /// Large spacing.
    /// Used to separate major content sections.
    static let lg: CGFloat = 24
    
    /// Extra-large spacing.
    /// Used for screen-level padding or major visual separation.
    static let xl: CGFloat = 32
}
