//
//  AppSettings.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Observation

/// Settings that belong to this device rather than to the learner's profile:
/// accessibility, privacy and the Pro trial. Stored in `UserDefaults`.
///
/// Learning choices (level, goal, daily time) and the onboarding permissions
/// live on `UserProfile`, so they sync with the rest of the learner's data.
@Observable
final class AppSettings {
    /// In-app Reduce Motion, on top of the system setting.
    var reduceMotion: Bool { didSet { store(reduceMotion, .reduceMotion) } }
    /// Speak German slowly unless a screen asks otherwise.
    var slowerSpeech: Bool { didSet { store(slowerSpeech, .slowerSpeech) } }
    /// Pro features (conversations you start) may use the cloud.
    var usesCloudForPro: Bool { didSet { store(usesCloudForPro, .usesCloudForPro) } }
    var learnsFromSafari: Bool { didSet { store(learnsFromSafari, .learnsFromSafari) } }
    var learnsFromCamera: Bool { didSet { store(learnsFromCamera, .learnsFromCamera) } }
    /// No reminders after 21:00.
    var quietEvenings: Bool { didSet { store(quietEvenings, .quietEvenings) } }
    /// Prototype stand-in for the subscription until StoreKit arrives (#54).
    var isPro: Bool { didSet { store(isPro, .isPro) } }

    @ObservationIgnored private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        reduceMotion = defaults.bool(forKey: Key.reduceMotion.rawValue)
        slowerSpeech = defaults.bool(forKey: Key.slowerSpeech.rawValue)
        usesCloudForPro = defaults.bool(forKey: Key.usesCloudForPro.rawValue)
        learnsFromSafari = defaults.object(forKey: Key.learnsFromSafari.rawValue) as? Bool ?? true
        learnsFromCamera = defaults.bool(forKey: Key.learnsFromCamera.rawValue)
        quietEvenings = defaults.object(forKey: Key.quietEvenings.rawValue) as? Bool ?? true
        isPro = defaults.bool(forKey: Key.isPro.rawValue)
    }

    /// The rate German is spoken at when a screen doesn't ask for a specific one.
    var defaultSpeechRate: SpeechRate { slowerSpeech ? .slow : .normal }

    private enum Key: String {
        case reduceMotion, slowerSpeech, usesCloudForPro, learnsFromSafari, learnsFromCamera, quietEvenings, isPro
    }

    private func store(_ value: Bool, _ key: Key) {
        defaults.set(value, forKey: key.rawValue)
    }
}
