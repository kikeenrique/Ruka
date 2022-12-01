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
