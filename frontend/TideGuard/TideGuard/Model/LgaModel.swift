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


    let tp: Double
    let ro: Double
    let t2m: Double
    let swvl1: Double

    
    let tp_7d: Double
    let tp_14d: Double
    let tp_30d: Double
    let ro_7d: Double
    let ro_14d: Double
    let swvl1_3d_change: Double
    let tp_7d_max: Double

    var month: Double = 0
    var day_of_year: Double = 0
    var state_encoded: Double = 0


    var floodProbability: Int64?
    var floodPrediction: Int?

    enum CodingKeys: String, CodingKey {
        case lgaName, state, latitude, longitude
        case tp, ro, t2m, swvl1
        case tp_7d           = "tp7d"
        case tp_14d          = "tp14d"
        case tp_30d          = "tp30d"
        case ro_7d           = "ro7d"
        case ro_14d          = "ro14d"
        case swvl1_3d_change = "swvl1_3dChange"
        case tp_7d_max       = "tp7dMax"
        case floodProbability, floodPrediction
    }
}


//struct LgaModel: Codable {
//
//    let lgaName: String
//    let state: String
//    let latitude: Double
//    let longitude: Double
//
//
//    let tp: Double
//    let ro: Double
//    let t2m: Double
//    let swvl1: Double
//
//    // Rolling rainfall features
//    let tp_7d: Double
//    let tp_14d: Double
//    let tp_30d: Double
//    let tp_7d_max: Double
//
//    // Rolling runoff
//    let ro_7d: Double
//    let ro_14d: Double
//
//    // Soil moisture trend
//    let swvl1_3d_change: Double
//
//    // Computed on device
//    var month: Double = 0
//    var day_of_year: Double = 0
//    var state_encoded: Double = 0
//
//    // Model output
//    var floodProbability: Int64?
//    var floodPrediction: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case lgaName, state, latitude, longitude
//        case tp, ro, t2m, swvl1
//        case tp_7d, tp_14d, tp_30d, tp_7d_max
//        case ro_7d, ro_14d
//        case swvl1_3d_change
//        case floodProbability, floodPrediction
//    }
//}
