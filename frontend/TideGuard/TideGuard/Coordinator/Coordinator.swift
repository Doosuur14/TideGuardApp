//
//  Coordinator.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 27.03.2025.
//

import Foundation
import UIKit

protocol Coordinator {

    var navigationController: UINavigationController { get set }

    func start()
}
