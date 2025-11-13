//
//  LoginViewModelProtocol.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 13.04.2025.
//

import Foundation
import Combine

protocol LoginViewModel: ObservableObject where ObjectWillChangePublisher.Output == Void {
    associatedtype State
    associatedtype Intent

    var state: State { get }

    func trigger(_ intent: Intent, email: String, password: String)
}

protocol UIKitViewModel: LoginViewModel {
    var stateDidChangeForLog: ObservableObjectPublisher { get }
}
