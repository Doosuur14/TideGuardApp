//
//  FloodRiskResponse.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 28.10.2025.
//

import Foundation

struct FloodRiskResponse: Codable {
    let city: String
    let latitude: Double
    let longitude: Double
    let fri: Double
    let riskLevel: String
    let rainfall: Double
    let soilSaturation: Double
    let floodHistory: Double
    let shelters: [Shelter]
}
