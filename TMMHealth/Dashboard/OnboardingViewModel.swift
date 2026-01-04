//
//  OnboardingViewModel.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 03/01/26.
//

import Foundation
import Combine

enum OnboardingState {
    case idle
    case requestingPermission
    case completed
    case denied
}

@MainActor
final class OnboardingViewModel: ObservableObject {

    @Published var state: OnboardingState = .idle

    private let healthService: HealthService

    init(healthService: HealthService = HealthKitService()) {
        self.healthService = healthService
    }

    func connectHealth() async {
        state = .requestingPermission

        do {
            let status = try await healthService.requestAuthorization()
            state = status == .authorized ? .completed : .denied
        } catch {
            state = .denied
        }
    }
}

