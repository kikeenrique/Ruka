//
//  UIViewController+ext.swift
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

public extension UIViewController {
    func getViewBy<T: UIView>(_ identifier: String,
                              file: StaticString = #filePath,
                              line: UInt = #line,
                              failureBehavior: FailureBehavior = .failTest) throws -> T? {
        let views = self.view.findViews(subclassOf: T.self)
        let view = views.first(where: { $0.isIdentifiable(by: identifier, in: self) })

        if view == nil, failureBehavior != FailureBehavior.doNothing {
            try failureBehavior.failOrRaise("Could not find view with '\(identifier)'.",
                                            file: file,
                                            line: line)
        }
        return view
    }

    func visibleViewController() -> UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.visibleViewController()
        }

        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.visibleViewController()
        }

        if let presentedViewController = self.presentedViewController {
            return presentedViewController.visibleViewController()
        }

        return self
    }
}
