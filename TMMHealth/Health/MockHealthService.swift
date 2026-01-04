//
//  MockHealthService.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 04/01/26.
//

import Foundation

final class MockHealthService: HealthService {

    let shouldGrantPermission: Bool

    init(shouldGrantPermission: Bool = true) {
        self.shouldGrantPermission = shouldGrantPermission
    }

    func requestAuthorization() async throws -> HealthAuthorizationStatus {
        try await Task.sleep(for: .seconds(1))
        return shouldGrantPermission ? .authorized : .denied
    }
}
