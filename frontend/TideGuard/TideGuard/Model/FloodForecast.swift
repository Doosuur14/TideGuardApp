//
//  FloodForecast.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 12.03.2026.
//

import Foundation


struct FloodForecast: Codable {

    let date: String
    let dayName: String
    let tp: Double
    let ro: Double
    let t2m: Double
    let swvl1: Double
    let tp_7d: Double
    let tp_14d: Double
    let tp_30d: Double
    let tp_7d_max: Double
    let ro_7d: Double
    let ro_14d: Double
    let swvl1_3d_change: Double
    let latitude: Double
    let longitude: Double
    let month: Int
    let dayOfYear: Int
}

struct FloodRiskDay {
    let date: String
    let dayName: String
    let riskLevel: Int
    let probability: Double 
}
