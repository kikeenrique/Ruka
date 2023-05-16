//
//  XCUIElement+ext.swift
//  
//
//  Created by Enrique Garcia Alvarez on 25/12/22.
//

import Foundation
import XCTest

extension XCUIElement: WaitersProtocol {
}

public extension XCUIElement {
    func waitUntilExists(timeout: TimeInterval = 10,
                         file: StaticString = #file,
                         line: UInt = #line) {
        waitFor(timeout: timeout, file: file, line: line) { exists }
    }

    func waitUntilDoesntExist(file: StaticString = #file,
                              line: UInt = #line) {
        waitFor(file: file, line: line) { !exists }
    }

    func waitUntilEnabled(file: StaticString = #file,
                          line: UInt = #line) {
        waitUntilExists(file: file, line: line)
        waitFor(file: file, line: line) { isEnabled }
    }

    func waitUntilDisabled(file: StaticString = #file,
                           line: UInt = #line) {
        waitUntilExists(file: file, line: line)
        waitFor(file: file, line: line) { !isEnabled }
    }

    func waitAndTap(file: StaticString = #file,
                    line: UInt = #line) {
        waitUntilExists(file: file, line: line)
        waitFor(file: file, line: line) { isEnabled && isHittable }
        tap()
    }

    func waitForFocus(file: StaticString = #file,
                      line: UInt = #line) {
        waitFor(file: file, line: line) { !accessibilityElementIsFocused() }
    }

    func waitForFocusAndType(_ text: String,
                             file: StaticString = #file,
                             line: UInt = #line) {
        waitForFocus(file: file, line: line)
        waitFor(file: file, line: line) { !accessibilityElementIsFocused()}
        waitFor(file: file, line: line) { !XCUIApplication().keyboards.isEmpty }
        typeText(text)
    }

    func tapAndType(_ text: String,
                    file: StaticString = #file,
                    line: UInt = #line) {
        if !isHittable {
            XCUIApplication().scrollDownTo(self)
            if !isHittable {
                XCUIApplication().scrollUpTo(self)
                if !isHittable {
                    XCTFail("\(self) is not hittable and it wasn't possible to drag it into view.", file: file, line: line)
                }
            }
        }

        tap()
        waitFor(file: file, line: line) { !accessibilityElementIsFocused() }
        waitFor(file: file, line: line) { !XCUIApplication().keyboards.isEmpty }
        typeText(text)
    }

    func waitAndPerformIfExists(timeout: TimeInterval = 10,
                                file: StaticString = #file,
                                line: UInt = #line,
                                block: @escaping () -> Void) {
        waitOrSkip(timeoutCondition: .skip,
                   timeout: timeout,
                   file: file,
                   line: line,
                   block: { exists ? .success : .wait },
                   successBlock: block)
    }
}

