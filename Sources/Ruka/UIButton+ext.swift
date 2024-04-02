//
//  UIButton+ext.swift
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

extension UIButton: Identifiable {
    func isIdentifiable(by identifier: String) -> Bool {
        let title = title(for: .normal)
        return title == identifier
    }
}
