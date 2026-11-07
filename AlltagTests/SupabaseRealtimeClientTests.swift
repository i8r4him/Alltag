//
//  SupabaseRealtimeClientTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Supabase Realtime client")
@MainActor
struct SupabaseRealtimeClientTests {
    private let context = RealtimeConversationContext(scenario: MockScenarios.dentist, level: .b1, slowerSpeech: false)

    @Test("Signs in anonymously and reloads saved credentials for the next client")
    func signIn() async throws {
        let store = MemoryTokenStore()
        let transport = StubHTTP([auth(), ticket(), ticket()])
        let first = SupabaseRealtimeClient(store: store, send: transport.send)

        let credentials = try await first.credentials(for: context)
        #expect(credentials.clientSecret == "ek_test")
        #expect(credentials.model == "server-selected-model")
        #expect(credentials.voice == "marin")
        #expect(store.saved == 1)

        let second = SupabaseRealtimeClient(store: store, send: transport.send)
        _ = try await second.credentials(for: context)
        #expect(transport.requests.compactMap(\.url?.path) == [
            "/auth/v1/signup", "/functions/v1/realtime-session", "/functions/v1/realtime-session"
        ])
        let signup = try #require(transport.requests.first)
        #expect(signup.httpMethod == "POST")
        #expect(signup.value(forHTTPHeaderField: "apikey") == SupabaseConfiguration.publishableKey)
        #expect(try body(of: signup).isEmpty)

        let request = try #require(transport.requests.last)
        #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer access")
        let instructions = try #require(try body(of: request)["instructions"])
        #expect(instructions.contains(MockScenarios.dentist.title))
        #expect(instructions.contains(MockScenarios.dentist.goal))
        #expect(instructions.contains("B1"))
    }

    @Test("Refreshes an expired token from storage before calling the function")
    func expired() async throws {
        let store = MemoryTokenStore()
        let transport = StubHTTP([auth(expiresIn: 0), ticket(), auth(access: "new", refresh: "rotated"), ticket()])
        _ = try await SupabaseRealtimeClient(store: store, send: transport.send).credentials(for: context)
        _ = try await SupabaseRealtimeClient(store: store, send: transport.send).credentials(for: context)

        #expect(transport.requests.compactMap(\.url?.path) == [
            "/auth/v1/signup", "/functions/v1/realtime-session", "/auth/v1/token", "/functions/v1/realtime-session"
        ])
        #expect(store.saved == 2)
    }

    @Test("A 401 refreshes and retries exactly once", arguments: [true, false])
    func unauthorized(retrySucceeds: Bool) async throws {
        let store = MemoryTokenStore()
        let unauthorized = (401, #"{"error":"unauthorized"}"#)
        let transport = StubHTTP([auth(), unauthorized, auth(access: "new", refresh: "rotated"),
                                  retrySucceeds ? ticket() : unauthorized])
        let client = SupabaseRealtimeClient(store: store, send: transport.send)

        if retrySucceeds {
            _ = try await client.credentials(for: context)
        } else {
            await #expect(throws: RealtimeServiceError.unauthorised) { try await client.credentials(for: context) }
        }
        #expect(transport.requests.count == 4)
        let refresh = try #require(transport.requests.first { $0.url?.path == "/auth/v1/token" })
        #expect(refresh.url?.query() == "grant_type=refresh_token")
        #expect(try body(of: refresh) == ["refresh_token": "refresh"])
        #expect(transport.requests.last?.value(forHTTPHeaderField: "Authorization") == "Bearer new")
        #expect(store.saved == 2)
    }

    @Test("Maps function errors without refreshing for non-401 responses", arguments: [
        (429, "daily_limit", RealtimeServiceError.dailyLimit),
        (429, "busy", RealtimeServiceError.busy),
        (502, "upstream", RealtimeServiceError.upstream),
        (503, "not_configured", RealtimeServiceError.notConfigured),
        (503, "unavailable", RealtimeServiceError.unavailable),
        (405, "method_not_allowed", RealtimeServiceError.unexpectedResponse)
    ])
    func errors(status: Int, code: String, expected: RealtimeServiceError) async {
        let transport = StubHTTP([auth(), (status, #"{"error":"\#(code)"}"#)])
        let client = SupabaseRealtimeClient(store: MemoryTokenStore(), send: transport.send)

        await #expect(throws: expected) { try await client.credentials(for: context) }
        #expect(transport.requests.count == 2)
    }

    private func auth(access: String = "access", refresh: String = "refresh", expiresIn: Int = 3_600) -> (Int, String) {
        (200, #"{"access_token":"\#(access)","refresh_token":"\#(refresh)","expires_in":\#(expiresIn)}"#)
    }

    private func ticket() -> (Int, String) {
        (200, #"{"client_secret":"ek_test","expires_at":4000000000,"model":"server-selected-model","voice":"marin"}"#)
    }

    private func body(of request: URLRequest) throws -> [String: String] {
        try JSONDecoder().decode([String: String].self, from: #require(request.httpBody))
    }
}

@MainActor
private final class MemoryTokenStore: SupabaseTokenStore {
    private var data: Data?
    private(set) var saved = 0

    func load() throws -> Data? { data }

    func save(_ data: Data) throws {
        self.data = data
        saved += 1
    }

    func remove() throws { data = nil }
}

@MainActor
private final class StubHTTP {
    private var responses: [(Int, String)]
    private(set) var requests: [URLRequest] = []

    init(_ responses: [(Int, String)]) { self.responses = responses }

    func send(_ request: URLRequest) async throws -> (Data, Int) {
        requests.append(request)
        guard !responses.isEmpty else { throw RealtimeServiceError.unexpectedResponse }
        let (status, body) = responses.removeFirst()
        return (Data(body.utf8), status)
    }
}
