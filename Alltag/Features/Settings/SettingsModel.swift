//
//  SettingsModel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import FoundationModels
import Observation

/// Settings toggles that need a system permission, and the on-device AI status.
@Observable
final class SettingsModel {
    /// Shown as a toast when a permission is refused.
    var message: LocalizedStringResource?

    @ObservationIgnored private let notifications: any NotificationService

    init(services: AppServices) {
        notifications = services.notifications
    }

    /// Turns rehearsal reminders on (asking to notify) or off.
    func setRemindersEnabled(_ isOn: Bool, on profile: UserProfile) async {
        profile.remindersEnabled = isOn
        guard isOn, await notifications.requestAuthorization() != .granted else { return }
        profile.remindersEnabled = false
        message = "Allow notifications in the Settings app first."
    }

    /// Turns the morning briefing on (asking to notify) or off.
    func setMorningBriefingEnabled(_ isOn: Bool, on profile: UserProfile) async {
        profile.morningBriefingEnabled = isOn
        guard isOn, await notifications.requestAuthorization() != .granted else { return }
        profile.morningBriefingEnabled = false
        message = "Allow notifications in the Settings app first."
    }
}

/// Whether Apple Intelligence can run Alltag's corrections on this device.
enum OnDeviceAIStatus: Equatable {
    case available
    case notEnabled
    case notReady
    case notSupported

    init(_ availability: SystemLanguageModel.Availability) {
        switch availability {
        case .available: self = .available
        case .unavailable(.appleIntelligenceNotEnabled): self = .notEnabled
        case .unavailable(.modelNotReady): self = .notReady
        case .unavailable: self = .notSupported
        }
    }

    static var current: OnDeviceAIStatus { OnDeviceAIStatus(SystemLanguageModel.default.availability) }

    var isAvailable: Bool { self == .available }

    var detail: LocalizedStringResource {
        switch self {
        case .available:
            "Apple Intelligence is available on this device. Corrections and explanations run privately on device."
        case .notEnabled:
            "Turn on Apple Intelligence in the Settings app to run corrections privately on device."
        case .notReady:
            "Apple Intelligence is getting ready. Corrections will run on device once it has downloaded."
        case .notSupported:
            "This device doesn't support Apple Intelligence. Corrections use Alltag's built-in explanations."
        }
    }
}
