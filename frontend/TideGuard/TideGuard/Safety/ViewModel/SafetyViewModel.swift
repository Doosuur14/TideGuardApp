//
//  SafetyViewModel.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 17.04.2025.
//

import Foundation
import CoreLocation
import MapKit
import CoreML

class SafetyViewModel {

    private var evacuationData: String?
    private var shelters: [String] = []
    private var routes: [String] = []
    private let model = FloodRiskPredictor()
    private let locationService = LocationService.shared // Add this

    var onEvacuationUpdate: ((String) -> Void)?
    var onSheltersUpdate: (([MKAnnotation]) -> Void)?
    var onGeoJsonPolygonsReady: (([(polygon: MKPolygon, risk: Int)]) -> Void)?
    var onMapUpdate: ((MKCoordinateRegion) -> Void)?
    var onFloodLgaUpdate: (([LgaModel]) -> Void)?
    var onWeatherUpdate: ((String, Double, Double, String?) -> Void)?


    func loadEvacuationData() {
        print("gooooooo")
        let user = AuthService.shared.getCurrentUser()
        let userCity = user?.city
        print("User Details for evacuationdata: \(String(describing: user))")
        print("User city for evacuationdata: \(String(describing: userCity))")

        WeatherService.shared.fetchEvacuationData (for: userCity ?? "") { [weak self] result in
            switch result {
            case .success(let evacuation):
                let displayText = "Shelters in \(evacuation.city):\n\(evacuation.shelters)\nRoute:\n\(evacuation.routes)"
                self?.evacuationData = displayText
                UserDefaults.standard.set(displayText, forKey: "evacuationData")
                self?.onEvacuationUpdate?(displayText)
            case .failure(let error):
                self?.onEvacuationUpdate?("Failed to load evacuation data: \(error.localizedDescription)")
            }
        }
    }



    func loadMap() {
        print("get flood data from lga")
        let user = AuthService.shared.getCurrentUser()
        let userCity = user?.city
        print("User Details for flooddata: \(String(describing: user))")
        print("User city for flooddata: \(String(describing: userCity))")

        print("Loading LGAs for state: \(String(describing: userCity))")
        LgaAPIService.shared.getLgasByState( for: userCity ?? "") { [weak self] lgas in
            guard let lgas = lgas else {
                return
            }
            DispatchQueue.main.async {
                self?.onFloodLgaUpdate?(lgas)
            }
        }
    }



    func fetchWeather() {
        let user = AuthService.shared.getCurrentUser()
        let userCity = user?.city
        print("User Details for weather: \(String(describing: user))")
        print("User city for weather: \(String(describing: userCity))")

        WeatherService.shared.fetchWeather(for: userCity ?? "") { [weak self] result in
            switch result {
            case .success(let weatherData):
                let description = weatherData.description ?? "Nothing to see here"
                let temperature = weatherData.temperature ?? 0.0
                let humidity = weatherData.humidity ?? 0.0
                let imageUrl = weatherData.imageUrl
                DispatchQueue.main.async {
                    self?.onWeatherUpdate?(description, temperature, humidity, imageUrl)
                }
            case .failure(let error):
                print("Failed to fetch weather: \(error)")
                DispatchQueue.main.async {
                    self?.onWeatherUpdate?("N/A", 0.0, 0.0, nil)
                }
            }
        }
    }


    func loadFullFloodMap() {
        print("🌍 Loading Nigeria LGA GeoJSON + Env Data…")

        // 1️⃣ Fetch environmental data
        LgaAPIService.shared.getAllLgas { [weak self] lgaData in
            guard let self = self, let lgaData = lgaData else { return }

            // 2️⃣ Fetch the geojson
            LgaAPIService.shared.getNigeriaGeoJSON { geoJson in
                guard let geoJson = geoJson else { return }

                // 3️⃣ Decode GeoJSON
                let decoder = MKGeoJSONDecoder()

                do {
                    let features = try decoder.decode(geoJson)
                        .compactMap { $0 as? MKGeoJSONFeature }

                    // 4️⃣ Process polygons + match flood data
                    let results = self.processFloodMap(features: features, lgaData: lgaData)

                    DispatchQueue.main.async {
                        self.onGeoJsonPolygonsReady?(results)
                    }

                } catch {
                    print("❌ Failed to decode GeoJSON: \(error)")
                }
            }
        }
    }



