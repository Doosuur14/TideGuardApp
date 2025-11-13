//
//  ReportModuleBuilder.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 09.06.2025.
//

import Foundation
import UIKit


class ReportModuleBuilder {
    func buildReportScreen() -> UIViewController {
        let viewModel = ReportViewModel()
        let viewController = ReportViewController(viewModel: viewModel)
        return viewController
    }
}
