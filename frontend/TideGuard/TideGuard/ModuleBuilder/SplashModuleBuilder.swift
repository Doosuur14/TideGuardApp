//
//  SplashModuleBuilder.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 17.04.2025.
//

import Foundation
import UIKit

class SplashModuleBuilder {
    func splashScreen(output: StartOutput) -> UIViewController {
        let viewModel = ViewModel()
        viewModel.delegate = output
        let viewController = SplashViewController(viewModel: viewModel)
        return viewController
    }
}
