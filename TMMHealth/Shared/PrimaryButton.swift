//
//  PrimaryButton.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 03/01/26.
//

import SwiftUI

/// Primary call-to-action button used across the app.
/// Provides consistent styling, press animation,
/// and haptic feedback.
struct PrimaryButton: View {
    
    /// Button title displayed to the user.
    let title: String
    
    /// Action executed when the button is tapped.
    let action: () -> Void

    /// Tracks the pressed state to drive
    /// scale animation during touch interaction.
    @State private var isPressed = false

    var body: some View {
        Button {
            /// Triggers medium-impact haptic feedback
            /// to acknowledge the tap.
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            /// Execute the provided action.
            action()
        } label: {
            Text(title)
                .font(AppFont.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                
                /// Visual styling for the primary button.
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.accentPrimary.gradient)
                        
                        /// Subtle scale effect for pressed state.
                        .scaleEffect(isPressed ? 0.96 : 1)
                )
        }
        /// Removes default SwiftUI button styling
        /// to allow full customization.
        .buttonStyle(.plain)
        
        /// Adds custom press and release handling
        /// for smooth interaction animations.
        .pressEvents {
            withAnimation(.easeOut(duration: 0.15)) {
                isPressed = true
            }
        } onRelease: {
            withAnimation(.easeOut(duration: 0.15)) {
                isPressed = false
            }
        }
    }
}
