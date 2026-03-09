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

    case polygonsReady(
        [(polygon: MKPolygon,
          risk: Int)]
    )
    case weatherLoaded(description: String,
                       temp: Double,
                       humidity: Double,
                       imageUrl: String?,
                       weeklyForecast: [WeatherData.DailyForecast]
    )

    case onMapUpdate(MKCoordinateRegion)
    case error(String)
}

class SafetyViewModel {

    @Published private(set) var state: SafetyState = .idle

    private let model = try? FloodRiskModel(configuration: MLModelConfiguration())

    private var cancellables = Set<AnyCancellable>()

    var lgasCache: [LgaModel] = []


    func loadMap() {
        state = .loading
        let user = AuthService.shared.getCurrentUser()
        let userCity = user?.city ?? ""

        print("Loading LGAs for state: \(userCity)")

        LgaAPIService.shared.getLgasByState(for: userCity) { [weak self] lgas in
            guard let self = self else { return }

            DispatchQueue.main.async {
                guard let lgas = lgas, !lgas.isEmpty else {
                    self.state = .error("Failed to load LGAs")
                    return
                }

                self.lgasCache = lgas

                let avgLat = lgas.map { $0.latitude }.reduce(0, +) / Double(lgas.count)
                let avgLon = lgas.map { $0.longitude }.reduce(0, +) / Double(lgas.count)

                let region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: avgLat, longitude: avgLon),
                    latitudinalMeters: 30000,
                    longitudinalMeters: 30000
                )

                self.state = .onMapUpdate(region)
                self.state = .loadedLGAs(lgas)
            }
        }
    }


    func fetchWeather() {
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
                        imageUrl: data.imageUrl, weeklyForecast: data.weeklyForecast ?? []
                    )
                case .failure:
                    self.state = .weatherLoaded(
                        description: "Weather unavailable",
                        temp: 0.0,
                        humidity: 0.0,
                        imageUrl: nil,
                        weeklyForecast: []
                    )
                }
            }
        }
    }


    func loadFullFloodMap() {
        print("Loading Nigeria LGA GeoJSON")

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
        guard let model = model else {
            return 0
        }

        enrichLgaWithComputedFeatures(lga: &lga)

        do {
            let input = FloodRiskModelInput(
                tp:              lga.tp,
                ro:              lga.ro,
                t2m:             lga.t2m,
                swvl1:           lga.swvl1,
                tp_7d:           lga.tp_7d,
                tp_14d:          lga.tp_14d,
                tp_30d:          lga.tp_30d,
                ro_7d:           lga.ro_7d,
                ro_14d:          lga.ro_14d,
                swvl1_3d_change: lga.swvl1_3d_change,
                tp_7d_max:       lga.tp_7d_max,
                latitude:        lga.latitude,
                longitude:       lga.longitude,
                month:           lga.month,
                day_of_year:     lga.day_of_year,
                state_encoded:   lga.state_encoded
            )

            let prediction = try model.prediction(input: input)
            let riskScore = prediction.floodRisk
            let clampedScore = max(0.0, min(1.0, riskScore))
            lga.floodProbability = Int64(clampedScore * 100)

            let category = riskScore >= 0.6 ? 2 :
            riskScore >= 0.3 ? 1 :
            0    

            lga.floodPrediction = category
            return category

        } catch {
            print("Prediction failed: \(error)")
            return 0
        }
    }



    func predictMonthlyRisk(for lga: LgaModel) -> [Int] {
        var monthlyRisks: [Int] = []

        for month in 1...12 {
            var mutableLga = lga
            mutableLga.month = Double(month)
            // Use middle of each month as day_of_year
            let middleDays = [15, 46, 75, 105, 135, 166, 196, 227, 258, 288, 319, 349]
            mutableLga.day_of_year = Double(middleDays[month - 1])
            let risk = predictFloodRisk(for: &mutableLga)
            monthlyRisks.append(risk)
        }

        return monthlyRisks
    }


    func enrichLgaWithComputedFeatures(lga: inout LgaModel) {
        let calendar = Calendar.current
        let now = Date()

        lga.month = Double(calendar.component(.month, from: now))

        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now))!
        let dayOfYear = calendar.dateComponents([.day], from: startOfYear, to: now).day! + 1
        lga.day_of_year = Double(dayOfYear)

        lga.state_encoded = stateEncoding[lga.state.lowercased()] ?? 0
    }

    let stateEncoding: [String: Double] = [
        "abia": 0, "adamawa": 1, "akwa ibom": 2, "anambra": 3,
        "bauchi": 4, "bayelsa": 5, "benue": 6, "borno": 7,
        "cross river": 8, "delta": 9, "ebonyi": 10, "edo": 11,
        "ekiti": 12, "enugu": 13, "federal capital territory": 14,
        "gombe": 15, "imo": 16, "jigawa": 17, "kaduna": 18,
        "kano": 19, "katsina": 20, "kebbi": 21, "kogi": 22,
        "kwara": 23, "lagos": 24, "nasarawa": 25, "niger": 26,
        "ogun": 27, "ondo": 28, "osun": 29, "oyo": 30,
        "plateau": 31, "rivers": 32, "sokoto": 33, "taraba": 34,
        "yobe": 35, "zamfara": 36
    ]


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
