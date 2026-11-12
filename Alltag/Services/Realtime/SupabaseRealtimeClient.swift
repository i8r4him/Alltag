//
//  SupabaseRealtimeClient.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Security

enum SupabaseConfiguration {
    static let url = "https://flbymqlcauvwumznvviq.supabase.co"

    static func endpoint(_ path: String) throws -> URL {
        guard let base = URL(string: url) else { throw RealtimeServiceError.notConfigured }
        return base.appending(path: path)
    }
    static let publishableKey = "sb_publishable_b26lEqjEmiwWbQYZ-EO4QQ_d5OB-mUV"
}

struct RealtimeCredentials: Decodable {
    let clientSecret: String
    let expiresAt: TimeInterval
    let model: String
    let voice: String

    enum CodingKeys: String, CodingKey {
        case clientSecret = "client_secret"
        case expiresAt = "expires_at"
        case model, voice
    }
}

enum RealtimeServiceError: Error, Equatable {
    case unauthorised, dailyLimit, busy, upstream, notConfigured, unavailable, unexpectedResponse
}

protocol SupabaseTokenStore {
    func load() throws -> Data?
    func save(_ data: Data) throws
    func remove() throws
}

struct KeychainSupabaseTokenStore: SupabaseTokenStore {
    private var query: [String: Any] {
        [kSecClass as String: kSecClassGenericPassword,
         kSecAttrService as String: "Alltag.Supabase",
         kSecAttrAccount as String: "anonymous-session"]
    }

    func load() throws -> Data? {
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query.merging([kSecReturnData as String: true]) { _, new in new } as CFDictionary, &result)
        if status == errSecItemNotFound { return nil }
        try check(status)
        return result as? Data
    }

    func save(_ data: Data) throws {
        let attributes = [kSecValueData as String: data]
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if status == errSecItemNotFound {
            var item = query
            item[kSecValueData as String] = data
            item[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            try check(SecItemAdd(item as CFDictionary, nil))
        } else {
            try check(status)
        }
    }

    func remove() throws {
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecItemNotFound { try check(status) }
    }

    private func check(_ status: OSStatus) throws {
        guard status == errSecSuccess else { throw RealtimeServiceError.unavailable }
    }
}

/// Shares anonymous authentication across conversations, including any refresh already in progress.
final class SupabaseRealtimeClient {
    typealias Send = (URLRequest) async throws -> (Data, Int)

    private struct Tokens: Codable {
        let access: String
        let refresh: String
        let expiresAt: Date
    }

    private struct AuthResponse: Decodable {
        let accessToken: String
        let refreshToken: String
        let expiresIn: TimeInterval
    }

    private struct ErrorResponse: Decodable {
        let error: String?
        let errorCode: String?
        let code: String?
    }

    /// The app's one client, so the voice and the sentence check share a sign-in
    /// and never refresh the same token twice.
    static let shared = SupabaseRealtimeClient()

    private let store: any SupabaseTokenStore
    private let send: Send
    private var tokens: Tokens?
    private var authentication: Task<Tokens, any Error>?

    init(store: any SupabaseTokenStore = KeychainSupabaseTokenStore(), send: @escaping Send = sendRequest) {
        self.store = store
        self.send = send
    }

    func credentials(for context: RealtimeConversationContext) async throws -> RealtimeCredentials {
        let token = try await accessToken()
        do {
            return try await issueCredentials(for: context, token: token)
        } catch RealtimeServiceError.unauthorised {
            let refreshed = try await accessToken(rejected: token)
            return try await issueCredentials(for: context, token: refreshed)
        }
    }

    private func accessToken(rejected: String? = nil) async throws -> String {
        try Task.checkCancellation()
        if let authentication { return try await authentication.value.access }
        if tokens == nil, let data = try store.load() {
            tokens = try JSONDecoder().decode(Tokens.self, from: data)
        }
        if let tokens, tokens.access != rejected, tokens.expiresAt.timeIntervalSinceNow > 30 {
            return tokens.access
        }

        let task = Task {
            defer { authentication = nil }
            return try await authenticate(refresh: tokens?.refresh)
        }
        authentication = task
        return try await task.value.access
    }

    private func authenticate(refresh: String?) async throws -> Tokens {
        var endpoint = try SupabaseConfiguration.endpoint("auth/v1/signup")
        var body: [String: String] = [:]
        if let refresh {
            endpoint = try SupabaseConfiguration.endpoint("auth/v1/token")
                .appending(queryItems: [URLQueryItem(name: "grant_type", value: "refresh_token")])
            body["refresh_token"] = refresh
        }
        let (data, status) = try await send(Self.request(to: endpoint, body: body))
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard (200..<300).contains(status) else {
            let error = try? decoder.decode(ErrorResponse.self, from: data)
            let code = error?.errorCode ?? error?.code
            if refresh != nil, ["refresh_token_not_found", "refresh_token_already_used", "session_not_found"].contains(code ?? "") {
                try store.remove()
                tokens = nil
            }
            throw RealtimeServiceError.unauthorised
        }

        let result = try decoder.decode(AuthResponse.self, from: data)
        let updated = Tokens(access: result.accessToken, refresh: result.refreshToken,
                             expiresAt: .now.addingTimeInterval(result.expiresIn))
        try store.save(JSONEncoder().encode(updated))
        tokens = updated
        return updated
    }

    private func issueCredentials(for context: RealtimeConversationContext, token: String) async throws -> RealtimeCredentials {
        let body = ["scenario": context.scenario, "instructions": context.instructions]
        let data = try await call("realtime-session", body: body, token: token)
        return try JSONDecoder().decode(RealtimeCredentials.self, from: data)
    }

    /// Calls one of the project's Edge Functions as the signed-in learner and
    /// returns its answer. Signs in again once when the token was rejected.
    func post(to function: String, body: [String: String]) async throws -> Data {
        let token = try await accessToken()
        do {
            return try await call(function, body: body, token: token)
        } catch RealtimeServiceError.unauthorised {
            return try await call(function, body: body, token: try await accessToken(rejected: token))
        }
    }

    private func call(_ function: String, body: [String: String], token: String) async throws -> Data {
        try Task.checkCancellation()
        let endpoint = try SupabaseConfiguration.endpoint("functions/v1/\(function)")
        var request = try Self.request(to: endpoint, body: body)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, status) = try await send(request)
        if status == 200 { return data }

        let code = (try? JSONDecoder().decode(ErrorResponse.self, from: data))?.error
        switch (status, code) {
        case (401, _): throw RealtimeServiceError.unauthorised
        case (429, "daily_limit"): throw RealtimeServiceError.dailyLimit
        case (429, "busy"): throw RealtimeServiceError.busy
        case (502, _): throw RealtimeServiceError.upstream
        case (503, "not_configured"): throw RealtimeServiceError.notConfigured
        case (503, _): throw RealtimeServiceError.unavailable
        default: throw RealtimeServiceError.unexpectedResponse
        }
    }

    private static func request(to url: URL, body: [String: String]) throws -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(SupabaseConfiguration.publishableKey, forHTTPHeaderField: "apikey")
        request.httpBody = try JSONEncoder().encode(body)
        return request
    }

    private static func sendRequest(_ request: URLRequest) async throws -> (Data, Int) {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse else { throw RealtimeServiceError.unexpectedResponse }
        return (data, response.statusCode)
    }
}
