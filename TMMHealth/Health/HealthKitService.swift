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

        /// Define HealthKit quantity types.
        guard
            let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount),
            let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)
        else {
            throw HealthError.unknown
        }

        /// Create a predicate for samples from the start of today.
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: Date(),
            options: .strictStartDate
        )

        /// Fetch steps and calories concurrently for better performance.
        async let steps = fetchCumulativeQuantity(
            type: stepType,
            predicate: predicate,
            unit: .count()
        )

        async let calories = fetchCumulativeQuantity(
            type: energyType,
            predicate: predicate,
            unit: .kilocalorie()
        )

        /// Combine results into a single domain model.
        return try await HealthSummary(
            steps: Int(steps),
            activeCalories: Int(calories)
        )
    }

    /// Executes a cumulative HealthKit statistics query.
    /// - Parameters:
    ///   - type: Quantity type (e.g., steps, calories)
    ///   - predicate: Date range predicate
    ///   - unit: Measurement unit
    /// - Returns: Aggregated value for the given type.
    private func fetchCumulativeQuantity(
        type: HKQuantityType,
        predicate: NSPredicate,
        unit: HKUnit
    ) async throws -> Double {

        /// Bridge HKStatisticsQuery to async/await.
        try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: type,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, error in

                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                /// Extract the cumulative value or default to zero.
                let value = result?.sumQuantity()?.doubleValue(for: unit) ?? 0
                continuation.resume(returning: value)
            }

            /// Execute the HealthKit query.
            healthStore.execute(query)
        }
    }
}
