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
//        let animations = self.hasFiniteAnimations()
        let animations = false

//        self.sublayers?.forEach { sublayer in
//            if animations { return } // Exit if animations already found
//            animations = sublayer.hasFiniteAnimations()
//        }
        logger.debug("\(#function) animating:->\(animations)")
        return animations
    }

    func checkLayerForAnimations(layer: CALayer,
                                 animationsDictionary: inout [String: String],
                                 howManyAnimating: inout Int) {
        layer.hasFiniteAnimations(animationsDictionary: &animationsDictionary,
                                  howManyAnimating: &howManyAnimating)
    }

    @discardableResult
    func hasFiniteAnimations(animationsDictionary: inout [String: String],
                             howManyAnimating: inout Int) -> Bool {
        return !hasInfiniteAnimations(animationsDictionary: &animationsDictionary,
                                      howManyAnimating: &howManyAnimating)
    }

    private func hasInfiniteAnimations(animationsDictionary: inout [String: String],
                                       howManyAnimating: inout Int) -> Bool {
        // Skip checking hidden layers and their descendants
        guard !self.isHidden else {
            return false
        }

        // Check animations on the current layer
        if let animationKeys = self.animationKeys(),
           !animationKeys.isEmpty {
            if animationKeys.contains(where: {isAnimationInfinite(animationKey: $0,
                                                                  animationsDictionary: &animationsDictionary,
                                                                  howManyAnimating: &howManyAnimating)}) {
                return true
            }
        }
        return false
    }

    func isAnimationInfinite(animationKey: String,
                             animationsDictionary: inout [String: String],
                             howManyAnimating: inout Int) -> Bool {
        if let animation = self.animation(forKey: animationKey),
           let propertyAnimation = animation as? CAPropertyAnimation {
            let beginTime = propertyAnimation.beginTime
            let completionTime = propertyAnimation.completionTime
            let absoluteTime = CACurrentMediaTime()
            let currentTime = convertTime(absoluteTime, to: self)
            if completionTime == Double.greatestFiniteMagnitude {
                animationsDictionary[String(describing: self)] = "♾️" + animationKey
                return true
            } else if currentTime >= beginTime,
                      currentTime < completionTime {
                animationsDictionary[String(describing: self)] = animationKey
                howManyAnimating += 1
                return false
            } else {
                animationsDictionary[String(describing: self)] = "🤪" + animationKey
                switch propertyAnimation.fillMode {
                case .removed:
                    howManyAnimating += 1
                default:
                    ()
//                    howManyAnimating += 1
                }
                return false
            }
        }
        return false
    }
}

extension CAMediaTimingFillMode: CustomStringConvertible {
    public var description: String {
        return debugDescription
    }
    
    public var debugDescription: String {
        switch self {
        case .backwards: 
            return "backwards"
        case .forwards:
            return "forwards"
        case .both:
            return "both"
        case .removed:
            return "removed"
        default:
            return "unknown"
        }
    }
}

extension CALayer {
    public override var description: String {
        return debugDescription
    }

    public override var debugDescription: String {
        return """
        CALayer:
          - beginTime: \(beginTime)
          - duration: \(duration)
          - speed: \(speed) - currentSpeed: \(currentSpeed)
          - timeOffset: \(timeOffset)
          - repeatCount: \(repeatCount)
          - repeatDuration: \(repeatDuration)
          - autoreverses: \(autoreverses)
          - fillMode: \(fillMode)
          - frame: \(frame)
          - bounds: \(bounds)
          - position: \(position)
          - anchorPoint: \(anchorPoint)
          - zPosition: \(zPosition)
          - transform: \(transform)
          - opacity: \(opacity)
          - isHidden: \(isHidden)
          - cornerRadius: \(cornerRadius)
          - borderWidth: \(borderWidth)
          - borderColor: \(String(describing: borderColor))
          - backgroundColor: \(String(describing: backgroundColor))
          - shadowOpacity: \(shadowOpacity)
          - shadowRadius: \(shadowRadius)
          - shadowOffset: \(shadowOffset)
          - shadowColor: \(String(describing: shadowColor))
          - masksToBounds: \(masksToBounds)
          - sublayers count: \(sublayers?.count ?? 0)
          - isDoubleSided: \(isDoubleSided)
          - contents: \(String(describing: contents))
          - contentsRect: \(contentsRect)
          - contentsGravity: \(contentsGravity.rawValue)
          - contentsScale: \(contentsScale)
          - isOpaque: \(isOpaque)
        """
    }
}


/// CAAnimation
/// ├── CAPropertyAnimation
/// │   ├── CABasicAnimation
/// │   ├── CAKeyframeAnimation
/// │   └── CASpringAnimation
/// ├── CATransition
/// └── CAAnimationGroup

extension CAAnimation {
    public override var description: String {
        return debugDescription
    }

    public override var debugDescription: String {
        return """
        CAAnimation: \(type(of: self))
          - beginTime: \(beginTime)
          - duration: \(duration)
          - completion: \(completionTime)
          - speed: \(speed)
          - timeOffset: \(timeOffset)
          - repeatCount: \(repeatCount)
          - repeatDuration: \(repeatDuration)
          - autoreverses: \(autoreverses)
          - fillMode: \(fillMode.rawValue)
          - timingFunction: \(timingFunction?.description ?? "nil")
          - isRemovedOnCompletion: \(isRemovedOnCompletion)
        """
    }
}

extension CABasicAnimation {
    override public var debugDescription: String {
        return """
        CABasicAnimation: \(type(of: self)):
          - keyPath: \(String(describing: keyPath))
          - fromValue: \(String(describing: fromValue))
          - toValue: \(String(describing: toValue))
          - byValue: \(String(describing: byValue))
          \(super.debugDescription)
        """
    }
}

extension CAKeyframeAnimation {
    override public var debugDescription: String {
        return """
        CAKeyframeAnimation: \(type(of: self)):
          - keyPath: \(String(describing: keyPath))
          - values: \(String(describing: values))
          - keyTimes: \(String(describing: keyTimes))
          - timingFunctions: \(String(describing: timingFunctions))
          - calculationMode: \(calculationMode.rawValue)
          \(super.debugDescription)
        """
    }
}

extension CASpringAnimation {
    override public var debugDescription: String {
        return """
        CASpringAnimation: \(type(of: self)):
          - keyPath: \(String(describing: keyPath))
          - mass: \(mass)
          - stiffness: \(stiffness)
          - damping: \(damping)
          - initialVelocity: \(initialVelocity)
          \(super.debugDescription)
        """
    }
}

extension CAAnimationGroup {
    override public var debugDescription: String {
        return """
        CAAnimationGroup: \(type(of: self)):
          - animations: \(String(describing: animations))
          \(super.debugDescription)
        """
    }
}
