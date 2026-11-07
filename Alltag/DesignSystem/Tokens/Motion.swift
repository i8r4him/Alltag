//
//  Motion.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Animations and transitions from the design spec.
///
/// Every function takes `reduceMotion`: pass `@Environment(\.reducesMotion)`,
/// which combines the system setting with the in-app Reduce Motion toggle.
/// With it on, movement is replaced by a short fade.
enum Motion {
    /// Ease-out curve used across the app: `cubic-bezier(.2, .8, .2, 1)`.
    static func easeOut(duration: TimeInterval) -> Animation {
        .timingCurve(0.2, 0.8, 0.2, 1, duration: duration)
    }

    /// Pushing a screen: slide 28pt and fade, 0.4s.
    static func push(reduceMotion: Bool) -> Animation {
        reduceMotion ? reducedAnimation : easeOut(duration: 0.4)
    }

    /// Presenting a modal: rise 48pt and fade, 0.45s.
    static func modal(reduceMotion: Bool) -> Animation {
        reduceMotion ? reducedAnimation : easeOut(duration: 0.45)
    }

    static func pushTransition(reduceMotion: Bool) -> AnyTransition {
        reduceMotion ? .opacity : .offset(x: pushOffset).combined(with: .opacity)
    }

    static func modalTransition(reduceMotion: Bool) -> AnyTransition {
        reduceMotion ? .opacity : .offset(y: modalOffset).combined(with: .opacity)
    }

    static let pushOffset: CGFloat = 28
    static let modalOffset: CGFloat = 48
    private static let reducedAnimation: Animation = .easeInOut(duration: 0.2)
}

extension EnvironmentValues {
    /// Whether motion should be reduced: the system setting or the in-app
    /// toggle in Settings. Set once by `RootView` for the whole app.
    @Entry var reducesMotion = false
}
