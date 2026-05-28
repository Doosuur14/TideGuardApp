//
//  FloodReport.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 27.05.2026.



import Foundation

struct FloodReport: Codable {
    let id: Int64
    let latitude: Double
    let longitude: Double
    let severity: String
    let description: String
    let photoUrl: String?
    let fileName: String?

    var severityLevel: Int {
        switch severity.lowercased() {
        case "severe":   return 2
        case "moderate": return 1
        default:         return 0
        }
    }

    var severityDisplayName: String {
        switch severity.lowercased() {
        case "severe":   return "🔴 Severe"
        case "moderate": return "🟠 Moderate"
        default:         return "🟡 Minor"
        }
    }
}
