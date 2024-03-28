//
//  UITableViewCell+ext.swift
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


public extension UITableViewCell {
    func tap() {
        guard
            let tableView = superview as? UITableView,
            let indexPath = tableView.indexPath(for: self)
        else { return }

        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
}
