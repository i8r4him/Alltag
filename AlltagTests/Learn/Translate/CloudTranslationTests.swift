//
//  CloudTranslationTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import Foundation
import Testing
@testable import Alltag

@MainActor
struct CloudTranslationTests {
    private let answer = Data("""
        {"german": "Wo ist die nächste Apotheke?", "other": "Where is the nearest pharmacy?", "source_is_german": false,
         "note": "A neutral way to ask.",
         "words": [{"word": "die Apotheke", "grammar": "noun · pl. Apotheken", "meaning": "pharmacy"}],
         "tones": [{"tone": "formal", "german": "Könnten Sie mir sagen, wo die nächste Apotheke ist?"},
                   {"tone": "casual", "german": "Wo ist hier eine Apotheke?"}, {"tone": "odd", "german": "?"}],
         "examples": [{"german": "Die Apotheke ist geschlossen.", "other": "The pharmacy is closed."}]}
        """.utf8)

    @Test("Streaming delivers the translation before the explanation")
    func streamsSections() async throws {
        var updates: [TranslationResult] = []
        let service = CloudTranslationService(isAllowed: { true }, stream: { body, receive in
            #expect(body["stream"] == "true")
            func send(_ delta: String) throws {
                let data = try JSONSerialization.data(withJSONObject: ["type": "response.output_text.delta", "delta": delta])
                try receive("data: " + (String(data: data, encoding: .utf8) ?? ""))
            }
            try send(#"{"german":"Guten Tag","other":"Good day","source_is_german":false,"#)
            try send(#""note":"","words":[{"word":"der Tag","grammar":"noun","meaning":"day"}],"#)
            try send(#""tones":[],"examples":[]}"#)
            try receive(#"data: {"type":"response.completed"}"#)
        })
        let result = try await service.translate("Good day") { updates.append($0) }
        #expect(updates.first?.german == "Guten Tag")
        #expect(updates.first?.words.isEmpty == true)
        #expect(updates.last?.words.first?.word == "der Tag")
        #expect(result?.words.first?.word == "der Tag")
    }

    @Test("The register goes to the server only when one is chosen", arguments: [GermanRegister?.none, .everyday, .formal])
    func sendsRegister(register: GermanRegister?) async throws {
        var sent: [String: String] = [:]
        let service = CloudTranslationService(isAllowed: { true }, stream: { body, receive in
            sent = body
            let delta = #"{"german":"Hallo","other":"Hello","source_is_german":false,"note":"","words":[],"tones":[],"examples":[]}"#
            let data = try JSONSerialization.data(withJSONObject: ["type": "response.output_text.delta", "delta": delta])
            try receive("data: " + (String(data: data, encoding: .utf8) ?? ""))
            try receive(#"data: {"type":"response.completed"}"#)
        })
        _ = try await service.translate("Hello", register: register) { _ in }
        #expect(sent["register"] == register?.rawValue)
        #expect(sent["stream"] == "true")
    }

    @Test("Streaming without cloud permission does not use Apple Translation")
    func streamingNeedsConsent() async {
        let service = CloudTranslationService(isAllowed: { false }, stream: { _, _ in
            Issue.record("Cloud request must not run without permission")
        })
        await #expect(throws: RealtimeServiceError.self) {
            try await service.translate("Good day") { _ in }
        }
    }

    @Test("With cloud use allowed, the server translates and explains in one answer")
    func serverTranslates() async throws {
        var sent: [[String: String]] = []
        let service = makeService { body in
            sent.append(body)
            return answer
        }

        let result = try #require(try await service.translate("where is the nearest pharmacy"))

        #expect(result.german == "Wo ist die nächste Apotheke?")
        #expect(result.english == "Where is the nearest pharmacy?")
        #expect(result.words.map(\.word) == ["die Apotheke"])
        // A register the app doesn't know is left out.
        #expect(result.tones.map(\.tone) == [.formal, .casual])
        #expect(result.examples.first?.english == "The pharmacy is closed.")
        #expect(result.isExplained)
        #expect(sent.first?["text"] == "where is the nearest pharmacy")
        #expect(sent.first?["language"]?.isEmpty == false)
        // Already explained: nothing more to ask for.
        #expect(await service.explain(result) == result)
    }

    @Test("When the server fails, the on-device service translates", arguments: [
        RealtimeServiceError.upstream, .dailyLimit, .busy, .unavailable
    ])
    func fallsBack(error: RealtimeServiceError) async throws {
        let service = makeService { _ in throw error }

        // The on-device stand-in only knows the prototype's samples; anything else is nil.
        let sample = try #require(MockTranslations.all.first)
        #expect(try await service.translate(sample.english) == sample)
        #expect(try await service.translate("something it has never seen") == nil)
    }

    @Test("Without the learner's permission nothing is sent to the server")
    func notAllowed() async throws {
        var calls = 0
        let service = makeService(allowed: false) { _ in
            calls += 1
            return answer
        }

        _ = try await service.translate("where is the nearest pharmacy")

        #expect(calls == 0)
    }

    private func makeService(allowed: Bool = true, send: @escaping CloudTranslationService.Send) -> CloudTranslationService {
        CloudTranslationService(onDevice: MockTranslationService(delay: .zero), isAllowed: { allowed }, send: send)
    }
}
