//
//  PrimaryButton.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 03/01/26.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            action()
        } label: {
            Text(title)
                .font(AppFont.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.accentPrimary.gradient)
                        .scaleEffect(isPressed ? 0.96 : 1)
                )
        }
        .buttonStyle(.plain)
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
