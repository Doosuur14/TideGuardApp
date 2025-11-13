//
//  AuthFlowCoordinator.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 14.04.2025.
//

import Foundation
import UIKit

protocol AuthFlowCoordinatorProtocol: AnyObject {
    func authFlowCoordinatorEnteredUser()
}


final class AuthFlowCoordinator: Coordinator {
    var navigationController: UINavigationController
    private var authFlowCoordinatorProtocol: AuthFlowCoordinatorProtocol?

    init(navigationController: UINavigationController, authFlowCoordinatorProtocol: AuthFlowCoordinatorProtocol) {
        self.navigationController = navigationController
       self.authFlowCoordinatorProtocol = authFlowCoordinatorProtocol
    }

    func start() {
        let splashController = SplashModuleBuilder().splashScreen(output: self)
        navigationController.setViewControllers([splashController], animated: true)
    }

}

extension AuthFlowCoordinator: StartOutput, LoginOutput, SignUpOutput {
    func signedInUser() {
        authFlowCoordinatorProtocol?.authFlowCoordinatorEnteredUser()
    }

    func signedUpUser() {
        goToLoginController()
    }

    func goToSignUpController() {
        let signUpViewController = RegistrationModuleBuilder().buildRegister(output: self)
        //navigationController.pushViewController(signUpViewController, animated: true)
        navigationController.setViewControllers([signUpViewController], animated: true)
    }

    func goToLoginController() {
        let signInViewController = LoginModuleBuilder().buildLogin(output: self)
        navigationController.pushViewController(signInViewController, animated: true)
    }

    func goToReg() {
        goToSignUpController()
    }

    func goToLogin() {
        goToLoginController()
    }

}
