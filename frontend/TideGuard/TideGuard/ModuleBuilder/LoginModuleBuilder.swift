//
//  LoginModuleBuilder.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 13.04.2025.
//

import Foundation
import UIKit

class LoginModuleBuilder {
    func buildLogin(output: LoginOutput) -> UIViewController {
        let viewModel = LoginScreenViewModel()
        viewModel.delegate = output
        let viewController = LoginViewController(viewModel: viewModel)
        return viewController
    }
}
