import Foundation
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

public extension UISlider {
    func set(value: Float) {
        guard isEnabled else { return }

        setValue(value, animated: false)
        sendActions(for: .valueChanged)
    }
}
