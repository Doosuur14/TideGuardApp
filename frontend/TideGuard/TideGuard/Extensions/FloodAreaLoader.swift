//
//  FloodAreaLoader.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 01.11.2025.
//

import Foundation
import MapKit

class FloodAreaLoader {
    static let shared = FloodAreaLoader()

    func loadFloodArea(for city: String, riskLevel: String) -> [MKPolygon]? {
        guard let url = Bundle.main.url(forResource: "FloodAreas", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            return nil
        }

        for cityData in jsonArray {
            if let name = cityData["city"] as? String,
               name.lowercased() == city.lowercased(),
               let floodAreas = cityData["floodAreas"] as? [[String: Any]] {

                var polygons: [MKPolygon] = []

                for area in floodAreas {
                    if let coordinates = area["coordinates"] as? [[String: Double]] {
                        let coords = coordinates.map {
                            CLLocationCoordinate2D(latitude: $0["latitude"]!, longitude: $0["longitude"]!)
                        }
                        let polygon = MKPolygon(coordinates: coords, count: coords.count)
                        polygon.title = riskLevel
                        polygons.append(polygon)
                    }
                }
                return polygons
            }
        }
        return nil
    }
}
