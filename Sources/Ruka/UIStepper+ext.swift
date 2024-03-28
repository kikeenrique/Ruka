//
//  UIStepper+ext.swift
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
public extension UIStepper {
    func increment() {
        guard isEnabled else { return }

        value += stepValue
        sendActions(for: .valueChanged)
    }

    func decrement() {
        guard isEnabled else { return }

        value -= stepValue
        sendActions(for: .valueChanged)
    }
}
