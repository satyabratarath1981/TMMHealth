//
//  DailyTrend.swift
//  TMMHealth
//
//  Created by Satyabrata Rath on 06/01/26.
//

import Foundation

struct DailyTrend: Identifiable {
    let id = UUID()
    let date: Date
    let steps: Int
    let activeCalories: Double
}

