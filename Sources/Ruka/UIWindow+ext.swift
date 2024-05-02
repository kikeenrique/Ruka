//
//  UIWindow+ext.swift
//  Ruka
//
//  Created by Enrique Garcia Alvarez on 29/3/24.
//

import Foundation
import UIKit

extension UIWindow {
    // MARK: UILabel

    public func label(_ identifier: String,
                      file: StaticString = #filePath,
                      line: UInt = #line,
                      failureBehavior: FailureBehavior = .failTest) throws -> UILabel? {
        return try rootViewController?.visibleViewController?.getViewBy(identifier,
                                                                        tappable: false,
                                                                        failureBehavior: failureBehavior)
    }

    // MARK: UIButton

    public func button(_ identifier: String,
                       tappable: Bool = true,
                       file: StaticString = #filePath,
                       line: UInt = #line,
                       failureBehavior: FailureBehavior = .failTest) throws -> UIButton? {
        return try rootViewController?.visibleViewController?.getViewBy(identifier,
                                                                        tappable: tappable,
                                                                        failureBehavior: failureBehavior)
    }

    public func tapButton(title: String,
                          tappable: Bool = true,
                          file: StaticString = #filePath,
                          line: UInt = #line) throws {
        guard let button = try button(title, tappable: tappable),
              button.isEnabled else {
            return
        }

        button.sendActions(for: .touchUpInside)
    }

    // MARK: UISwitch
    @available(tvOS, unavailable)
    public func `switch`(_ identifier: String,
                         tappable: Bool = true,
                         file: StaticString = #filePath,
                         line: UInt = #line,
                         failureBehavior: FailureBehavior = .failTest) throws -> UISwitch? {
        return try rootViewController?.visibleViewController?.getViewBy(identifier,
                                                                        tappable: tappable,
                                                                        failureBehavior: failureBehavior)
    }

    // MARK: UIStepper

    @available(tvOS, unavailable)
    public func stepper(_ identifier: String,
                        tappable: Bool = true,
                        file: StaticString = #filePath,
                        line: UInt = #line,
                        failureBehavior: FailureBehavior = .failTest) throws -> UIStepper? {
        return try rootViewController?.visibleViewController?.getViewBy(identifier,
                                                                        tappable: tappable,
                                                                        failureBehavior: failureBehavior)
    }

    // MARK: UISlider

    @available(tvOS, unavailable)
    public func slider(_ identifier: String,
                       tappable: Bool = true,
                       file: StaticString = #filePath,
                       line: UInt = #line,
                       failureBehavior: FailureBehavior = .failTest) throws -> UISlider? {
        return try rootViewController?.visibleViewController?.getViewBy(identifier,
                                                                        tappable: tappable,
                                                                        failureBehavior: failureBehavior)
    }

    // MARK: UITextField

    public func textField(_ identifier: String,
                          tappable: Bool = true,
                          file: StaticString = #filePath,
                          line: UInt = #line,
                          failureBehavior: FailureBehavior = .failTest) throws -> UITextField? {
        return try rootViewController?.visibleViewController?.getViewBy(identifier,
                                                                        tappable: tappable,
                                                                        failureBehavior: failureBehavior)
    }
}
