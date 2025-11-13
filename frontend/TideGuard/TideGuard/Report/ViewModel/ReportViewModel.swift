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


class ReportViewModel {

    var onUploadCompleted: (() -> Void)?


    func uploadReport(image: UIImage?, description: String, completion: @escaping (Result<String, Error>) -> Void) {

        guard let email = UserDefaults.standard.string(forKey: "userEmail") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User email not found"])))
            return
        }

        ReportService.shared.uploadReport(image: image, description: description, email: email) { [weak self] result in
            switch result {
            case .success(let photoUrl):
                print("Report uploaded successfully: \(photoUrl)")
                self?.scheduleNotification()
                self?.onUploadCompleted?()
                completion(.success(photoUrl))
            case .failure(let error):
                print("Report upload failed: \(error)")
                completion(.failure(error))
            }
        }
    }


//    private func scheduleNotification() {
//        let content = UNMutableNotificationContent()
//        content.title = "Report Submitted"
//        content.body = "Your flood report has been successfully uploaded, and will be looked into as soon as possible"
//        content.sound = .default
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) 
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Error scheduling notification: \(error)")
//            }
//        }
//    }

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
