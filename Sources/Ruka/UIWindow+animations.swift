//
//  UIWindow+animations.swift
//  Ruka
//
//  Created by Enrique Garcia Alvarez on 2/5/24.
//

import Foundation
import UIKit
import os.log

extension UIWindow {
    func areAnimationsFinished() -> Bool {
        let views = getAllViews()
        let logger = Logger(subsystem: "App", category: "App")
        let animations: Bool
        if views.isEmpty {
            animations = false
        } else {
            animations = views.contains { view in
                if view.layer.hasFiniteAnimations(logged: true) {
                    return true
                } else {
                    return false
                }
            }
        }
        logger.debug("\(#function) views:\(views.count) animations:\(String(describing: animations))")
        return !animations
    }

    func getAllViews() -> [UIView] {
        var allViews = [UIView]()

        if let rootViewController = self.rootViewController {
            traverseSubviews(of: rootViewController.view,
                             accumulating: &allViews)
            // Include views from child view controllers
            getChildViewControllers(rootViewController).forEach { viewController in
                traverseSubviews(of: viewController.view,
                                 accumulating: &allViews)
            }
        }

        return allViews
    }

    private func traverseSubviews(of view: UIView,
                                  accumulating allViews: inout [UIView]) {
        allViews.append(view)
        view.subviews.forEach { subview in
            traverseSubviews(of: subview,
                             accumulating: &allViews)
        }
    }

    private func getChildViewControllers(_ viewController: UIViewController) -> [UIViewController] {
        var viewControllers = [UIViewController]()
        viewControllers.append(contentsOf: viewController.children)
        viewController.children.forEach { childViewController in
            viewControllers.append(contentsOf: getChildViewControllers(childViewController))
        }
        if let presentedViewController = viewController.presentedViewController {
            viewControllers.append(presentedViewController)
            viewControllers.append(contentsOf: getChildViewControllers(presentedViewController))
        }
        return viewControllers
    }
}
