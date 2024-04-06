//
//  UIAlertController+ext.swift
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

public extension UIAlertController {
    private typealias AlertHandler = @convention(block) (UIAlertAction) -> Void

    func tapButton(title: String) {
        let action = actions.first(where: { $0.title == title })
        if let action = action, let block = action.value(forKey: "handler") {
            let handler = unsafeBitCast(block as AnyObject, to: AlertHandler.self)
            handler(action)

            dismiss(animated: false)
        }
    }
}
