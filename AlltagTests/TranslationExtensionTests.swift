//
//  TranslationExtensionTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

@Suite("Translation extension")
@MainActor
struct TranslationExtensionTests {
    @Test("German source shows the meaning, with sections arriving later")
    func direction() async throws {
        let model = TranslationPanelModel(stream: { _, receive in
            func emit(_ delta: String) throws {
                let data = try JSONSerialization.data(withJSONObject: ["type": "response.output_text.delta", "delta": delta])
                try receive("data: " + (String(data: data, encoding: .utf8) ?? ""))
            }
            try emit(#"{"german":"Guten Tag","other":"Good day","source_is_german":true,"#)
            try emit(#""note":"","words":[],"tones":[],"examples":[]}"#)
            try receive(#"data: {"type":"response.completed"}"#)
        })
        await model.translate("Guten Tag")
        #expect(model.translation == "Good day")
        #expect(!model.failed)
        #expect(!model.isLoading)
    }

    @Test("A broken connection produces a retry state")
    func failedStream() async {
        let model = TranslationPanelModel(stream: { _, _ in throw URLError(.notConnectedToInternet) })
        await model.translate("hello")
        #expect(model.failed)
        #expect(!model.isLoading)
        #expect(model.result == nil)
    }

    @Test("Saved extension text reaches Memory once, without moving the app store")
    func memoryImport() throws {
        let directory = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let entry = TranslationInbox.Entry(german: "die Frist", meaning: "deadline")
        try TranslationInbox.save(entry, to: directory)
        let container = try AlltagStore.makeContainer(inMemory: true)
        try TranslationInbox.importSaved(into: container.mainContext, from: directory)
        // Simulate a retry after a database save but before deleting the shared file.
        try TranslationInbox.save(entry, to: directory)
        try TranslationInbox.importSaved(into: container.mainContext, from: directory)
        let items = try container.mainContext.fetch(FetchDescriptor<MemoryItem>())
        #expect(items.count == 1)
        #expect(items.first?.word == "die Frist")
        #expect(items.first?.meaning == "deadline")
        #expect(items.first?.kind == .saved)
        #expect(items.first?.source == .translate)
        #expect(try FileManager.default.contentsOfDirectory(atPath: directory.path).isEmpty)
    }
}
