//
//  LgaModel.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 14.11.2025.
//

import Foundation


//struct LgaModel: Codable {
//    
//    let lgaName: String
//    let state: String
//    let latitude: Double
//    let longitude: Double
//
//    let rainfall1d: Double
//    let rainfall3dAvg: Double
//    let rainfall7dAvg: Double
//    let rainfall7dMax: Double
//    let rainfall7dCumulative: Double
//
//    let soilMoistureCurrent: Double
//    let soilMoisture7dAvg: Double
//
//    let runoffTotal7d: Double
//    let surfaceRunoff7d: Double
//
//    let temperatureCurrent: Double
//    let temperature7dAvg: Double
//
////    let evaporation7d: Double
//
//    var floodProbability: Int64?      
//    var floodPrediction: Int?
//}



struct LgaModel: Codable {
    let lgaName: String
    let state: String
    let latitude: Double
    let longitude: Double

    // Single day ERA5 features
    let tp: Double          // total precipitation (was rainfall1d)
    let ro: Double          // runoff
    let t2m: Double         // temperature (was temperatureCurrent)
    let swvl1: Double       // soil moisture (was soilMoistureCurrent)

    // Rolling window features
    let tp_7d: Double       // 7 day cumulative rainfall
    let tp_14d: Double      // 14 day cumulative rainfall
    let tp_30d: Double      // 30 day cumulative rainfall
    let ro_7d: Double       // 7 day cumulative runoff
    let ro_14d: Double      // 14 day cumulative runoff
    let swvl1_3d_change: Double  // soil moisture 3 day change
    let tp_7d_max: Double   // max rainfall in last 7 days

    // Date features (computed, not fetched)
    var month: Double
    var day_of_year: Double
    var state_encoded: Double

    var floodProbability: Int64?
    var floodPrediction: Int?
}
