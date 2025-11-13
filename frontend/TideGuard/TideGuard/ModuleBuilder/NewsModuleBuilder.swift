//
//  NewsModuleBuilder.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 11.06.2025.
//

import Foundation
import UIKit

class NewsModuleBuilder {
    func buildNewsScreen() -> UIViewController {
        let viewModel = NewsViewModel()
        let viewController = NewsViewController(viewModel: viewModel)
        return viewController
    }
}
