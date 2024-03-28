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
    public init(window: UIWindow = UIWindow(),
                controller: UIViewController,
                failureBehavior: FailureBehavior = .failTest) {
        self.window = window
        self.failureBehavior = failureBehavior

        load(controller: controller)
    }

    public init(window: UIWindow = UIWindow(),
                storyboard: String,
                bundle: Bundle?,
                identifier: String,
                failureBehavior: FailureBehavior = .failTest) {
        self.window = window
        self.failureBehavior = failureBehavior

        let storyboard = UIStoryboard(name: storyboard, bundle: bundle)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        load(controller: controller)
    }

    // MARK: UILabel

    public func label(_ identifier: String,
                      file: StaticString = #filePath,
                      line: UInt = #line) throws -> UILabel? {
        return try controller.getViewBy(identifier)
    }

    // MARK: UIButton

    public func button(_ identifier: String,
                       file: StaticString = #filePath,
                       line: UInt = #line) throws -> UIButton? {
        return try controller.getViewBy(identifier)
    }

    public func tapButton(title: String,
                          file: StaticString = #filePath,
                          line: UInt = #line) throws {
        guard let button = try button(title), button.isEnabled else { return }

        let windowBeforeTap = window
        button.sendActions(for: .touchUpInside)

        // Controller containing button is being popped off of navigation stack, wait for animation.
        let timeInterval: Animation.Length = windowBeforeTap != button.window ? .popController : .short
        RunLoop.main.run(until: Date().addingTimeInterval(timeInterval.rawValue))
    }

    // MARK: UITableView

    public var tableView: UITableView? {
        controller.view.findViews(subclassOf: UITableView.self).first
    }

    // MARK: UISwitch

    public func `switch`(_ identifier: String,
                         file: StaticString = #filePath,
                         line: UInt = #line) throws -> UISwitch? {
        return try controller.getViewBy(identifier)
    }

    // MARK: UIStepper

    public func stepper(_ identifier: String,
                        file: StaticString = #filePath,
                        line: UInt = #line) throws -> UIStepper? {
        return try controller.getViewBy(identifier)
    }

    // MARK: UISlider

    public func slider(_ identifier: String,
                       file: StaticString = #filePath,
                       line: UInt = #line) throws -> UISlider? {
        return try controller.getViewBy(identifier)
    }

    // MARK: UITextField

    public func textField(_ identifier: String,
                          file: StaticString = #filePath,
                          line: UInt = #line) throws -> UITextField? {
        return try controller.getViewBy(identifier)
    }

    // MARK: UIAlertController

    public var alertViewController: UIAlertController? {
        controller as? UIAlertController
    }

    // MARK: Private

    private let failureBehavior: FailureBehavior
    private let window: UIWindow!
    private var controller: UIViewController! { window.rootViewController?.visibleViewController() }

    private func load(controller: UIViewController) {
        window.rootViewController = controller
        window.makeKeyAndVisible()
        controller.loadViewIfNeeded()
        controller.view.layoutIfNeeded()
    }
    
    private func viewIsVisibleInController(_ view: UIView) -> Bool {
        view.frame.intersects(controller.view.bounds)
    }

}
