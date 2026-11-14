//
//  SupabaseRealtimeClient+Voice.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import Foundation

extension SupabaseRealtimeClient {
    func credentials(for context: RealtimeConversationContext) async throws -> RealtimeCredentials {
        let token = try await accessToken()
        do {
            return try await issueCredentials(for: context, token: token)
        } catch RealtimeServiceError.unauthorised {
            let refreshed = try await accessToken(rejected: token)
            return try await issueCredentials(for: context, token: refreshed)
        }
    }

    func issueCredentials(for context: RealtimeConversationContext, token: String) async throws -> RealtimeCredentials {
        let body = ["scenario": context.scenario, "instructions": context.instructions]
        let data = try await call("realtime-session", body: body, token: token)
        return try JSONDecoder().decode(RealtimeCredentials.self, from: data)
    }

    /// A short-lived token for Gemini Live. The thinking pause and the slower speech go
    /// along, because the token fixes the session's whole setup.
    func geminiCredentials(for context: RealtimeConversationContext) async throws -> GeminiLiveCredentials {
        let body = ["scenario": context.scenario, "instructions": context.instructions,
                    "thinking_pause": String(context.thinkingPause), "slower": context.slowerSpeech ? "true" : "false"]
        return try JSONDecoder().decode(GeminiLiveCredentials.self, from: await post(to: "gemini-live-session", body: body))
    }
}
