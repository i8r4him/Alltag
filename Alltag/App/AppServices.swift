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
    var articles: any ArticleService = UnavailableArticleService()
    var realtime: any RealtimeConversationService = MockRealtimeConversationService()

    /// Real voice services, and the companion that checks sentences with OpenAI or on device.
    static func live() -> AppServices {
        AppServices(
            speech: liveSpeech(),
            voice: SystemVoiceService(),
            translation: CloudTranslationService(),
            companion: liveCompanion(),
            calendar: MockCalendarService(),
            notifications: MockNotificationService(),
            articles: CloudArticleService(),
            realtime: liveRealtime()
        )
    }

    /// The simulator can't recognise speech, so it keeps the simulated listening.
    private static func liveSpeech() -> any SpeechService {
        #if targetEnvironment(simulator)
        MockSpeechService()
        #else
        SystemSpeechService()
        #endif
    }

    /// Checks sentences with Apple's cloud model, then OpenAI, then on device.
    private static func liveCompanion() -> any CompanionService {
        CloudCompanionService()
    }

    private static func liveRealtime() -> any RealtimeConversationService {
        #if targetEnvironment(simulator)
        SimulatedRealtimeConversationService()
        #else
        OpenAIRealtimeConversationService()
        #endif
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
