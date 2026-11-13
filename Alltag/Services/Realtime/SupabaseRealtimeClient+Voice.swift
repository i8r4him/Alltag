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
}
