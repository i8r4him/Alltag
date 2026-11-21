//
//  KeyboardSettings.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 21.11.26.
//

import Foundation

/// What the learner can switch in the keyboard itself. Everything is on at first.
struct KeyboardSettings: Equatable {
    enum Option: String, CaseIterable, Identifiable {
        /// The click of a key; iOS plays it only when its own keyboard clicks are on.
        case sound
        /// The tap felt under a key; iOS gives it to a keyboard only with Full Access.
        case haptics
        /// The words offered over the keys.
        case suggestions
        /// A mistyped word is put right at the space after it.
        case autoCorrection
        /// A capital at the start of a sentence, where the text field wants one.
        case autoCapitals
        /// A second space after a word makes a full stop.
        case fullStopShortcut

        var id: String { rawValue }
    }

    private var off: Set<Option> = []

    subscript(option: Option) -> Bool {
        get { !off.contains(option) }
        set {
            if newValue {
                off.remove(option)
            } else {
                off.insert(option)
            }
        }
    }
}

/// Where the settings are kept between two showings of the keyboard.
protocol KeyboardSettingsStore {
    func load() -> KeyboardSettings
    func save(_ settings: KeyboardSettings)
}

/// Keeps the settings in the keyboard's own defaults, which need no Full Access.
struct DefaultsKeyboardSettingsStore: KeyboardSettingsStore {
    var defaults: UserDefaults = .standard

    private func key(_ option: KeyboardSettings.Option) -> String { "keyboard.off.\(option.rawValue)" }

    func load() -> KeyboardSettings {
        var settings = KeyboardSettings()
        for option in KeyboardSettings.Option.allCases where defaults.bool(forKey: key(option)) {
            settings[option] = false
        }
        return settings
    }

    func save(_ settings: KeyboardSettings) {
        for option in KeyboardSettings.Option.allCases {
            defaults.set(!settings[option], forKey: key(option))
        }
    }
}
