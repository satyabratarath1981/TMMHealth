//
//  DashboardView.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 05/01/26.
//


import SwiftUI
import SwiftData
import Charts

/// Main dashboard screen responsible for:
/// - Showing today's summary
/// - Displaying weekly trends
/// - Handling loading / empty / error states
struct DashboardView: View {

    /// SwiftData context injected from the environment
    @Environment(\.modelContext) private var context

    /// ViewModel lifecycle is tied to this View
    /// StateObject ensures it is created only once
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        content
            .navigationTitle("Today")
            .task {
                // Inject SwiftData context once view appears
                viewModel.setContextIfNeeded(context)

                // Load dashboard data asynchronously
                await viewModel.load()
            }
    }

    // MARK: - State Router
    /// Routes UI based on the current ViewModel state
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

    // MARK: - Loading State
    /// Skeleton placeholders shown while data is loading
    private var loadingView: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                ForEach(0..<3, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 120)
                        .redacted(reason: .placeholder)
                }
            }
            .padding()
        }
    }

    // MARK: - Empty State
    /// Displayed when there is insufficient or no health data
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

            // Hint when weekly data is not enough for charts
            if viewModel.weeklyData.count < 2 {
                Text("Not enough data yet")
                    .font(AppFont.caption)
                    .foregroundStyle(Color.textSecondary)
            }

            Spacer()
        }
        .padding()
    }

    // MARK: - Loaded State
    /// Main dashboard UI when data is successfully loaded
    private var loadedView: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {

                // MARK: Today Summary Card
                /// Shows today's steps and calories
                CardView {
                    VStack(spacing: Spacing.sm) {
                        Text("Today")
                            .font(AppFont.headline)

                        HStack {
                            VStack {
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

                // MARK: Weekly Trend Card
                /// Displays a selectable metric with a line chart
                CardView {
                    VStack(alignment: .leading, spacing: Spacing.md) {
                        Text("Last 7 Days")
                            .font(AppFont.headline)

                        // Toggle between Steps / Calories
                        metricToggle

                        // Line chart showing trend
                        trendChart
                    }
                }
            }
            .padding()
        }
    }

    // MARK: - Error State
    /// Shown when something goes wrong while loading data
    private func errorView(_ message: String) -> some View {
        VStack(spacing: Spacing.md) {
            Text("Something went wrong")
                .font(AppFont.title)

            Text(message)
                .font(AppFont.body)
                .foregroundStyle(Color.textSecondary)
        }
        .padding()
    }

    // MARK: - Metric Toggle
    /// Allows switching between Steps and Calories
    private var metricToggle: some View {
        HStack(spacing: Spacing.sm) {
            ForEach(TrendMetric.allCases, id: \.self) { metric in
                Button {
                    // Animate chart change when metric changes
                    withAnimation {
                        viewModel.selectedMetric = metric
                    }
                } label: {
                    Text(metric.rawValue)
                        .font(AppFont.caption)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(
                            Capsule()
                                .fill(
                                    viewModel.selectedMetric == metric
                                    ? Color.accentPrimary.opacity(0.2)
                                    : Color.clear
                                )
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Trend Chart
    /// Line chart visualizing weekly data
    private var trendChart: some View {
        Chart {
            ForEach(viewModel.weeklyData, id: \.date) { day in
                LineMark(
                    // X-axis: Date (grouped by day)
                    x: .value("Day", day.date, unit: .day),

                    // Y-axis: Steps OR Calories based on selection
                    y: .value(
                        viewModel.selectedMetric.rawValue,
                        viewModel.selectedMetric == .steps
                        ? day.steps
                        : Int(day.activeCalories)
                    )
                )
                // Smooth curved line
                .interpolationMethod(.catmullRom)
            }
        }
        .frame(height: 180)
    }
}
