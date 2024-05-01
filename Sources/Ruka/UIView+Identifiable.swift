//
//  UIView+ext.swift
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
import os.log

extension UIView {
    func isIdentifiable(by identifier: String, 
                        in controller: UIViewController) -> Bool {
        let identifiable =
            (self as? Identifiable)?.isIdentifiable(by: identifier) ?? false ||
            accessibilityLabel == identifier ||
            accessibilityIdentifier == identifier
        let found = identifiable && !isHidden && frame.intersects(controller.view.bounds)
        if found {
            let logger = Logger(subsystem: "App", category: "App")
            if isHidden {
                logger.debug("\(#function) identifier:\"\(identifier)\", isHidden🫣")
            } else {
                logger.debug("\(#function) identifier:\"\(identifier)\" 👀")
            }
        }
        return found
    }
}
