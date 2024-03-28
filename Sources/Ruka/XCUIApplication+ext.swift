//
//  XCUIApplication+ext.swift
//  
//
//  Created by Enrique Garcia Alvarez on 25/12/22.
//

import Foundation
import XCTest

public extension XCUIApplication {
    func scrollDownTo(_ element: XCUIElement, maxScrolls: Int = 5) {
        guard !element.isHittable else { return }
        for _ in 0 ..< maxScrolls {
            scrollDown()
            if element.isHittable {
                break
            }
        }
    }
    
    func scrollUpTo(_ element: XCUIElement, maxScrolls: Int = 5) {
        guard !element.isHittable else { return }
        for _ in 0 ..< maxScrolls {
            scrollUp()
            if element.isHittable {
                break
            }
        }
    }
    
    func scrollDown() {
        // Drag from about half way down the screen to almost the top to make sure that the drag does not interact with the keyboard.
#if !os(tvOS)
        let fromCoordinate = windows.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.4))
        let toCoordinate = windows.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
        fromCoordinate.press(forDuration: 0, thenDragTo: toCoordinate)
#endif
    }
    
    func scrollUp() {
        // Drag from about half way down the screen to near the bottom
#if !os(tvOS)
        let fromCoordinate = windows.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.4))
        let toCoordinate = windows.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.9))
        fromCoordinate.press(forDuration: 0, thenDragTo: toCoordinate)
#endif
    }
    
    func pullToRefresh() {
        // Drag from the top quarter of the screen to the bottom quarter.
#if !os(tvOS)
        let fromCoordinate = windows.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.25))
        let toCoordinate = windows.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.75))
        fromCoordinate.press(forDuration: 0, thenDragTo: toCoordinate)
#endif
    }
    
    func navigateBack() {
        // The back button tends to be the first button of the navigation bar
#if !os(tvOS)
        navigationBars.buttons.element(boundBy: 0).waitAndTap()
#endif
    }
    
    func tapKeyboardDoneButton() {
#if !os(tvOS)
        buttons["Done"].firstMatch.waitAndTap()
        keyboards.element.waitUntilDoesntExist()
#endif
    }
    
    func tapPickerDoneButton() {
#if !os(tvOS)
        buttons["Done"].firstMatch.waitAndTap()
        pickers.element.waitUntilDoesntExist()
#endif
    }
}

