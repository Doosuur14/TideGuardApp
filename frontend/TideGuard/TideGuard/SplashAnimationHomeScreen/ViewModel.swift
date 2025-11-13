//
//  ViewModel.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 17.04.2025.
//

import Foundation
import UIKit


protocol StartOutput: AnyObject {
    func goToLogin()
    func goToReg()
}

class ViewModel {
    weak var delegate: StartOutput?

    func goToLogin() {
        delegate?.goToLogin()
    }

    func goToRegister() {
        delegate?.goToReg()
    }
}
