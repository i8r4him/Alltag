//
//  SupabaseRealtimeClient+Voice.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import Foundation

extension SupabaseRealtimeClient {
    /// A short-lived token for Gemini Live. The thinking pause, the slower speech and
    /// hold to talk go along, because the token fixes the session's whole setup.
    func geminiCredentials(for context: RealtimeConversationContext) async throws -> GeminiLiveCredentials {
        let body = ["scenario": context.scenario, "instructions": context.instructions,
                    "thinking_pause": String(context.thinkingPause), "slower": context.slowerSpeech ? "true" : "false",
                    "push_to_talk": context.holdsToTalk ? "true" : "false"]
        return try JSONDecoder().decode(GeminiLiveCredentials.self, from: await post(to: "gemini-live-session", body: body))
    }
}