    private func processFloodMap(features: [MKGeoJSONFeature], lgaData: [LgaModel]) -> [(polygon: MKPolygon, risk: Int)] {

        var results: [(MKPolygon, Int)] = []

        for feature in features {
            guard let propertiesData = feature.properties,
                  let propertiesJSON = try? JSONSerialization.jsonObject(with: propertiesData) as? [String: Any],
                  let lgaName = propertiesJSON["lga_name"] as? String else {
                continue
            }
            print("⚠️ Missing lga_name in feature properties: \(propertiesJSON)")

            if let lga = lgaData.first(where: { $0.lgaName.caseInsensitiveCompare(lgaName) == .orderedSame }) {

                let risk = predictFloodRisk(for: lga)


                for geometry in feature.geometry {
                    if let polygon = geometry as? MKPolygon {
                        polygon.title = "\(risk)"  // attach risk
                        results.append((polygon, risk))
                    }
                }
            }
        }

        return results
    }




    func predictFloodRisk(for lga: LgaModel) -> Int {
        do {

            let array = try MLMultiArray(shape: [11], dataType: .double)

            array[0] = NSNumber(value: lga.latitude)
            array[1] = NSNumber(value: lga.longitude)
            array[2] = NSNumber(value: lga.rainfall)
            array[3] = NSNumber(value: lga.rainfallLast3Days)
            array[4] = NSNumber(value: lga.rainfallLast7Days)
            array[5] = NSNumber(value: lga.runoff)
            array[6] = NSNumber(value: lga.runoffMaxLast3Days)
            array[7] = NSNumber(value: lga.soilMoisture)
            array[8] = NSNumber(value: lga.soilMoistureChange7Days)
            array[9] = NSNumber(value: lga.airTemp)
            array[10] = NSNumber(value: lga.evaporation)

            let output = try model.prediction(input: array)

            return Int(output.classLabel)

        } catch {
            print("Prediction failed: \(error)")
            return 0
        }
    }


    func loadStateMap() {
        print("🗺️ Loading map region using LocationService")
        let user = AuthService.shared.getCurrentUser()
        guard let state = user?.city else {
            print("❌ No user state, using Nigeria region")
            let nigeriaRegion = locationService.getNigeriaRegion()
            DispatchQueue.main.async {
                self.onMapUpdate?(nigeriaRegion)
            }
            return
        }

        print("📍 User state: \(state)")

        // Use hardcoded Lagos coordinates
//        if state.lowercased() == "lagos" {
//            print("🎯 USING HARDCODED LAGOS COORDINATES")
//            let lagosCoordinate = CLLocationCoordinate2D(latitude: 6.5244, longitude: 3.3792)
//            let lagosRegion = MKCoordinateRegion(
//                center: lagosCoordinate,
//                latitudinalMeters: 50000,
//                longitudinalMeters: 50000
//            )
//            DispatchQueue.main.async {
//                self.onMapUpdate?(lagosRegion) // ✅ Fixed
//            }
//            return
//        }

        // For other states, try geocoding
        print("📍 Getting coordinates for state: \(state)")
        locationService.getCoordinate(for: state) { [weak self] result in
            switch result {
            case .success(let coordinate):
                print("LocationService found coordinates: \(coordinate.latitude), \(coordinate.longitude)")
                let region = MKCoordinateRegion(
                    center: coordinate,
                    latitudinalMeters: 18000,
                    longitudinalMeters: 18000
                )
                DispatchQueue.main.async {
                    self?.onMapUpdate?(region)
                }

            case .failure(let error):
                print("LocationService failed: \(error), using Nigeria region")
                let nigeriaRegion = self?.locationService.getNigeriaRegion() ?? MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 9.0820, longitude: 8.6753),
                    latitudinalMeters: 18000,
                    longitudinalMeters: 18000
                )
                DispatchQueue.main.async {
                    self?.onMapUpdate?(nigeriaRegion)
                }
            }
        }
    }
}
