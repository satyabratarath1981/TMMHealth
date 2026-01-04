//
//  HealthService.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 03/01/26.
//

import Foundation

enum HealthAuthorizationStatus {
    case notDetermined
    case restricted
    case authorized
    case denied
}

protocol HealthService {
    func requestAuthorization() async throws -> HealthAuthorizationStatus
}
