//
//  UIView+debug.swift
//  Ruka
//
//  Created by Enrique Garcia Alvarez on 6/4/24.
//

import Foundation
import UIKit
import os.log

extension UIView {
    static let log = Logger(subsystem: "App", category: "App")

    static func printViewHierarchy() {
        var logBuffer = ""
        let windows = UIApplication.shared.windows
        logBuffer.append("windows:\(windows.count)\n")
        if windows.count == 1 {
            if let window = windows.first {
                window.printViewHierarchy(&logBuffer)
            }
        } else {
            for window in windows {
                let windowLevelString = window.isKeyWindow ? " (key window)" : ""
                logBuffer.append("Window level \(window.windowLevel.rawValue)\(windowLevelString)\n")
                window.printViewHierarchy(&logBuffer)
                logBuffer.append("\n")
            }
        }
        log.debug("\(logBuffer)")
    }

    func printViewHierarchy(_ logBuffer: inout String, indentation: Int = 0) {
        appendIndentation(&logBuffer, indentation)
        printClassName(&logBuffer)
        printViewDetails(&logBuffer)
        printAccessibilityInfo(&logBuffer)

        logBuffer.append(isHidden ? " (👻)" : " (👀)")
        logBuffer.append(isTappable() ? " (🫵)" : " (🫵🚫)")

        if let imageView = self as? UIImageView {
            logBuffer.append(imageView.isHighlighted ? " (highlighted)" : " (not highlighted)")
        }

        if let control = self as? UIControl {
            logBuffer.append(control.isEnabled ? " (enabled)" : " (not enabled)")
            logBuffer.append(control.isSelected ? " (selected)" : " (not selected)")
            logBuffer.append(control.isHighlighted ? " (highlighted)" : " (not highlighted)")
        }

#if !os(tvOS)
        if let datePicker = self as? UIDatePicker {
            printDatePickerState(datePicker, &logBuffer)
        }
#endif
        if !logBuffer.isEmpty {
            logBuffer.append("\n")
        }

        printAccessibilityElements(&logBuffer, indentation: indentation)

        guard !isKind(of: NSClassFromString("_UIDatePickerView")!) else {
            return
        }

        for subview in subviews {
            subview.printViewHierarchy(&logBuffer, indentation: indentation + 1)
        }
    }

    private func appendIndentation(_ logBuffer: inout String, _ indent: Int) {
        for _ in 0..<indent {
            logBuffer.append("|\t")
        }
    }

    private func printClassName(_ logBuffer: inout String) {
        let className = String(describing: type(of: self))
        let address = Unmanaged.passUnretained(self).toOpaque()
        logBuffer.append("\(className) \(address)")
    }

    private func printAccessibilityInfo(_ logBuffer: inout String) {
        if let label = accessibilityLabel {
            logBuffer.append(", ♿️label: \(label)")
        }

        if let identifier = accessibilityIdentifier {
            logBuffer.append(", ♿️identifier: \(identifier)")
        }
    }

    @available(tvOS, unavailable)
    private func printDatePickerState(_ datePicker: UIDatePicker, _ logBuffer: inout String) {
        logBuffer.append(" (date range: \(datePicker.minimumDate?.description ?? "no minimum") - \(datePicker.maximumDate?.description ?? "no maximum"))")
        logBuffer.append(" (mode: \(datePickerModeString(datePicker.datePickerMode)))")
        logBuffer.append(" (minute interval: \(datePicker.minuteInterval))")
    }

    @available(tvOS, unavailable)
    private func datePickerModeString(_ mode: UIDatePicker.Mode) -> String {
        switch mode {
        case .time:
            return "Time"
        case .date:
            return "Date"
        case .dateAndTime:
            return "DateAndTime"
        case .countDownTimer:
            return "CountDownTimer"
        default:
            // Using reflection to check if `mode` is `yearAndMonth` when running on newer iOS versions
            if #available(iOS 17.4, *), mode == UIDatePicker.Mode(rawValue: 5) {
                return "YearAndMonth"
            } else {
                return "Unknown"
            }
        }
    }

    private func printAccessibilityElements(_ logBuffer: inout String, indentation: Int) {
        let elementCount = accessibilityElementCount()
        if elementCount != NSNotFound {
            for index in 0..<elementCount {
                guard let element = accessibilityElement(at: index) as? UIAccessibilityElement else { continue }
                appendIndentation(&logBuffer, indentation)
                logBuffer.append("\(type(of: element)), label: \(element.accessibilityLabel ?? "")")
                if let value = element.accessibilityValue {
                    logBuffer.append(", value: \(value)")
                }
                if let hint = element.accessibilityHint {
                    logBuffer.append(", hint: \(hint)")
                }
                printAccessibilityTraits(&logBuffer, element.accessibilityTraits)
                logBuffer.append("\n")
            }
        }
    }

    private func printAccessibilityTraits(_ logBuffer: inout String, _ traits: UIAccessibilityTraits) {
        logBuffer.append("traits: ")
        var didPrintOne = false

        func printTrait(_ trait: String) {
            logBuffer.append(didPrintOne ? ", \(trait)" : trait)
            didPrintOne = true
        }

        if traits == .none {
            printTrait("none")
        }
        if traits.contains(.button) { printTrait("button") }
        if traits.contains(.link) { printTrait("link") }
        if traits.contains(.header) { printTrait("header") }
        // Add more traits as needed

        if !didPrintOne {
            logBuffer.append("unknown flags (\(traits))")
        }
    }

    private func printViewDetails(_ logBuffer: inout String) {
        let formattedOrigin = String(format: "(x:%.1f, y:%.1f)", frame.origin.x, frame.origin.y)
        let formattedSize = String(format: "(W:%.1f, H:%.1f)", frame.size.width, frame.size.height)

        logBuffer.append(" F:\(formattedOrigin)-\(formattedSize)")
        logBuffer.append(isUserInteractionEnabled ? ", interaction ✅" : ", interaction ❌")
    }
}
