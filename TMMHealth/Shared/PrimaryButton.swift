//
//  PrimaryButton.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 03/01/26.
//

import SwiftUI

struct PrimaryButton: View {
    var title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentPrimary.gradient)
                .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
}
