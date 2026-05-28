//
//  FloodForecast.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 12.03.2026.
//

import Foundation


//struct FloodForecast: Codable {
//
//    let date: String
//    let dayName: String
//    let tp: Double
//    let ro: Double
//    let t2m: Double
//    let swvl1: Double
//    let tp_7d: Double
//    let tp_14d: Double
//    let tp_30d: Double
//    let tp_7d_max: Double
//    let ro_7d: Double
//    let ro_14d: Double
//    let swvl1_3d_change: Double
//    let latitude: Double
//    let longitude: Double
//    let month: Int
//    let dayOfYear: Int
//}


struct FloodForecast: Codable {

    var date: String
    var dayName: String
    var tp: Double
    var ro: Double
    var t2m: Double
    var swvl1: Double
    var tp_7d: Double
    var tp_14d: Double
    var tp_30d: Double
    var tp_7d_max: Double
    var ro_7d: Double
    var ro_14d: Double
    var swvl1_3d_change: Double
    var latitude: Double
    var longitude: Double
    var month: Int
    var dayOfYear: Int
}

struct FloodRiskDay {
    let date: String
    let dayName: String
    let riskLevel: Int
    let probability: Double 
}
