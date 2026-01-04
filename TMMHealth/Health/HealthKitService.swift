//
//  HealthKitService.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 04/01/26.
//

import HealthKit

final class HealthKitService: HealthService {

    private let healthStore = HKHealthStore()

    func requestAuthorization() async throws -> HealthAuthorizationStatus {

        guard HKHealthStore.isHealthDataAvailable() else {
            throw HealthError.healthDataUnavailable
        }

        guard
            let stepType = HKObjectType.quantityType(forIdentifier: .stepCount),
            let energyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
        else {
            throw HealthError.unknown
        }

        let typesToRead: Set<HKObjectType> = [stepType, energyType]

        return try await withCheckedThrowingContinuation { continuation in
            healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
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
