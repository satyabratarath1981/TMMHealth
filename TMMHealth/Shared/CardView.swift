//
//  CardView.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 04/01/26.
//

import SwiftUI

/// Reusable container view that displays content
/// inside a card-style layout with rounded corners and shadow.
/// Used to visually group related information.
struct CardView<Content: View>: View {
    
    /// The content displayed inside the card.
    /// Stored as a generic `View` for flexibility.
    let content: Content

    /// Initializes the card with a view builder.
    /// Allows callers to pass multiple views
    /// without wrapping them in a container.
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            /// Inner padding to separate content from card edges.
            .padding(Spacing.lg)
            
            /// Card background with rounded corners and subtle shadow.
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.backgroundSecondary)
                    .shadow(
                        color: .black.opacity(0.05),
                        radius: 8,
                        y: 4
                    )
            )
    }
}
