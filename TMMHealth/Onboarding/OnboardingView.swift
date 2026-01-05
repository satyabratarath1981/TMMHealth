//
//  OnboardingView.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 03/01/26.
//

import SwiftUI

/// Onboarding screen responsible for introducing the app
/// and requesting Health access from the user.
struct OnboardingView: View {
    
    /// ViewModel that manages onboarding state and business logic.
    /// `@StateObject` ensures the ViewModel lifecycle
    /// is tied to this view instance.
    @StateObject private var viewModel = OnboardingViewModel()
    
    /// Global app state used to transition
    /// from onboarding to dashboard flow.
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        content
            /// Animates transitions between onboarding states.
            .animation(.easeOut, value: viewModel.state)
    }
    
    /// Switches UI based on the current onboarding state.
    /// Ensures predictable, state-driven rendering.
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
    
    /// Initial onboarding content introducing the app
    /// and explaining the value of connecting Health data.
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

            /// Highlights key features in a card-style layout.
            CardView {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Label("Daily steps & calories", systemImage: "figure.walk")
                    Label("Weekly performance trends", systemImage: "chart.line.uptrend.xyaxis")
                    Label("Motivating insights & goals", systemImage: "sparkles")
                }
                .font(AppFont.body)
            }

            Spacer()

            /// Initiates Health permission request.
            PrimaryButton(title: "Connect Health") {
                Task {
                    await viewModel.connectHealth()
                }
            }
        }
        .padding(Spacing.lg)
    }
    
    /// Loading state displayed while requesting Health permissions.
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
    
    /// Shown when Health permission is denied.
    /// Explains limitations and allows retrying authorization.
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

            /// Allows user to retry permission request.
            PrimaryButton(title: "Try Again") {
                viewModel.state = .requestingPermission
            }

            Spacer()
        }
        .padding(Spacing.lg)
    }
    
    /// Final onboarding state shown when Health access is granted.
    /// Automatically transitions to the dashboard.
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
        .onAppear {
            /// Small delay to allow success feedback
            /// before navigating to the dashboard.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                appState.flow = .dashboard
            }
        }
    }
}

