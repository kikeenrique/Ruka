//
//  UILabel+ext.swift
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

extension UILabel: Identifiable {
    func isIdentifiable(by identifier: String) -> Bool {
        text == identifier
    }
}
