//
//  UICustomTextField.swift
//  TideGuard
//
//  Created by Faki Doosuur Doris on 06.04.2025.
//

import Foundation
import UIKit

extension UITextField {
    @discardableResult
    func isEmptyTextField() -> Bool {
        if self.text?.isEmpty ?? true {
            self.layer.borderColor = UIColor(named: "subtitlecolor")?.cgColor
        }
        return self.text?.isEmpty ?? true
    }
}
