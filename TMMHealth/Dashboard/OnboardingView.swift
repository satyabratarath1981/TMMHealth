//
//  OnboardingView.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 03/01/26.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()
            
            Text("Your Health, Simplified")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Label("Track daily activity effortlessly", systemImage: "figure.walk")
                Label("Understand weekly trends", systemImage: "chart.bar")
                Label("Stay motivated with insights", systemImage: "sparkles")
            }
            .font(AppFont.body)
            Spacer()
            
            PrimaryButton(title: "Connect Health") {
                print("Tapped")
            }
        }
        .padding(Spacing.lg)
        .background(Color.backgroundPrimary)
    }
}

