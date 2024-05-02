//
//  CAAnimation+ext.swift
//  Ruka
//
//  Created by Enrique Garcia Alvarez on 15/4/24.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

extension CAAnimation {
    var completionTime: Double {
        if self.repeatDuration > 0 {
            return self.beginTime + self.repeatDuration
        } else if self.repeatCount == Float.infinity {
            return Double.infinity
        } else if self.repeatCount > 0 {
            return self.beginTime + (Double(self.repeatCount) * self.duration)
        } else {
            return self.beginTime + self.duration
        }
    }
}
