//
//  UIView+debug.swift
//  Ruka
//
//  Created by Enrique Garcia Alvarez on 6/4/24.
//

import Foundation
import UIKit

extension UIView {
    static func printViewHierarchy() {
        let windows = UIApplication.shared.windows
        print("windows:\(windows.count)")
        if windows.count == 1 {
            windows.first?.printViewHierarchy()
        } else {
            for window in windows {
                print("Window level \(window.windowLevel)", terminator: window.isKeyWindow ? " (key window)\n" : "\n")
                window.printViewHierarchy()
                print("\n")
            }
        }
    }

    func printViewHierarchy(indentation: Int = 0) {
        printIndentation(indentation)
        printClassName()
        printViewDetails()
        printAccessibilityInfo()

        if isHidden {
            print(" (👻)", terminator: "")
        } else {
            print(" (👀)", terminator: "")
        }

        if isTappable() {
            print(" (🫵)", terminator: "")
        } else {
            print(" (🖕)", terminator: "")
        }

        if let imageView = self as? UIImageView {
            printImageHighlightedState(imageView)
        }

        if let control = self as? UIControl {
            printControlState(control)
        }

        if let datePicker = self as? UIDatePicker {
            printDatePickerState(datePicker)
        }

        print("\n", terminator: "")

        printAccessibilityElements(indentation: indentation)

        guard !isKind(of: NSClassFromString("_UIDatePickerView")!) else {
            return
        }

        for subview in subviews {
            subview.printViewHierarchy(indentation: indentation + 1)
        }
    }

    private func printIndentation(_ indent: Int) {
        for _ in 0..<indent {
            print("|\t", terminator: "")
        }
    }

    private func printClassName() {
        let className = String(describing: type(of: self))
        let address = Unmanaged.passUnretained(self).toOpaque()
        print("\(className) \(address)", terminator: "")
    }

    private func printAccessibilityInfo() {
        if let label = accessibilityLabel {
            print(", label: \(label)", terminator: "")
        }

        if let identifier = accessibilityIdentifier {
            print(", identifier: \(identifier)", terminator: "")
        }
    }

    private func printImageHighlightedState(_ imageView: UIImageView) {
        print(imageView.isHighlighted ? " (highlighted)" : " (not highlighted)", terminator: "")
    }

    private func printControlState(_ control: UIControl) {
        print(control.isEnabled ? " (enabled)" : " (not enabled)", terminator: "")
        print(control.isSelected ? " (selected)" : " (not selected)", terminator: "")
        print(control.isHighlighted ? " (highlighted)" : " (not highlighted)", terminator: "")
    }

    private func printDatePickerState(_ datePicker: UIDatePicker) {
        print(" (date range: \(datePicker.minimumDate?.description ?? "no minimum") - \(datePicker.maximumDate?.description ?? "no maximum"))", terminator: "")
        print(" (mode: \(datePickerModeString(datePicker.datePickerMode)))", terminator: "")
        print(" (minute interval: \(datePicker.minuteInterval))", terminator: "")
    }

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
        case .yearAndMonth:
            return "yearAndMonth"
        @unknown default:
            return "Unknown"
        }
    }

    private func printAccessibilityElements(indentation: Int) {
        let elementCount = accessibilityElementCount()
        if elementCount != NSNotFound {
            for index in 0..<elementCount {
                guard let element = accessibilityElement(at: index) as? UIAccessibilityElement else { continue }
                printIndentation(indentation)
                print("\(type(of: element)), label: \(element.accessibilityLabel ?? "")", terminator: "")
                if let value = element.accessibilityValue {
                    print(", value: \(value)", terminator: "")
                }
                if let hint = element.accessibilityHint {
                    print(", hint: \(hint)", terminator: "")
                }
                printAccessibilityTraits(element.accessibilityTraits)
                print("")
            }
        }
    }

    private func printAccessibilityTraits(_ traits: UIAccessibilityTraits) {
        print("traits: ", terminator: "")
        var didPrintOne = false

        func printTrait(_ trait: String) {
            print(didPrintOne ? ", \(trait)" : trait, terminator: "")
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
            print("unknown flags (\(traits))", terminator: "")
        }
    }

    private func printViewDetails() {
        // Print frame
        let formattedOrigin = String(format: "(x:%.1f, y:%.1f)", frame.origin.x, frame.origin.y)
        let formattedSize = String(format: "(W:%.1f, H:%.1f)", frame.size.width, frame.size.height)

        // Print formatted frame
        print(" F:\(formattedOrigin)-\(formattedSize)", terminator: "")
        // Print user interaction status
        print(", \(isUserInteractionEnabled ? "interaction ✅" : "interaction ❌")", terminator: "")
    }
}
