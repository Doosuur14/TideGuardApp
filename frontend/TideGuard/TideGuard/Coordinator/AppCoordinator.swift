//
//  AppCoordinator.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 27.03.2025.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {

    var navigationController: UINavigationController
    var coordinator: Coordinator?
    var isLogged = false

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        if isLogged {
            showMainFlow()
        } else {
            showAuthFlow()
        }
    }

    func didLogout() {
        showAuthFlow()
    }

}

private extension AppCoordinator {
    func showMainFlow() {
        coordinator = MainFlowCoordinator(
            navigationController: navigationController, mainFlowCoordinatorOutput: self)
        coordinator?.start()
    }

    func showAuthFlow() {
        coordinator = AuthFlowCoordinator(
            navigationController: navigationController, authFlowCoordinatorProtocol: self)
        coordinator?.start()
    }
}


extension AppCoordinator: AuthFlowCoordinatorProtocol, MainFlowCoordinatorProtocol {
    func mainFlowSignOutUser() {
        showAuthFlow()
    }

    func authFlowCoordinatorEnteredUser() {
        showMainFlow()
    }
}

