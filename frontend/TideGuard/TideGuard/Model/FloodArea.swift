//
//  FloodArea.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 03.05.2025.
//

import Foundation

struct FloodArea: Codable {
    let city: String?
    let floodAreas: [FloodZone]?

    struct FloodZone: Codable {
        let coordinates: [Coordinate]?
    }

    struct Coordinate: Codable {
        let latitude: Double?
        let longitude: Double?
    }
}
