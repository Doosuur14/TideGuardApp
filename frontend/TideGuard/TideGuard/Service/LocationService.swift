//
//  LocationService.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 25.11.2025.
//

import Foundation
import CoreLocation
import MapKit 

class LocationService {
    static let shared = LocationService()

    private let geocoder = CLGeocoder()

//    func getCoordinate(for state: String, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
//        let address = "\(state), Nigeria"
//
//        geocoder.geocodeAddressString(address) { placemarks, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let location = placemarks?.first?.location else {
//                completion(.failure(LocationError.noLocationFound))
//                return
//            }
//
//            completion(.success(location.coordinate))
//        }
//    }



    func getCoordinate(for state: String, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        let address = "\(state), Nigeria"
        print("🗺️ GEOCODING START: Looking up '\(address)'")

        geocoder.geocodeAddressString(address) { placemarks, error in
            print("🗺️ GEOCODING COMPLETE:")

            if let error = error {
                print("❌ GEOCODING ERROR: \(error.localizedDescription)")
                print("   Error code: \((error as NSError).code)")
                completion(.failure(error))
                return
            }

            print("📍 GEOCODING RESULTS:")
            print("   Number of placemarks: \(placemarks?.count ?? 0)")

            if let placemarks = placemarks {
                for (index, placemark) in placemarks.enumerated() {
                    print("   Placemark \(index+1):")
                    print("     - Location: \(placemark.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))")
                    print("     - Name: \(placemark.name ?? "nil")")
                    print("     - Locality: \(placemark.locality ?? "nil")")
                    print("     - AdministrativeArea: \(placemark.administrativeArea ?? "nil")")
                    print("     - Country: \(placemark.country ?? "nil")")
                }
            }

            guard let location = placemarks?.first?.location else {
                print("❌ GEOCODING: No location found in placemarks")
                completion(.failure(LocationError.noLocationFound))
                return
            }

            print("✅ GEOCODING SUCCESS: Found coordinate \(location.coordinate.latitude), \(location.coordinate.longitude)")
            completion(.success(location.coordinate))
        }
    }

    func getNigeriaRegion() -> MKCoordinateRegion {
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 9.0820, longitude: 8.6753),
            latitudinalMeters: 1500000,
            longitudinalMeters: 1500000
        )
    }
}

enum LocationError: Error {
    case noLocationFound
}
