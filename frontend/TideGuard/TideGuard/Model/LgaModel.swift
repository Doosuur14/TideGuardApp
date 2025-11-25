//
//  LgaModel.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 14.11.2025.
//

import Foundation


struct LgaModel: Codable {
    
    let lgaName: String
    let state: String
    let latitude: Double
    let longitude: Double
    let rainfall: Double
    let rainfallLast3Days:Double
    let rainfallLast7Days: Double
    let runoff: Double
    let runoffMaxLast3Days: Double
    let soilMoisture: Double
    let soilMoistureChange7Days: Double
    let airTemp: Double
    let evaporation: Double
}
