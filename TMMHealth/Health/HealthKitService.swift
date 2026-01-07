//
//  HealthKitService.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 04/01/26.
//

import HealthKit

/// Concrete implementation of `HealthService`
/// that interacts with Apple HealthKit.
final class HealthKitService: HealthService {

    /// Primary interface to the HealthKit database.
    private let healthStore = HKHealthStore()
    
    func fetchWeeklyTrends() async throws -> [DailyTrend] {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.startOfDay(
            for: calendar.date(byAdding: .day, value: -6, to: endDate)!
        )

        let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let caloriesType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!

        func query(
            _ type: HKQuantityType,
            unit: HKUnit
        ) async throws -> [Date: Double] {

            var interval = DateComponents()
            interval.day = 1

            return try await withCheckedThrowingContinuation { continuation in
                let query = HKStatisticsCollectionQuery(
                    quantityType: type,
                    quantitySamplePredicate: nil,
                    options: .cumulativeSum,
                    anchorDate: startDate,
                    intervalComponents: interval
                )

                query.initialResultsHandler = { _, results, _ in
                    guard let results else {
                        continuation.resume(returning: [:])
                        return
                    }

                    var values: [Date: Double] = [:]

                    results.enumerateStatistics(from: startDate, to: endDate) {
                        stats, _ in
                        let value =
                            stats.sumQuantity()?.doubleValue(for: unit) ?? 0
                        values[calendar.startOfDay(for: stats.startDate)] = value
                    }

                    continuation.resume(returning: values)
                }

                healthStore.execute(query)
            }
        }

        let steps = try await query(stepsType, unit: .count())
        let calories = try await query(caloriesType, unit: .kilocalorie())

        return (0..<7).map { offset in
            let date = calendar.startOfDay(
                for: calendar.date(byAdding: .day, value: -offset, to: endDate)!
            )

            return DailyTrend(
                date: date,
                steps: Int(steps[date] ?? 0),
                activeCalories: calories[date] ?? 0
            )
        }
        .reversed()
    }

    /// Requests read authorization for required HealthKit data.
    /// - Returns: Current authorization status.
    /// - Throws: `HealthError` when HealthKit is unavailable or fails.
    func requestAuthorization() async throws -> HealthAuthorizationStatus {

        /// Ensure HealthKit is supported on this device.
        guard HKHealthStore.isHealthDataAvailable() else {
            throw HealthError.healthDataUnavailable
        }

        /// Define the HealthKit data types the app needs to read.
        guard
            let stepType = HKObjectType.quantityType(forIdentifier: .stepCount),
            let energyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
        else {
            throw HealthError.unknown
        }

        let typesToRead: Set<HKObjectType> = [stepType, energyType]

        /// Bridge HealthKit's callback-based API to async/await.
        return try await withCheckedThrowingContinuation { continuation in
            healthStore.requestAuthorization(
                toShare: [],
                read: typesToRead
            ) { success, error in

                if let _ = error {
                    continuation.resume(throwing: HealthError.unknown)
                } else if success {
                    continuation.resume(returning: .authorized)
                } else {
                    continuation.resume(returning: .denied)
                }
            }
        }
    }
}

// MARK: - Health Data Fetching

extension HealthKitService {

    /// Fetches today's aggregated health summary.
    /// - Returns: `HealthSummary` containing steps and active calories.
    /// - Throws: `HealthError` or HealthKit query errors.
    func fetchTodaySummary() async throws -> HealthSummary {
        print("🚨 HealthKitService.fetchTodaySummary CALLED")
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let now = Date()

        let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let caloriesType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!

        func sum(
            _ type: HKQuantityType,
            unit: HKUnit
        ) async throws -> Double {

            let predicate = HKQuery.predicateForSamples(
                withStart: startOfDay,
                end: now,
                options: .strictStartDate
            )

            return try await withCheckedThrowingContinuation { continuation in
                let query = HKStatisticsQuery(
                    quantityType: type,
                    quantitySamplePredicate: predicate,
                    options: .cumulativeSum
                ) { _, result, error in

                    let value = result?
                        .sumQuantity()?
                        .doubleValue(for: unit) ?? 0

                    continuation.resume(returning: value)
                }

                healthStore.execute(query)
            }
        }

        async let steps = sum(stepsType, unit: .count())
        async let calories = sum(caloriesType, unit: .kilocalorie())

        return HealthSummary(
            steps: Int(try await steps),
            activeCalories: Int(try await calories)
        )
    }
}
