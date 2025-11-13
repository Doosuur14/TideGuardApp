//
//  ProfileModuleBuilder.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 08.05.2025.
//

import Foundation
import UIKit

class ProfileModuleBuilder {
    func buildProfile() -> UIViewController {
        let viewModel = ProfileViewModel()
        let viewController = ProfileViewController(viewModel: viewModel)
        return viewController
    }
}
