//
//  FloodRiskLevel.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 22.05.2026.
//

import Foundation
import UIKit

enum FloodRiskLevel: Int {
    case low = 0
    case moderate = 1
    case high = 2
    case severe = 3

    var displayName: String {
        switch self {
        case .low:      return "Низкий"
        case .moderate: return "Умеренный"
        case .high:     return "Высокий"
        case .severe:   return "Критический"
        }
    }

    var color: UIColor {
        switch self {
        case .low:      return .systemGreen
        case .moderate: return .systemYellow
        case .high:     return .systemOrange
        case .severe:   return .systemRed
        }
    }

    static func from(riskValue: Int) -> FloodRiskLevel {
        switch riskValue {
        case 2:  return .high
        case 1:  return .moderate
        default: return .low
        }
    }
}
