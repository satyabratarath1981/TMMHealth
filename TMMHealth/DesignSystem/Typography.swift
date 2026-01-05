//
//  Typography.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 03/01/26.
//

import SwiftUI

/// Centralized typography system for the app.
/// Defines semantic font styles to ensure consistent
/// text appearance across all screens.
enum AppFont {
    
    /// Large title font used for primary screen headings.
    /// Typically used for navigation titles or hero text.
    static let title: Font = Font.system(size: 34, weight: .bold)
    
    /// Headline font used for section titles and emphasis text.
    static let headline: Font = Font.system(size: 17, weight: .bold)
    
    /// Body font used for standard paragraph and descriptive text.
    static let body: Font = Font.system(size: 15)
    
    /// Caption font used for secondary or auxiliary text,
    /// such as labels, hints, or metadata.
    static let caption: Font = Font.system(size: 13)
}
