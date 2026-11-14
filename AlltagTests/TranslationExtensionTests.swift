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

    @Test("A short phrase stays one block in the big style")
    func shortLayout() {
        let layout = TranslationLayout("Wo bist du?")
        #expect(!layout.isLong)
        #expect(layout.blocks == [.paragraph("Wo bist du?")])
    }

    @Test("A job advert becomes a heading, its facts and paragraphs")
    func advertLayout() {
        let advert = """
        Pflegefachkraft (m/w/d)
        Klinikum Nord · Hamburg
        ab 3.400 € brutto
        38,5 Stunden pro Woche

        Wir suchen eine erfahrene Pflegefachkraft für unsere Station. Sie arbeiten in einem freundlichen Team.
        - Unbefristeter Vertrag
        """
        let layout = TranslationLayout(advert)
        #expect(layout.isLong)
        #expect(layout.blocks == [
            .heading("Pflegefachkraft (m/w/d)"),
            .facts(["Klinikum Nord", "Hamburg", "ab 3.400 € brutto", "38,5 Stunden pro Woche"]),
            .paragraph("Wir suchen eine erfahrene Pflegefachkraft für unsere Station. Sie arbeiten in einem freundlichen Team."),
            .facts(["Unbefristeter Vertrag"])
        ])
    }

    @Test("A long block without line breaks is broken into paragraphs, losing nothing")
    func blockLayout() {
        let sentence = "Wir suchen eine erfahrene Pflegefachkraft für unsere Station in Hamburg."
        let text = Array(repeating: sentence, count: 6).joined(separator: " ")
        let layout = TranslationLayout(text)
        #expect(layout.isLong)
        #expect(layout.blocks.count > 1)
        let joined = layout.blocks.map { block -> String in
            if case .paragraph(let paragraph) = block { paragraph } else { "" }
        }.joined(separator: " ")
        #expect(joined == text)
    }

    @Test("A saved entry can be taken out of the inbox again")
    func removeFromInbox() throws {
        let directory = FileManager.default.temporaryDirectory.appending(path: UUID().uuidString, directoryHint: .isDirectory)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let entry = TranslationInbox.Entry(german: "die Kündigungsfrist", meaning: "notice period")
        try TranslationInbox.save(entry, to: directory)
        #expect(try FileManager.default.contentsOfDirectory(atPath: directory.path).count == 1)
        try TranslationInbox.remove(entry.id, from: directory)
        #expect(try FileManager.default.contentsOfDirectory(atPath: directory.path).isEmpty)
        // Already imported by the app: nothing to remove, and no error.
        try TranslationInbox.remove(entry.id, from: directory)
    }
}
