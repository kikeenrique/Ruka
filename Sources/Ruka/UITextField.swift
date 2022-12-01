#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif


public extension UITextField {
    func type(text: String) {
        guard isEnabled else { return }

        self.text = text
        _ = delegate?.textField?(self, shouldChangeCharactersIn: NSMakeRange(0, text.count), replacementString: text)
    }
}
