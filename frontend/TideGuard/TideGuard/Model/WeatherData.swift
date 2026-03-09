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
    let precipitation: Double?
    let weeklyForecast: [DailyForecast]?

    struct DailyForecast: Codable {
        let date: String?
        let maxTemp: Double?
        let minTemp: Double?
        let weatherCode: Int?
        let precipitation: Double?
        let description: String?
        let icon: String?
    }

}
