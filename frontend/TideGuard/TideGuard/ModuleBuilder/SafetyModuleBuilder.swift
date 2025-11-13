//
//  SafetyModuleBuilder.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 17.04.2025.
//

import Foundation
import UIKit

class SafetyModuleBuilder {
    func buildMain() -> UIViewController {
        let viewModel = SafetyViewModel()
        let viewController = SafetyViewController(viewModel: viewModel)
        return viewController
    }
}
