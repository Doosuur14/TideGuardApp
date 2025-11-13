//
//  LoginViewModel.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 31.03.2025.
//

import Foundation
import Combine

protocol LoginMainViewModelProtocol: UIKitViewModel where State == LoginViewState, Intent == LoginViewIntent {
    var delegate: LoginOutput? { get set }
}

protocol LoginOutput: AnyObject {
    func goToSignUpController()
    func signedInUser()
}

final class LoginScreenViewModel: LoginMainViewModelProtocol {

    weak var delegate: LoginOutput?

    @Published private(set) var state: LoginViewState {
        didSet {
            stateDidChangeForLog.send()
        }
    }

    private(set) var stateDidChangeForLog = ObservableObjectPublisher()

    init () {
        self.state = .loading
    }

    func resetState() {
        self.state = .loading
    }

    func trigger(_ intent: LoginViewIntent, email: String, password: String) {

        switch intent {
        case .didTapLoginButton:
            AuthService.shared.login(email: email, password: password) { [weak self] result in
                switch result {
                case .success:
                    UserDefaults.standard.set(email, forKey: "curUser")
                    self?.state = .isloggedSuccessfully
                    self?.delegate?.signedInUser()
                case .failure(_):
                    print("Login failed")
                    self?.state = .loginFailed
                }
            }
        }

    }

    func goToSignUpController() {
        delegate?.goToSignUpController()
    }

}
