//
//  KeyFeedback.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import UIKit

/// The click heard and the tap felt when a key goes down.
protocol KeyFeedback: AnyObject {
    func keyDown(_ key: KeyboardKey)
}

/// The system's keyboard click, which follows the "Keyboard Clicks" setting,
/// and a light haptic, which iOS only gives a keyboard with Full Access.
final class SystemKeyFeedback: KeyFeedback {
    var allowsHaptics = false
    private let haptic = UIImpactFeedbackGenerator(style: .light)

    func keyDown(_ key: KeyboardKey) {
        UIDevice.current.playInputClick()
        guard allowsHaptics else { return }
        haptic.impactOccurred()
        haptic.prepare()
    }
}

/// `playInputClick()` only sounds when the input view says clicks are wanted.
extension UIInputView: @retroactive UIInputViewAudioFeedback {
    @objc public var enableInputClicksWhenVisible: Bool { true }
}
