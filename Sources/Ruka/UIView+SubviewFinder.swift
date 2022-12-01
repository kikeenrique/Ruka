#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif


extension UIView {
    func findViews<T: UIView>(subclassOf: T.Type) -> [T] {
        return recursiveSubviews.compactMap { $0 as? T }
    }

    private var recursiveSubviews: [UIView] {
        return subviews + subviews.flatMap { $0.recursiveSubviews }
    }
}
