//
//  AlertManager.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 14.04.2025.
//

import Foundation
import UIKit

class AlertManager {
    static let shared = AlertManager()
    private init() {}

    private func showAlert(viewController: UIViewController, title: String, message: String?) {
       let alert =  UIAlertController(title: title, message: message, preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
       viewController.present(alert, animated: true)
   }

}

extension AlertManager {

    // MARK: Invalid email and password alert
    func showInvalidAlert(viewCon: UIViewController) {
        self.showAlert(viewController: viewCon, title: "INVALID EMAIL AND PASSWORD",
                       message: "Please enter a valid email and password")
    }
    // MARK: Registration failed
    func showRegistrationFailedAlert(viewCon: UIViewController) {
        self.showAlert(viewController: viewCon, title: "REGISTRATION WAS NOT SUCCESSFUL",
                       message: "Please review the details for the form")
    }
    // MARK: Registration successful
    func showRegistrationSuccessful(viewCon: UIViewController) {
        self.showAlert(viewController: viewCon, title: "REGISTRATION WAS SUCCESSFUL!",
                       message: "Welcome.")
    }
    // MARK: Login failed
    func showLoginErrorAlert(viewCon: UIViewController) {
        self.showAlert(viewController: viewCon, title: "LOGIN FAILED",
                       message: "Please review the login details and try again")
    }

    func showLoginAlert(viewCon: UIViewController) {
        self.showAlert(viewController: viewCon, title: "Login successful",
                       message: "Successful")
    }

    // MARK: Empty field
    func showEmptyFieldAlert(viewCon: UIViewController) {
        self.showAlert(viewController: viewCon, title: "Error",
                       message: "You are trying to send an empty field, Please enter text.")
    }
    // MARK: Wrong email format
    func showWrongEmailAlert(viewCon: UIViewController) {
        self.showAlert(viewController: viewCon, title: "Error",
                       message: "Email format is wrong, Please enter a valid email!")
    }
    // MARK: Profile was sucessfully updated
    func showUpdateAlert(viewCon: UIViewController) {
        self.showAlert(viewController: viewCon, title: "Success",
                       message: "Profile updated successfully!")
    }
    // MARK: Update failed
    func showUpdateFailureAlert(viewCon: UIViewController) {
        self.showAlert(viewController: viewCon, title: "FAILED",
                       message: "Update failed!")
    }

    func showSuccessfulReportAlert(viewCon: UIViewController) {
        self.showAlert(viewController: viewCon, title: "Success",
                       message: "Upload failed!")
    }

}

