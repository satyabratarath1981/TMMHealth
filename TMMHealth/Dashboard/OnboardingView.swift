//
//  OnboardingView.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 03/01/26.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        content
            .animation(.easeOut, value: viewModel.state)
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            onboardingContent
        case .requestingPermission:
            loadingContent
        case .denied:
            limitedModeContent
        case .completed:
            completedContent
        }
    }
    
    private var onboardingContent: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()

            VStack(spacing: Spacing.md) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.red.gradient)

                Text("Your Health, Simplified")
                    .font(AppFont.title)
                    .multilineTextAlignment(.center)

                Text("Track activity, understand trends, and stay motivated with meaningful insights.")
                    .font(AppFont.body)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
            }

            CardView {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Label("Daily steps & calories", systemImage: "figure.walk")
                    Label("Weekly performance trends", systemImage: "chart.line.uptrend.xyaxis")
                    Label("Motivating insights & goals", systemImage: "sparkles")
                }
                .font(AppFont.body)
            }

            Spacer()

            PrimaryButton(title: "Connect Health") {
                //viewModel.state = .requestingPermission
                Task {
                        await viewModel.simulatePermissionResult(granted: false)
                    }
            }
        }
        .padding(Spacing.lg)
    }
    
    private var loadingContent: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()

            ProgressView()
                .scaleEffect(1.4)

            Text("Connecting to Health…")
                .font(AppFont.headline)
                .foregroundStyle(Color.textSecondary)

            Spacer()
        }
    }
    
    private var limitedModeContent: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()

            Image(systemName: "lock.heart")
                .font(.system(size: 44))
                .foregroundStyle(.orange)

            Text("Limited Mode")
                .font(AppFont.title)

            Text("Health access is required to show your activity and insights. You can retry permission at any time.")
                .font(AppFont.body)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)

            PrimaryButton(title: "Try Again") {
                viewModel.state = .requestingPermission
            }

            Spacer()
        }
        .padding(Spacing.lg)
    }
    
    private var completedContent: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 48))
                .foregroundStyle(.green)

            Text("Health Connected")
                .font(AppFont.title)

            Text("You’re all set. Loading your dashboard…")
                .font(AppFont.body)
                .foregroundStyle(Color.textSecondary)

            Spacer()
        }
    }
}


