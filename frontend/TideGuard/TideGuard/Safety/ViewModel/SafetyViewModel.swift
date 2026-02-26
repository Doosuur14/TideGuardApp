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
import Combine

enum SafetyState {
    case idle
    case loading
    case loadedLGAs([LgaModel])
    case polygonsReady([(polygon: MKPolygon, risk: Int)])
    case weatherLoaded(description: String, temp: Double, humidity: Double, imageUrl: String?)
    case onMapUpdate(MKCoordinateRegion)
    case error(String)
}

class SafetyViewModel {

    @Published private(set) var state: SafetyState = .idle

    private let model = try? FloodRiskModel(configuration: MLModelConfiguration())

    private var cancellables = Set<AnyCancellable>()

//    private let locationService = LocationService.shared
    var lgasCache: [LgaModel] = []



    func loadMap() {

        state = .loading
        print("get flood data from lga")
        let user = AuthService.shared.getCurrentUser()
        let userCity = user?.city ?? ""
        print("User Details for flooddata: \(String(describing: user))")
        print("User city for flooddata: \(String(describing: userCity))")

        print("Loading LGAs for state: \(String(describing: userCity))")
        LgaAPIService.shared.getLgasByState(for: userCity) { [weak self] lgas in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let lgas = lgas {
                    self.lgasCache = lgas
                    self.state = .loadedLGAs(lgas)
                } else {
                    self.state = .error("Failed to load LGAs")
                }
            }
        }
    }


    func fetchWeather() {
        state = .loading

        let user = AuthService.shared.getCurrentUser()
        let userCity = user?.city ?? ""

        WeatherService.shared.fetchWeather(for: userCity) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.state = .weatherLoaded(
                        description: data.description ?? "No description",
                        temp: data.temperature ?? 0.0,
                        humidity: data.humidity ?? 0.0,
                        imageUrl: data.imageUrl
                    )
                case .failure:
                    self.state = .error("Failed to fetch weather")
                }
            }
        }
    }


    func loadFullFloodMap() {
        state = .loading

        print("Loading Nigeria LGA GeoJSON + Env Data…")

        LgaAPIService.shared.getAllLgas { [weak self] lgaData in
            guard let self = self, let lgaData = lgaData else { return }

            LgaAPIService.shared.getNigeriaGeoJSON { geoJson in
                guard let geoJson = geoJson else { return }


                let decoder = MKGeoJSONDecoder()

                do {
                    let features = try decoder.decode(geoJson)
                        .compactMap { $0 as? MKGeoJSONFeature }

                    let results = self.processFloodMap(features: features, lgaData: lgaData)

                    DispatchQueue.main.async {
                        self.state = .polygonsReady(results)
                    }

                } catch {
                    DispatchQueue.main.async {
                        self.state = .error("Failed to decode GeoJSON")
                    }
                }
            }
        }
    }



    func predictFloodRisk(for lga: inout LgaModel) -> Int {
        if let cachedPrediction = lga.floodPrediction {
            return cachedPrediction
        }

        guard let model = model else { return 0 }

        do {
            // Named inputs - must match feature names exactly from training
            let input = FloodRiskModelInput(
                tp:               lga.tp,
                ro:               lga.ro,
                t2m:              lga.t2m,
                swvl1:            lga.swvl1,
                tp_7d:            lga.tp_7d,
                tp_14d:           lga.tp_14d,
                tp_30d:           lga.tp_30d,
                ro_7d:            lga.ro_7d,
                ro_14d:           lga.ro_14d,
                swvl1_3d_change:  lga.swvl1_3d_change,
                tp_7d_max:        lga.tp_7d_max,
                latitude:         lga.latitude,
                longitude:        lga.longitude,
                month:            lga.month,
                day_of_year:      lga.day_of_year,
                state_encoded:    lga.state_encoded
            )

//            let prediction = try model.prediction(input: input)
//
//            // Get flood probability (0.0 to 1.0)
//            if let floodProb = prediction.Flood_EventProbability[1] {
//                lga.floodProbability = Int64(floodProb * 100)
//            } else {
//                lga.floodProbability = 0
//            }
//
//            lga.floodPrediction = Int(prediction.Flood_Event)
//            return Int(prediction.Flood_Event)


            let prediction = try model.prediction(input: input)

            let riskScore = prediction.floodRisk

            lga.floodProbability = Int64(riskScore * 100)

            lga.floodPrediction = riskScore >= 0.6 ? 2 :  // High
                                  riskScore >= 0.3 ? 1 :  // Medium
                                                     0    // Low
            return Int(prediction.floodRisk)

        } catch {
            print("Prediction failed: \(error)")
            return 0
        }
    }




    func loadStateMap() {
        state = .loading

        let user = AuthService.shared.getCurrentUser()
        if let stateName = user?.city {
            print("Centering map on user's state using backend coordinates")

            LgaAPIService.shared.getLgasByState(for: stateName) { [weak self] lgas in
                guard let self = self, let lgas = lgas, !lgas.isEmpty else {
                    DispatchQueue.main.async {
                        self?.state = .onMapUpdate(self?.defaultNigeriaRegion() ?? MKCoordinateRegion())
                    }
                    return
                }

                let avgLat = lgas.map { $0.latitude }.reduce(0,+)/Double(lgas.count)
                let avgLong = lgas.map { $0.longitude }.reduce(0,+)/Double(lgas.count)

                let region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: avgLat, longitude: avgLong),
                    latitudinalMeters: 18000,
                    longitudinalMeters: 18000
                )

                DispatchQueue.main.async {
                    self.state = .onMapUpdate(region)
                }
            }
        } else {
            DispatchQueue.main.async {
                self.state = .onMapUpdate(self.defaultNigeriaRegion())
            }
        }
    }
    

    private func defaultNigeriaRegion() -> MKCoordinateRegion {
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 9.0820, longitude: 8.6753),
            latitudinalMeters: 1500000,
            longitudinalMeters: 1500000
        )
    }


    private func processFloodMap(features: [MKGeoJSONFeature], lgaData: [LgaModel]) -> [(polygon: MKPolygon, risk: Int)] {

        var results: [(MKPolygon, Int)] = []

        for feature in features {
            guard let properties = feature.properties,
                  let json = try? JSONSerialization.jsonObject(with: properties) as? [String: Any],
                  let lgaName = json["lga_name"] as? String else {
                continue
            }

            if let lgaConst = lgaData.first(where: { $0.lgaName.caseInsensitiveCompare(lgaName) == .orderedSame }) {

                var lga = lgaConst
                let risk = predictFloodRisk(for: &lga)

                for geometry in feature.geometry {
                    if let polygon = geometry as? MKPolygon {
                        polygon.title = "\(risk)"
                        results.append((polygon, risk))
                    }
                }
            }
        }
        return results
    }
}
