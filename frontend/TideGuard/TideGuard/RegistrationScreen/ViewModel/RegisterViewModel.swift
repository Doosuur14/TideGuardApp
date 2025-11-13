//
//  RegisterViewModel.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 14.04.2025.
//

import Foundation
import Combine

protocol RegistrationViewModelProtocol: RegViewModel where State == RegisterViewState, Intent == RegisterIntent {
}

protocol SignUpOutput: AnyObject {
    func goToLoginController()
    func signedUpUser()
}


final class RegistrationModel: RegistrationViewModelProtocol {

    weak var delegate: SignUpOutput?
    var stateDidChangeForReg =  ObservableObjectPublisher()

    @Published private(set) var state: RegisterViewState {
        didSet {
            stateDidChangeForReg.send()
        }
    }

    private(set) var stateDidChangeForLog = ObservableObjectPublisher()

    init () {
        self.state = .initial
    }

    func register(_ intent: RegisterIntent, firstName: String, lastName: String, email: String, password: String, city: String) {
        switch intent {
        case.didTapRegisterButton:
            AuthService.shared.register(firstName: firstName, lastName: lastName, email: email, password: password, city: city) { result in
                switch result {
                case .success:
                    self.state = .isregisteredSuccessfully
                    self.delegate?.signedUpUser()
                case .failure:
                    self.state = .registrationFailed
                }
            }
        }
    }

    func goToLoginController() {
        delegate?.goToLoginController()
    }

}

