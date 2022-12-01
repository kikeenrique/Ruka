import Foundation
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

import XCTest

// SPM HACK https://forums.swift.org/t/dynamically-call-xctfail-in-spm-module-without-importing-xctest/36375
typealias XCTCurrentTestCase = @convention(c) () -> AnyObject
typealias XCTFailureHandler
  = @convention(c) (AnyObject, Bool, UnsafePointer<CChar>, UInt, String, String?) -> Void

func _XCTFail(_ message: String = "", file: StaticString = #file, line: UInt = #line) {
  guard
    let _XCTest = NSClassFromString("XCTest")
      .flatMap(Bundle.init(for:))
      .flatMap({ $0.executablePath })
      .flatMap({ dlopen($0, RTLD_NOW) })
    else { return }

  guard
    let _XCTFailureHandler = dlsym(_XCTest, "_XCTFailureHandler")
      .map({ unsafeBitCast($0, to: XCTFailureHandler.self) })
    else { return }

  guard
    let _XCTCurrentTestCase = dlsym(_XCTest, "_XCTCurrentTestCase")
      .map({ unsafeBitCast($0, to: XCTCurrentTestCase.self) })
    else { return }

  _XCTFailureHandler(_XCTCurrentTestCase(), true, "\(file)", line, message, nil)
}

public struct App {
    public enum FailureBehavior {
        case failTest
        case raiseException
        case doNothing
    }

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

    // MARK: UIView generic

    public func getViewBy<T: UIView>(_ identifier: String,
                                     file: StaticString = #filePath,
                                     line: UInt = #line) throws -> T? {
        let views = controller.view.findViews(subclassOf: T.self)
        let view = views.first(where: { $0.isIdentifiable(by: identifier, in: controller) })

        if view == nil, failureBehavior != .doNothing {
            try failOrRaise("Could not find view with '\(identifier)'.", file: file, line: line)
        }
        return view
    }

    // MARK: UILabel

    public func label(_ identifier: String,
                      file: StaticString = #filePath,
                      line: UInt = #line) throws -> UILabel? {
        return try getViewBy(identifier)
    }

    // MARK: UIButton

    public func button(_ identifier: String,
                       file: StaticString = #filePath,
                       line: UInt = #line) throws -> UIButton? {
        return try getViewBy(identifier)
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

    public func cell(containingText text: String,
                     file: StaticString = #filePath,
                     line: UInt = #line) throws -> UITableViewCell? {
        let tableViewCell = tableView?.visibleCells.first(where: { cell -> Bool in
            cell.findViews(subclassOf: UILabel.self).contains { $0.text == text }
        })

        if tableViewCell == nil, failureBehavior != .doNothing {
            try failOrRaise("Could not find cell containing text '\(text)'.", file: file, line: line)
        }
        return tableViewCell
    }

    // MARK: UISwitch

    public func `switch`(_ identifier: String,
                         file: StaticString = #filePath,
                         line: UInt = #line) throws -> UISwitch? {
        return try getViewBy(identifier)
    }

    // MARK: UIStepper

    public func stepper(_ identifier: String,
                        file: StaticString = #filePath,
                        line: UInt = #line) throws -> UIStepper? {
        return try getViewBy(identifier)
    }

    // MARK: UISlider

    public func slider(_ identifier: String,
                       file: StaticString = #filePath,
                       line: UInt = #line) throws -> UISlider? {
        return try getViewBy(identifier)
    }

    // MARK: UITextField

    public func textField(_ identifier: String,
                          file: StaticString = #filePath,
                          line: UInt = #line) throws -> UITextField? {
        return try getViewBy(identifier)
    }

    // MARK: UIAlertController

    public var alertViewController: UIAlertController? {
        controller as? UIAlertController
    }

    // MARK: Private

    private enum RukaError: Error {
        case unfoundElement
    }

    private let failureBehavior: FailureBehavior
    private let window: UIWindow!
    private var controller: UIViewController! { visibleViewController(from: window.rootViewController) }

    private func load(controller: UIViewController) {
        window.rootViewController = controller
        window.makeKeyAndVisible()
        controller.loadViewIfNeeded()
        controller.view.layoutIfNeeded()
    }

    private func visibleViewController(from viewController: UIViewController?) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController {
            return visibleViewController(from: navigationController.topViewController)
        }

        if let tabBarController = viewController as? UITabBarController {
            return visibleViewController(from: tabBarController.selectedViewController)
        }

        if let presentedViewController = viewController?.presentedViewController {
            return visibleViewController(from: presentedViewController)
        }

        return viewController
    }

    private func viewIsVisibleInController(_ view: UIView) -> Bool {
        view.frame.intersects(controller.view.bounds)
    }

    private func failOrRaise(_ message: String, file: StaticString, line: UInt) throws {
        switch failureBehavior {
        case .failTest:
            _XCTFail(message, file: file, line: line)
        case .raiseException:
            throw RukaError.unfoundElement
        case .doNothing:
            break
        }
    }
}
