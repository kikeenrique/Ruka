//
//  App.swift
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

import XCTest

public struct App {
    public init(window: UIWindow?,
                controller: UIViewController) {
        self.window = window ?? UIWindow()
        self.controller = controller

        load(controller: controller)
    }

    public init(window: UIWindow?,
                storyboard: String,
                bundle: Bundle?,
                identifier: String) {
        self.window = window ?? UIWindow()

        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        self.controller = controller
        load(controller: controller)
    }

    // MARK: UITableView

    public var tableView: UITableView? {
        rootViewControllerVisible.view.findViews(subclassOf: UITableView.self).first
    }

    // MARK: UIAlertController

    public var alertViewController: UIAlertController? {
        rootViewControllerVisible as? UIAlertController
    }

    // MARK: Private

    private let window: UIWindow!
    public let controller: UIViewController!
    private var rootViewControllerVisible: UIViewController! {
        window.rootViewController?.visibleViewController
    }

    private func load(controller: UIViewController) {
        window.rootViewController = controller
        window.makeKeyAndVisible()
        controller.loadViewIfNeeded()
        controller.view.layoutIfNeeded()
    }
    
    private func viewIsVisibleInController(_ view: UIView) -> Bool {
        view.frame.intersects(rootViewControllerVisible.view.bounds)
    }
}
