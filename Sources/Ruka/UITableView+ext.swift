//
//  UITableView+ext.swift
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

public extension UITableView {
    func cell(containingText text: String,
              file: StaticString = #filePath,
              line: UInt = #line) throws -> UITableViewCell? {
        let tableViewCell = self.visibleCells.first(where: { cell -> Bool in
            cell.findViews(subclassOf: UILabel.self).contains { $0.text == text }
        })

        if tableViewCell == nil, failureBehavior != FailureBehavior.doNothing {
            try failOrRaise("Could not find cell containing text '\(text)'.", file: file, line: line)
        }
        return tableViewCell
    }
}
