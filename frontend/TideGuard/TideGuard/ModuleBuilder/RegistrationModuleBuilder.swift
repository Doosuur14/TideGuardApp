//
//  RegistrationModuleBuilder.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 13.04.2025.
//

import Foundation
import UIKit

class RegistrationModuleBuilder {
    func buildRegister(output: SignUpOutput) -> UIViewController {
        let viewModel = RegistrationModel()
        viewModel.delegate = output
        let viewController = RegistrationScreenViewController(viewModel: viewModel)
        return viewController
    }
}
