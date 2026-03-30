//
//  Shelter.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 28.10.2025.
//

import Foundation

struct Shelter: Codable, Identifiable {
    let id: Int64
    let name: String
    let state: String
    let lga: String
    let latitude: Double
    let longitude: Double
    let capacity: Int
    let type: String

    var typeDisplayName: String {
        switch type {
        case "IDP_CAMP":
            return "IDP Camp"
        case "STADIUM":
            return "Stadium"
        default:
            return type.capitalized
        }
    }

    var capacityFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: capacity)) ?? "\(capacity)"
    }
}


struct SheltersResponse: Codable {
    let shelters: [Shelter]
}
