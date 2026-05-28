//
//  LocationService.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 19.05.2026.
//

import Foundation
import CoreLocation
import MapKit

final class LocationService: NSObject {

    static let shared = LocationService()

    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D?
    private var currentLga: LgaModel?


    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?
    var onLgaDetected: ((LgaModel) -> Void)?
    var onLocationError: ((String) -> Void)?

//    private var allLgas: [LgaModel] = []
    var allLgas: [LgaModel] = []

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100


        loadAllLgas()
    }



    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startTracking() {
        print("LocationService: Starting location tracking...")
        locationManager.startUpdatingLocation()
    }

    func stopTracking() {
        print("LocationService: Stopping location tracking...")
        locationManager.stopUpdatingLocation()
    }

    func getCurrentLocation() -> CLLocationCoordinate2D? {
        return currentLocation
    }

    func getCurrentLga() -> LgaModel? {
        return currentLga
    }


    func retriggerLgaDetection(for coordinate: CLLocationCoordinate2D) {
        if allLgas.isEmpty {
            loadAllLgas {
                self.findNearestLga(to: coordinate)
            }
        } else {
            findNearestLga(to: coordinate)
        }
    }


    private func loadAllLgas(completion: (() -> Void)? = nil) {
        LgaAPIService.shared.getAllLgas { [weak self] lgas in
            guard let lgas = lgas else {
                print("LocationService: Failed to load LGAs")
                completion?()
                return
            }
            self?.allLgas = lgas
            print("LocationService: Loaded \(lgas.count) LGAs for proximity detection")
            completion?()
        }
    }


//    private func loadAllLgas() {
//        LgaAPIService.shared.getAllLgas { [weak self] lgas in
//            guard let lgas = lgas else {
//                print("LocationService: Failed to load LGAs")
//                return
//            }
//            self?.allLgas = lgas
//            print("LocationService: Loaded \(lgas.count) LGAs for proximity detection")
//        }
//    }

    private func findNearestLga(to coordinate: CLLocationCoordinate2D) {
        guard !allLgas.isEmpty else {
            print("LocationService: No LGAs loaded yet")
            return
        }

        let userLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)


        var nearestLga: LgaModel?
        var shortestDistance: Double = Double.greatestFiniteMagnitude

        for lga in allLgas {
            let lgaLocation = CLLocation(latitude: lga.latitude, longitude: lga.longitude)
            let distance = userLocation.distance(from: lgaLocation)

            if distance < shortestDistance {
                shortestDistance = distance
                nearestLga = lga
            }
        }

        if let nearestLga = nearestLga {
            currentLga = nearestLga
            print("LocationService: Nearest LGA detected: \(nearestLga.lgaName) (\(Int(shortestDistance/1000))km away)")

            DispatchQueue.main.async {
                self.onLgaDetected?(nearestLga)
            }
        }
    }
}


extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let coordinate = location.coordinate
        currentLocation = coordinate

        print("LocationService: Location updated - Lat: \(coordinate.latitude), Lon: \(coordinate.longitude)")

       
        DispatchQueue.main.async {
            self.onLocationUpdate?(coordinate)
        }


        findNearestLga(to: coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationService: Location error - \(error.localizedDescription)")

        DispatchQueue.main.async {
            self.onLocationError?(error.localizedDescription)
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        print("LocationService: Authorization status changed to \(status.rawValue)")

        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            startTracking()
        case .denied, .restricted:
            onLocationError?("Location access denied. Please enable in Settings.")
        case .notDetermined:
            requestLocationPermission()
        @unknown default:
            break
        }
    }

}
