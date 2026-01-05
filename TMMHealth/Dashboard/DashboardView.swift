//
//  DashboardView.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 05/01/26.
//


import SwiftUI
import SwiftData

/// Main dashboard screen responsible for displaying
/// today's activity summary and handling different UI states.
struct DashboardView: View {
    
    /// ViewModel responsible for business logic and state management.
    /// `@StateObject` ensures the ViewModel lifecycle is tied to this view
    /// and is not recreated on every render.
    @StateObject private var viewModel = DashboardViewModel()
    
    init() {
           _viewModel = StateObject(
               wrappedValue: DashboardViewModel()
           )
       }
    
    var body: some View {
        content
            /// Sets the navigation bar title for the dashboard.
            .navigationTitle("Today")
            
            /// Triggers data loading when the view appears.
            /// `.task` is lifecycle-aware and works seamlessly with async/await.
            .task {
                await viewModel.load()
            }
    }
    
    /// Determines which UI to show based on the current dashboard state.
    /// `@ViewBuilder` allows returning different view types.
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
            
        case .loading:
            loadingView
            
        case .empty:
            emptyView
            
        case .loaded:
            loadedView
            
        case .error(let message):
            errorView(message)
        }
    }
    
    /// Skeleton loading UI displayed while data is being fetched.
    /// Uses redacted placeholders to indicate loading content.
    private var loadingView: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                ForEach(0..<3) { _ in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 120)
                        .redacted(reason: .placeholder)
                }
            }
            .padding()
        }
    }
    
    /// Empty state shown when no dashboard data is available.
    /// Provides clear user feedback and guidance.
    private var emptyView: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()
            
            Image(systemName: "figure.walk.circle")
                .font(.system(size: 48))
                .foregroundStyle(Color.accentPrimary)
            
            Text("No Activity Yet")
                .font(AppFont.title)
            
            Text("Once Health data is available, your daily summary and insights will appear here.")
                .font(AppFont.body)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
        }
    }
    
    /// Main content view shown when data has been successfully loaded.
    /// Displays today's step count and active calories summary.
    private var loadedView: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {

                CardView {
                    VStack(spacing: Spacing.sm) {
                        
                        Text("Today")
                            .font(AppFont.headline)

                        HStack {
                            VStack {
                                /// Safely unwraps optional summary data
                                /// and provides a fallback value.
                                Text("\(viewModel.summary?.steps ?? 0)")
                                    .font(.title.bold())
                                
                                Text("Steps")
                                    .font(AppFont.caption)
                            }

                            Spacer()

                            VStack {
                                Text("\(Int(viewModel.summary?.activeCalories ?? 0))")
                                    .font(.title.bold())
                                
                                Text("Calories")
                                    .font(AppFont.caption)
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    /// Error view displayed when data loading fails.
    /// Accepts a user-friendly error message.
    private func errorView(_ message: String) -> some View {
        VStack(spacing: Spacing.md) {
            Text("Something went wrong")
                .font(AppFont.title)
            
            Text(message)
                .font(AppFont.body)
                .foregroundStyle(Color.textSecondary)
        }
    }
}
