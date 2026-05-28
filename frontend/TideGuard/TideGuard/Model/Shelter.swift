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
    let city: String
    let lga: String
    let latitude: Double
    let longitude: Double
    let capacity: Int
    let type: String
    let address: String?
    let phoneNumber: String?
    var distanceKm: Double?

    var typeDisplayName: String {
        switch type {
        case "IDP_CAMP":
            return "IDP Camp"
        case "STADIUM":
            return "Stadium"
        case "SCHOOL":
            return "School"
        case "COMMUNITY_CENTER":
            return "Community Center"
        default:
            return type.capitalized
        }
    }

    var capacityFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: capacity)) ?? "\(capacity)"
    }

    var displayAddress: String {
        return address ?? "\(lga), \(city)"
    }
}


struct SheltersResponse: Codable {
    let shelters: [Shelter]
}
