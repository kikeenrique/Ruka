import Foundation
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

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
