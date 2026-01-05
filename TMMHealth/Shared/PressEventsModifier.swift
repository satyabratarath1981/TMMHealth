//
//  PressEventsModifier.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 04/01/26.
//

import SwiftUI

/// A custom `ViewModifier` that exposes
/// press and release events for a view.
/// Useful for creating custom button interactions
/// such as press animations or haptic feedback.
struct PressEventsModifier: ViewModifier {
    
    /// Called when the press begins.
    let onPress: () -> Void
    
    /// Called when the press ends.
    let onRelease: () -> Void

    func body(content: Content) -> some View {
        content
            /// Uses a zero-distance `DragGesture`
            /// to detect touch down and touch up events.
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        onPress()
                    }
                    .onEnded { _ in
                        onRelease()
                    }
            )
    }
}

// MARK: - View Extension

extension View {
    
    /// Adds press and release handlers to any view.
    /// Enables fine-grained control over touch interactions.
    ///
    /// Example:
    /// ```
    /// Text("Tap me")
    ///     .pressEvents(
    ///         onPress: { scale = 0.95 },
    ///         onRelease: { scale = 1.0 }
    ///     )
    /// ```
    func pressEvents(
        onPress: @escaping () -> Void,
        onRelease: @escaping () -> Void
    ) -> some View {
        modifier(
            PressEventsModifier(
                onPress: onPress,
                onRelease: onRelease
            )
        )
    }
}
