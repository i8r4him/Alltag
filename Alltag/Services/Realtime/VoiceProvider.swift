//
//  VoiceProvider.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import Foundation

/// Who provides the live voice.
///
/// TEMPORARY (#309): both are built so the maintainer can hear the same situation
/// with each on the iPhone (Settings › Developer). The one that isn't chosen goes,
/// with this switch.
enum VoiceProvider: String, CaseIterable, Identifiable {
    case openAI = "openai"
    case gemini

    /// Where the choice is kept.
    static let key = "voice.provider"

    static var current: VoiceProvider {
        VoiceProvider(rawValue: UserDefaults.standard.string(forKey: key) ?? "") ?? .openAI
    }

    var id: String { rawValue }

    /// A product name, not text to translate.
    var name: String {
        switch self {
        case .openAI: "OpenAI (gpt-realtime)"
        case .gemini: "Google (Gemini Live)"
        }
    }
}

/// Starts each live conversation with the provider chosen at that moment.
struct SwitchingRealtimeConversationService: RealtimeConversationService {
    var provider: () -> VoiceProvider = { .current }
    var openAI: any RealtimeConversationService = OpenAIRealtimeConversationService()
    var gemini: any RealtimeConversationService = GeminiLiveConversationService()

    func makeSession(for context: RealtimeConversationContext) -> any RealtimeConversationSession {
        switch provider() {
        case .openAI: openAI.makeSession(for: context)
        case .gemini: gemini.makeSession(for: context)
        }
    }
}
