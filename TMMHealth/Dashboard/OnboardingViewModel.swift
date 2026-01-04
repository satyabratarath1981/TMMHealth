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
    
    func simulatePermissionResult(granted: Bool) async {
        state = .requestingPermission
        try? await Task.sleep(for: .seconds(1.2))
        state = granted ? .completed : .denied
    }
}


