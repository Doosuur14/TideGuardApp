//
//  WeatherData.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 08.05.2025.
//

import Foundation

struct WeatherData: Codable {
    let description: String?
    let temperature: Double?
    let humidity: Double?
    let imageUrl: String?
}
