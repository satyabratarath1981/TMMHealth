//
//  CardView.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 04/01/26.
//

import SwiftUI

struct CardView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.backgroundSecondary)
                    .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
            )
    }
}
