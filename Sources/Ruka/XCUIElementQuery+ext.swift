//
//  XCUIElementQuery+ext.swift
//  
//
//  Created by Enrique Garcia Alvarez on 26/12/22.
//

import Foundation
import XCTest

public extension XCUIElementQuery {
    var isEmpty: Bool {
        return self.count == 0
    }
}

