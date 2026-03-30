//
//  ReportViewModel.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 09.06.2025.
//

import Foundation
import UserNotifications
import UIKit
import CoreData
import CoreLocation


class ReportViewModel: NSObject {

    var onUploadCompleted: (() -> Void)?
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }


    func uploadReport(image: UIImage?, description: String, severity: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let email = UserDefaults.standard.string(forKey: "userEmail") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User email not found"])))
            return
        }

        // Use current location or fallback to Lagos if unavailable (for testing)
        let latitude = currentLocation?.coordinate.latitude ?? 6.5244
        let longitude = currentLocation?.coordinate.longitude ?? 3.3792

        ReportService.shared.uploadReport(
            image: image,
            description: description,
            email: email,
            latitude: latitude,
            longitude: longitude,
            severity: severity
        ) { [weak self] result in
            switch result {
            case .success(let photoUrl):
                self?.scheduleNotification()
                self?.onUploadCompleted?()
                completion(.success(photoUrl))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


    private func scheduleNotification() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                let content = UNMutableNotificationContent()
                content.title = "Report Submitted"
                content.body = "Your flood report has been successfully uploaded, and will be looked into as soon as possible"
                content.sound = .default

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false) // Increased to 2 seconds
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error)")
                    } else {
                        print("Notification scheduled successfully")
                    }
                }
            } else {
                print("Notification not scheduled due to lack of permission")
            }
        }
    }
}


extension ReportViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}
