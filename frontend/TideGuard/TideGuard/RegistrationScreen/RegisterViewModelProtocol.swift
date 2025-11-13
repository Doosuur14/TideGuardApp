//
//  RegisterViewModelProtocol.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 14.04.2025.
//

import Foundation
import Combine
import UIKit

protocol RegistrationProtocol: ObservableObject where ObjectWillChangePublisher.Output == Void {
    associatedtype State
    associatedtype Intent

    var state: State { get }

    func register(_ intent: Intent,
                  firstName: String,
                  lastName: String,
                  email: String,
                  password: String, city: String)

    func goToLoginController()
}


protocol RegViewModel: RegistrationProtocol {
    var stateDidChangeForReg: ObservableObjectPublisher { get }
}
