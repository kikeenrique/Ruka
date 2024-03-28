//
//  UITextField+ext.swift
//
//
//  Created by Enrique Garcia Alvarez on 18/5/23.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

extension UITextField: Identifiable {
    func isIdentifiable(by identifier: String) -> Bool {
        placeholder == identifier
    }
}

public extension UITextField {
    func type(text: String) {
        guard isEnabled else { return }

        self.text = text
        _ = delegate?.textField?(self, shouldChangeCharactersIn: NSMakeRange(0, text.count), replacementString: text)
    }
}
