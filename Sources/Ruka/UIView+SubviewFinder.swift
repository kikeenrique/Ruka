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
    func findViews<T: UIView>(subclassOf: T.Type) -> [T] {
        return recursiveSubviews.compactMap { $0 as? T }
    }

    private var recursiveSubviews: [UIView] {
        return subviews + subviews.flatMap { $0.recursiveSubviews }
    }

    func isTappable() -> Bool {
        let tappable = isTappable(in: self.bounds)
        return tappable
    }

    func isTappable(in viewBounds: CGRect) -> Bool {
        let tapPoint = tappablePoint(in: viewBounds)
        return tapPoint != nil ? true : false
    }

    func tappablePoint(in rect: CGRect) -> CGPoint? {
        guard let window = self.window else {
            return nil
        }
        // Convert the rect from the view's coordinate system to the window's coordinate system
        let frame = window.convert(rect, from: self)

        //  TL                               TR
        //    +-----------------------------+
        //    |                             |
        //    |                             |
        //    |              + C            |
        //    |                             |
        //    |                             |
        //    +-----------------------------+
        //  BL                               BR
        let pointsToTest = [
            CGPoint(x: frame.midX, y: frame.midY),             // C  Center
            CGPoint(x: frame.minX + 1.0, y: frame.minY + 1.0), // TL Top left
            CGPoint(x: frame.maxX - 1.0, y: frame.minY + 1.0), // TR Top right
            CGPoint(x: frame.minX + 1.0, y: frame.maxY - 1.0), // BL Bottom left
            CGPoint(x: frame.maxX - 1.0, y: frame.maxY - 1.0)  // BR Bottom right
        ]

        for tapPoint in pointsToTest {
            if let hitView = window.hitTest(tapPoint, with: nil){
                let logger = Logger(subsystem: "App", category: "tappablePoint")
                if hitView === self {
                    logger.debug("\(#function) hitView tapPoint(x:\(tapPoint.x), y:\(tapPoint.y)) 🙋")
                    return window.convert(tapPoint, to: self)
                } else {
                    if hitView.isDescendant(of: self) {
                        logger.debug("\(#function) hitView tapPoint(x:\(tapPoint.x), y:\(tapPoint.y)) 🧑‍🧒")
                        return window.convert(tapPoint, to: self)
                    } else {
                        if hitView === self.superview {
                            // this can happend is view is a uicontrol that is disabled
                            logger.debug("\(#function) hitView tapPoint(x:\(tapPoint.x), y:\(tapPoint.y)) 🧓")
                            return window.convert(tapPoint, to: self)
                        } else {
                            logger.debug("\(#function) hitView tapPoint(x:\(tapPoint.x), y:\(tapPoint.y)) 😅")
                        }
                    }
                }
            }
        }

        return nil
    }
}
