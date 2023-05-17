//
//  WaitersConcurrency.swift
//  
//
//  Created by Enrique Garcia Alvarez on 18/5/23.
//

import Foundation
import XCTest

public protocol WaitersConcurrencyProtocol {
    func waitUntil(timeoutCondition: WaitTimeoutCondition,
                   file: StaticString,
                   line: UInt,
                   _ block: () -> Bool) async throws
    func waitFor(timeout: TimeInterval,
                 message: String,
                 file: StaticString,
                 line: UInt,
                 block: () -> WaitResult) async throws

    func waitOrSkip(timeoutCondition: WaitTimeoutCondition,
                    timeout: TimeInterval,
                    message: String,
                    file: StaticString,
                    line: UInt,
                    block: () -> WaitResult) async throws

    func waitFor(timeout: TimeInterval,
                 message: String,
                 file: StaticString,
                 line: UInt,
                 block: @MainActor() async -> WaitResult) async throws

    func waitOrSkip(timeoutCondition: WaitTimeoutCondition,
                    timeout: TimeInterval,
                    message: String,
                    file: StaticString,
                    line: UInt,
                    block: @MainActor() async -> WaitResult) async throws
}

extension WaitersConcurrencyProtocol {

    public func waitUntil(timeoutCondition: WaitTimeoutCondition = .fail,
                          file: StaticString = #file,
                          line: UInt = #line,
                          _ block: () -> Bool) async throws{
        try await waitOrSkip(timeoutCondition: timeoutCondition,
                             file: file,
                             line: line,
                             block: { block() ? .success : .wait })
    }

    public func waitFor(timeout: TimeInterval = 10,
                        message: String = "Timeout waiting for condition",
                        file: StaticString = #file,
                        line: UInt = #line,
                        block: () -> WaitResult) async throws {
        try await waitOrSkip(timeoutCondition: .fail,
                             timeout: timeout,
                             message: message,
                             file: file,
                             line: line,
                             block: block)
    }

    public func waitOrSkip(timeoutCondition: WaitTimeoutCondition,
                           timeout: TimeInterval = 10,
                           message: String = "Timeout waiting for condition",
                           file: StaticString = #file,
                           line: UInt = #line,
                           block: () -> WaitResult) async throws {
        let timeoutMs = UInt(timeout * 1000)
        let startedAt = getAbsoluteTimeMs()
        var result: WaitResult = .wait

        while (getAbsoluteTimeMs() - startedAt) < timeoutMs {
            result = block()

            if result == .success {
                break
            }

            try await Task.sleep(nanoseconds: 100_000_000)

            result = block()

            if result == .success {
                break
            }
        }

        if timeoutCondition == .fail, result == .wait {
            XCTFail("\(message)", file: file, line: line)
        }
    }

    public func waitFor(timeout: TimeInterval = 10,
                        message: String = "Timeout waiting for condition",
                        file: StaticString = #file,
                        line: UInt = #line,
                        block: @MainActor() async -> WaitResult) async throws {
        try await waitOrSkip(timeoutCondition: .fail,
                             timeout: timeout,
                             message: message,
                             file: file,
                             line: line,
                             block: block)
    }

    public func waitOrSkip(timeoutCondition: WaitTimeoutCondition,
                           timeout: TimeInterval = 10,
                           message: String = "Timeout waiting for condition",
                           file: StaticString = #file,
                           line: UInt = #line,
                           block: @MainActor() async -> WaitResult) async throws {
        let timeoutMs = UInt(timeout * 1000)
        let startedAt = getAbsoluteTimeMs()
        var result: WaitResult = .wait

        while (getAbsoluteTimeMs() - startedAt) < timeoutMs {
            result = await block()

            if result == .success {
                break
            }

            try await Task.sleep(nanoseconds: 100_000_000)

            result = await block()

            if result == .success {
                break
            }
        }

        if timeoutCondition == .fail, result == .wait {
            XCTFail("\(message)", file: file, line: line)
        }
    }
}
