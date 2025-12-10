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

    private let model = try? FloodRiskPredictor(configuration: MLModelConfiguration())

    private var cancellables = Set<AnyCancellable>()
    private let locationService = LocationService.shared




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

            let output = try model?.prediction(input: array)

            return Int(output?.classLabel ?? 0)

        } catch {
            print("Prediction failed: \(error)")
            return 0
        }
    }


    func loadStateMap() {
        state = .loading
        print("Loading map region using LocationService")
        let user = AuthService.shared.getCurrentUser()
        guard let state = user?.city else {
            print("No user state, using Nigeria region")
            let nigeriaRegion = locationService.getNigeriaRegion()
            DispatchQueue.main.async {
                self.state = .onMapUpdate(nigeriaRegion)
            }
            return
        }

        print("User state: \(state)")

        print("Getting coordinates for state: \(state)")
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
                    self?.state = .onMapUpdate(region)
                }

            case .failure(let error):
                print("LocationService failed: \(error), using Nigeria region")
                let nigeriaRegion = self?.locationService.getNigeriaRegion() ?? MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 9.0820, longitude: 8.6753),
                    latitudinalMeters: 18000,
                    longitudinalMeters: 18000
                )
                DispatchQueue.main.async {
                    self?.state = .onMapUpdate(nigeriaRegion)
                }
            }
        }
    }



    private func processFloodMap(features: [MKGeoJSONFeature], lgaData: [LgaModel]) -> [(polygon: MKPolygon, risk: Int)] {

        var results: [(MKPolygon, Int)] = []

        for feature in features {
            guard let properties = feature.properties,
                  let json = try? JSONSerialization.jsonObject(with: properties) as? [String: Any],
                  let lgaName = json["lga_name"] as? String else {
                continue
            }

            if let lga = lgaData.first(where: { $0.lgaName.caseInsensitiveCompare(lgaName) == .orderedSame }) {

                let risk = predictFloodRisk(for: lga)

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

