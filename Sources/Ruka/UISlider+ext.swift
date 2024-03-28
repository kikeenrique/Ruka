//
//  UISlider+ext.swift
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

@available(tvOS, unavailable)
public extension UISlider {
    func set(value: Float) {
        guard isEnabled else { return }

        setValue(value, animated: false)
        sendActions(for: .valueChanged)
    }
}
