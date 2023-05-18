//
//  UISwitch+ext.swift
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

public extension UISwitch {
    func toggle() {
        guard isEnabled else { return }
        
        sendActions(for: .valueChanged)
    }
}
