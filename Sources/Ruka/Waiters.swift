//
//  File.swift
//  
//
//  Created by Enrique Garcia Alvarez on 26/12/22.
//

import Foundation
import XCTest

// MARK: Waiters

public enum TestWaitResult {
    case wait, success
}

public enum WaitTimeoutCondition {
    case fail, skip
}


public protocol WaitersProtocol {
    func waitFor(interval: TimeInterval)

    func waitForAnimations()

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
                    block: () -> TestWaitResult,
                    successBlock: (() -> Void)?)

}

extension WaitersProtocol {
    public func waitFor(interval: TimeInterval) {
        CFRunLoopRunInMode(CFRunLoopMode.defaultMode, interval, false)
    }

    public func waitForAnimations() {
        waitFor(interval: 0.3)
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
                           block: () -> TestWaitResult,
                           successBlock: (() -> Void)? = nil) {
        let timeoutMs = UInt(timeout * 1000)
        let startedAt = getAbsoluteTimeMs()
        var result: TestWaitResult = .wait

        while (getAbsoluteTimeMs() - startedAt) < timeoutMs {
            result = block()

            if result == .success {
                successBlock?()
                break
            }

            CFRunLoopRunInMode(CFRunLoopMode.defaultMode, 0.1, false)

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

    private func getAbsoluteTimeMs() -> UInt {
        var info = mach_timebase_info(numer: 0, denom: 0)
        mach_timebase_info(&info)
        let numer = UInt64(info.numer)
        let denom = UInt64(info.denom)
        let nanoseconds = (mach_absolute_time() * numer) / denom
        return UInt(nanoseconds / NSEC_PER_MSEC)
    }

}
