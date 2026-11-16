//
//  TranslationStreamTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Translation streaming")
struct TranslationStreamTests {
    @Test("Completed sections appear as the response arrives")
    func sections() throws {
        var stream = TranslationStream()
        func event(_ delta: String) throws -> String {
            let data = try JSONSerialization.data(withJSONObject: ["type": "response.output_text.delta", "delta": delta])
            return "data: " + (String(data: data, encoding: .utf8) ?? "")
        }
        #expect(try stream.receive(event(#"{"german":"Guten Tag","other":"Good day","source_is_german":false,"#))?.german == "Guten Tag")
        let result = try stream.receive(event(#""note":"","words":[{"word":"der Tag","grammar":"noun","meaning":"day"}],"#))
        #expect(result?.words.first?.word == "der Tag")
        _ = try stream.receive(event(#""tones":[],"examples":[]}"#))
        _ = try stream.receive(#"data: {"type":"response.completed"}"#)
        #expect(try stream.finish().german == "Guten Tag")
    }

    @Test("An incomplete stream is an error")
    func incomplete() throws {
        var stream = TranslationStream()
        _ = try stream.receive(#"data: {"type":"response.output_text.delta","delta":"{"}"#)
        #expect(throws: RealtimeServiceError.self) { try stream.finish() }
    }
}
