//
//  FailureBehavior.swift
//  
//
//  Created by Enrique Garcia Alvarez on 18/5/23.
//

import Foundation
import XCTest

public enum FailureBehavior {
    case failTest
    case raiseException
    case doNothing
}

public func failOrRaise(_ message: String,
                        file: StaticString,
                        line: UInt) throws {
    switch failureBehavior {
    case .failTest:
#if SWIFT_PACKAGE
        _XCTFail(message, file: file, line: line)
#else
        XCTFail(message, file: file, line: line)
#endif
    case .raiseException:
        throw RukaError.unfoundElement
    case .doNothing:
        break
    }
}

#if SWIFT_PACKAGE
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
#endif

