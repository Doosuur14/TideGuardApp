//
//  SafetyViewModel.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 17.04.2025.
//

import Foundation
import CoreLocation
import MapKit


class SafetyViewModel {

    private var evacuationData: String?
    private var shelters: [String] = []
    private var routes: [String] = []

    var onEvacuationUpdate: ((String) -> Void)?
    var onSheltersUpdate: (([MKAnnotation]) -> Void)?
    var onMapUpdate: ((CLLocationCoordinate2D) -> Void)?
    var onFloodAreasUpdate: (([MKCircle]) -> Void)?
//    var onFloodAreasUpdate: (([MKPolygon]) -> Void)?
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
        let user = AuthService.shared.getCurrentUser()
        let userCity = user?.city
        print("User Details for flooddata: \(String(describing: user))")
        print("User city for flooddata: \(String(describing: userCity))")

        print("Fetching flood risk for city: \(String(describing: userCity))")
        WeatherService.shared.fetchFloodRisk(for: userCity ?? "" ) { [weak self] result in
            switch result {
            case .success(let riskData):
                print("✅ Flood risk data received for \(riskData.city)")


                let color: UIColor
                switch riskData.riskLevel {
                case "HIGH": color = .red
                case "MEDIUM": color = .orange
                default: color = .green
                }


                let cityCenter = CLLocationCoordinate2D(latitude: riskData.latitude, longitude: riskData.longitude)
                let circle = MKCircle(center: cityCenter, radius: 30000)
                circle.title = riskData.riskLevel
//                if let polygons = FloodAreaLoader.shared.loadFloodArea(for: userCity ?? "", riskLevel: riskData.riskLevel) {
//                    self?.onFloodAreasUpdate?(polygons)
//                }                
                self?.onFloodAreasUpdate?([circle])


                let annotations = riskData.shelters.map { shelter -> MKPointAnnotation in
                    let annotation = MKPointAnnotation()
                    annotation.title = shelter.name
                    annotation.subtitle = shelter.address
                    annotation.coordinate = CLLocationCoordinate2D(latitude: shelter.latitude, longitude: shelter.longitude)
                    return annotation
                }
                self?.onSheltersUpdate?(annotations)


                self?.onMapUpdate?(cityCenter)

            case .failure(let error):
                print("error loading map \(error)")
                self?.onFloodAreasUpdate?([])
            }
        }
    }


    //
    //    func loadMap() {
    //        let user = AuthService.shared.getCurrentUser()
    //        let userCity = user?.city
    //        print("User Details: \(String(describing: user))")
    //        print("User city: \(String(describing: userCity))")
    //
    //        WeatherService.shared.fetchFloodAreas(for: userCity ?? "") { [weak self] result in
    //            switch result {
    //            case .success(let floodArea):
    //                let floodAreas = floodArea.floodAreas?.compactMap { zone -> MKPolygon? in
    //                    guard let coords = zone.coordinates, !coords.isEmpty else { return nil }
    //                    let coordinates = coords.compactMap { coord -> CLLocationCoordinate2D? in
    //                        guard let lat = coord.latitude, let lon = coord.longitude else { return nil }
    //                        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    //                    }
    //                    print("Coordinates for polygon: \(coordinates)")
    //                    return MKPolygon(coordinates: coordinates, count: coordinates.count)
    //                } ?? []
    //                self?.onFloodAreasUpdate?(floodAreas)
    //            case .failure(let error):
    //                print("Failed to fetch flood areas: \(error)")
    //                self?.onFloodAreasUpdate?([])
    //            }
    //        }
    //
    //
    //        let geocoder = CLGeocoder()
    //        geocoder.geocodeAddressString(userCity ?? "") { [weak self] (placemarks, error) in
    //            if let error = error {
    //                print("Geocoding error: \(error.localizedDescription)")
    //                let fallbackCenter = CLLocationCoordinate2D(latitude: 9.0820, longitude: 8.6753)
    //                self?.onMapUpdate?(fallbackCenter)
    //                return
    //            }
    //            if let placemark = placemarks?.first, let location = placemark.location {
    //                let center = location.coordinate
    //                print("Geocoded coordinates for \(String(describing: userCity)): \(center)")
    //                self?.onMapUpdate?(center)
    //            } else {
    //                print("No coordinates found for \(String(describing: userCity))")
    //                let fallbackCenter = CLLocationCoordinate2D(latitude: 9.0820, longitude: 8.6753)
    //                self?.onMapUpdate?(fallbackCenter)
    //            }
    //        }
    //    }

    func fetchWeather() {
        let user = AuthService.shared.getCurrentUser()
        let userCity = user?.city
        print("User Details for weather: \(String(describing: user))")
        print("User city for weather: \(String(describing: userCity))")

        WeatherService.shared.fetchWeather(for: userCity ?? "") { [weak self] result in
            switch result {
            case .success(let weatherData):
                let description = weatherData.description ?? "N/A"
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
}
