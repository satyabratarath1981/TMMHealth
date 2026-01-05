//
//  OnboardingViewModel.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 03/01/26.
//

import Foundation
import Combine

/// Represents the different states of the onboarding flow.
/// Drives which onboarding UI is rendered.
enum OnboardingState {
    
    /// Initial state before any user interaction.
    case idle
    
    /// Health permission request is in progress.
    case requestingPermission
    
    /// Health access granted and onboarding completed.
    case completed
    
    /// Health access denied or failed.
    case denied
}

/// ViewModel responsible for managing onboarding logic
/// and handling Health authorization.
@MainActor
final class OnboardingViewModel: ObservableObject {

    /// Current onboarding state used by `OnboardingView`
    /// to render the appropriate UI.
    @Published var state: OnboardingState = .idle
    
    /// (Optional / Future Use)
    /// Dashboard state placeholder if onboarding needs
    /// to influence dashboard behavior.
    /// ⚠️ Consider removing if unused to avoid confusion.
    @Published var state2: DashboardState = .loading

    /// Abstraction over health-related operations.
    /// Enables dependency injection and unit testing.
    private let healthService: HealthService

    /// Designated initializer with default HealthKit implementation.
    init(healthService: HealthService = HealthKitService()) {
        self.healthService = healthService
    }

    /// Initiates the Health authorization flow.
    /// Updates onboarding state based on authorization result.
    func connectHealth() async {
        /// Reflect loading state immediately in the UI.
        state = .requestingPermission

        do {
            /// Request Health authorization asynchronously.
            let status = try await healthService.requestAuthorization()
            
            /// Transition to completed or denied state
            /// based on the authorization result.
            state = status == .authorized ? .completed : .denied
        } catch {
            /// Fallback to denied state on error.
            state = .denied
        }
    }
}

