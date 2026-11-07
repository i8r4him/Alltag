//
//  AppServices.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Every service the screens use. Screens read it from the environment
/// (`@Environment(\.services)`) and only talk to the protocols, so each mock
/// can be replaced by a live implementation without touching a screen.
struct AppServices {
    let speech: any SpeechService
    let voice: any VoiceService
    let translation: any TranslationService
    let companion: any CompanionService
    let calendar: any CalendarService
    let notifications: any NotificationService

    /// Real voice and the on-device companion; everything else simulated.
    static func live() -> AppServices {
        AppServices(
            speech: MockSpeechService(),
            voice: SystemVoiceService(),
            translation: MockTranslationService(),
            companion: OnDeviceCompanionService(),
            calendar: MockCalendarService(),
            notifications: MockNotificationService()
        )
    }

    /// Fully simulated and silent, for previews and tests.
    static func mock() -> AppServices {
        AppServices(
            speech: MockSpeechService(),
            voice: MockVoiceService(),
            translation: MockTranslationService(),
            companion: MockCompanionService(),
            calendar: MockCalendarService(),
            notifications: MockNotificationService()
        )
    }
}

extension EnvironmentValues {
    /// Defaults to silent mocks, so previews work without setup.
    @Entry var services: AppServices = .mock()
}
