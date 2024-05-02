//
//  CALayer+ext.swift
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
import os.log

extension CALayer {
    var currentSpeed: Float {
        var speed: Float = 1.0
        var layer: CALayer? = self
        while let currentLayer = layer {
            speed *= currentLayer.speed
            layer = currentLayer.superlayer
        }
        return speed
    }

    func hasFiniteAnimations(logged: Bool) -> Bool {
        if logged {
            return hasFiniteAnimationsLogged()
        } else {
            return hasFiniteAnimationsNotLogged()
        }
    }

    func hasFiniteAnimationsLogged() -> Bool {
        let logger = Logger(subsystem: "App", category: "App")
        var howManyAnimating = 0
        var animationsDictionary: [String: String] = [:]

        checkLayerForAnimations(layer: self,
                                animationsDictionary: &animationsDictionary,
                                howManyAnimating: &howManyAnimating)

        self.sublayers?.forEach { sublayer in
            checkLayerForAnimations(layer: sublayer,
                                    animationsDictionary: &animationsDictionary,
                                    howManyAnimating: &howManyAnimating)
        }

        logger.debug("\(#function) animating:->\(howManyAnimating)->\(animationsDictionary)")
        return howManyAnimating != 0
    }

    func hasFiniteAnimationsNotLogged() -> Bool {
        let logger = Logger(subsystem: "App", category: "App")
        var animations = self.hasFiniteAnimations()

        self.sublayers?.forEach { sublayer in
            if animations { return } // Exit if animations already found
            animations = sublayer.hasFiniteAnimations()
        }
        logger.debug("\(#function) animating:->\(animations)")
        return animations
    }

    func checkLayerForAnimations(layer: CALayer,
                                 animationsDictionary: inout [String: String],
                                 howManyAnimating: inout Int) {
        if layer.hasFiniteAnimations(),
           let animationKeys = layer.animationKeys() {
            animationsDictionary[String(describing: layer)] = animationKeys.joined(separator: ",")
            howManyAnimating += 1
        }
    }

    func hasFiniteAnimations() -> Bool {
        return !hasInfiniteAnimations()
    }

    private func hasInfiniteAnimations() -> Bool {
        // Skip checking hidden layers and their descendants
        guard !self.isHidden else {
            return false
        }

        // Check animations on the current layer
        if let animationKeys = self.animationKeys(),
           !animationKeys.isEmpty {
            if animationKeys.contains(where: isAnimationInfinite) {
                return true
            }
        }
        return false
    }

    func isAnimationInfinite(animationKey: String) -> Bool {
        if let animation = self.animation(forKey: animationKey) {
            let beginTime = animation.beginTime
            let completionTime = animation.completionTime
            let currentTime = CACurrentMediaTime() * Double(self.currentSpeed)
            if currentTime >= beginTime,
               completionTime != Double.infinity,
               currentTime < completionTime {
                return true
            }
        }
        return false
    }
}
