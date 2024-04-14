//
//  Waiters.swift
//
//
//  Created by Enrique Garcia Alvarez on 26/12/22.
//

import Foundation
import XCTest

public protocol WaitersProtocol {
    func waitForAnimationsToFinish(window: UIWindow,
                                   timeout: TimeInterval,
                                   timeoutCondition: WaitTimeoutCondition,
                                   file: StaticString,
                                   line: UInt)

    func waitUntil(timeoutCondition: WaitTimeoutCondition,
                   file: StaticString,
                   line: UInt,
                   _ block: () -> Bool)

    func waitFor(timeout: TimeInterval,
                 message: String,
                 file: StaticString,
                 line: UInt,
                 block: () -> Bool)

    func waitOrSkip(timeoutCondition: WaitTimeoutCondition,
                    timeout: TimeInterval,
                    message: String,
                    file: StaticString,
                    line: UInt,
                    block: () -> WaitResult,
                    successBlock: (() -> Void)?)
}

extension WaitersProtocol {
    public func waitForAnimationsToFinish(window: UIWindow,
                                          timeout: TimeInterval = 10,
                                          timeoutCondition: WaitTimeoutCondition = .fail,
                                          file: StaticString = #file,
                                          line: UInt = #line) {
        waitOrSkip(timeoutCondition: timeoutCondition,
                   timeout: timeout,
                   file: file,
                   line: line,
                   block: {
            window.areAnimationsFinished() ? .success : .wait
        })
    }

    public func waitUntil(timeoutCondition: WaitTimeoutCondition = .fail,
                          file: StaticString = #file,
                          line: UInt = #line,
                          _ block: () -> Bool) {
        waitOrSkip(timeoutCondition: timeoutCondition,
                   file: file,
                   line: line,
                   block: { block() ? .success : .wait })
    }

    public func waitFor(timeout: TimeInterval = 10,
                        message: String = "Timeout waiting for condition",
                        file: StaticString = #file,
                        line: UInt = #line,
                        block: () -> Bool) {
        waitOrSkip(timeoutCondition: .fail,
                   timeout: timeout,
                   message: message,
                   file: file,
                   line: line,
                   block: { block() ? .success : .wait } )
    }

    public func waitOrSkip(timeoutCondition: WaitTimeoutCondition,
                           timeout: TimeInterval = 10,
                           message: String = "Timeout waiting for condition",
                           file: StaticString = #file,
                           line: UInt = #line,
                           block: () -> WaitResult,
                           successBlock: (() -> Void)? = nil) {
        let timeoutMs = UInt(timeout * 1000)
        let startedAt = getAbsoluteTimeMs()
        var result: WaitResult = .wait

        while (getAbsoluteTimeMs() - startedAt) < timeoutMs {
            CFRunLoopRunInMode(CFRunLoopMode.defaultMode, 0.05, false)
            result = block()

            if result == .success {
                successBlock?()
                break
            }
        }

        if timeoutCondition == .fail, result == .wait {
            XCTFail("\(message)", file: file, line: line)
        }
    }
}
