//
//  ReaderTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

/// Translates the words it knows, or throws the given error, and counts what it was asked.
private final class WordStub: TranslationService {
    var results: [String: TranslationResult] = [:]
    var error: (any Error)?
    private(set) var asked: [String] = []

    func translate(_ text: String) async throws -> TranslationResult? {
        asked.append(text)
        if let error { throw error }
        return results[text]
    }

    func explain(_ result: TranslationResult) async -> TranslationResult { result }
}

@MainActor
struct ReaderTests {
    private static let text = ReadingText(
        id: "test", title: "A test", detail: "A test", level: "A2", minutes: 1, systemImage: "doc",
        german: """
        Sehr geehrte Frau Becker,

        die Nebenkostenabrechnung ist da. Bitte zahlen Sie 75 Euro – danke!
        Ihre Hausverwaltung
        """)

    private static let abrechnung = TranslationResult(
        english: "service charge statement", german: "Nebenkostenabrechnung",
        words: [.init(word: "die Nebenkostenabrechnung", grammar: "noun · pl. Nebenkostenabrechnungen",
                      meaning: "service charge statement")],
        tones: [], note: "", examples: [.init(german: "Die Abrechnung ist falsch.", english: "The statement is wrong.")])

    private func reader(_ stub: WordStub = WordStub()) -> ReaderModel {
        stub.results["Nebenkostenabrechnung"] = Self.abrechnung
        return ReaderModel(text: Self.text)
    }

    private func word(_ written: String, in model: ReaderModel) throws -> ReadingWord {
        try #require(model.paragraphs.flatMap(\.words).first { $0.written == written })
    }

    private func waitForLookup(_ model: ReaderModel) async {
        while model.lookup == .loading { await Task.yield() }
    }

    @Test("A text splits into lines and words; numbers and dashes can't be tapped")
    func paragraphs() throws {
        let paragraphs = ReadingWords.paragraphs(of: Self.text.german)
        #expect(paragraphs.count == 3)
        #expect(paragraphs.map(\.startsBlock) == [false, true, false])
        let words = paragraphs.flatMap(\.words)
        #expect(words.map(\.id) == Array(words.indices))
        #expect(words.first { $0.written == "Becker," }?.word == "Becker")
        #expect(words.first { $0.written == "75" }?.isWord == false)
        #expect(words.first { $0.written == "–" }?.isWord == false)
        #expect(words.first { $0.written == "danke!" }?.word == "danke")
        #expect(ReadingWords.clean("„Mieter“,") == "Mieter")
        #expect(ReadingWords.clean("10:30") == "")
        #expect(ReadingWords.clean("Hamburg-Harburg.") == "Hamburg-Harburg")
    }

    @Test("Each word knows the sentence it is in")
    func sentences() throws {
        let words = ReadingWords.paragraphs(of: Self.text.german).flatMap(\.words)
        #expect(words.first { $0.written == "Nebenkostenabrechnung" }?.sentence == "die Nebenkostenabrechnung ist da.")
        #expect(words.first { $0.written == "zahlen" }?.sentence == "Bitte zahlen Sie 75 Euro – danke!")
    }

    @Test("The server's explanation gives the word with its article; Apple's translation only the meaning")
    func meaning() {
        let explained = ReadingMeaning(tapped: "Nebenkostenabrechnung", result: Self.abrechnung)
        #expect(explained.article == "die ")
        #expect(explained.word == "Nebenkostenabrechnung")
        #expect(explained.grammar == "noun · pl. Nebenkostenabrechnungen")
        #expect(explained.example?.german == "Die Abrechnung ist falsch.")

        let plain = ReadingMeaning(tapped: "zahlen", result: TranslationResult(
            english: "pay", german: "zahlen", words: [], tones: [], note: "", examples: []))
        #expect(plain.display == "zahlen")
        #expect(plain.meaning == "pay")
        #expect(ReadingMeaning.split("die").article.isEmpty)
    }

    @Test("A word is translated once; tapping it again closes it, and opening it again asks no one")
    func translatesOnce() async throws {
        let stub = WordStub()
        let model = reader(stub)
        let word = try word("Nebenkostenabrechnung", in: model)

        model.select(word, with: stub)
        #expect(model.lookup == .loading)
        await waitForLookup(model)
        #expect(model.meaning?.display == "die Nebenkostenabrechnung")

        model.select(word, with: stub)
        #expect(model.selected == nil)
        model.select(word, with: stub)
        #expect(model.meaning != nil)
        #expect(stub.asked == ["Nebenkostenabrechnung"])
    }

    @Test("Numbers can't be selected")
    func numbers() throws {
        let stub = WordStub()
        let model = reader(stub)
        model.select(try word("75", in: model), with: stub)
        #expect(model.selected == nil)
        #expect(stub.asked.isEmpty)
    }

    @Test("Offline shows why and tries again on request")
    func offline() async throws {
        let stub = WordStub()
        stub.error = URLError(.notConnectedToInternet)
        let model = reader(stub)
        model.select(try word("Nebenkostenabrechnung", in: model), with: stub)
        await waitForLookup(model)
        #expect(model.lookup == .failed(.offline))

        stub.error = nil
        model.retry(with: stub)
        await waitForLookup(model)
        #expect(model.meaning != nil)
        #expect(stub.asked.count == 2)
    }

    @Test("Missing languages ask for the download, then the word is translated")
    func download() async throws {
        let stub = WordStub()
        let german = Locale.Language(identifier: "de")
        let english = Locale.Language(identifier: "en")
        stub.error = TranslationServiceError.needsDownload(source: german, target: english)
        let model = reader(stub)
        model.select(try word("Nebenkostenabrechnung", in: model), with: stub)
        await waitForLookup(model)
        #expect(model.lookup == .needsDownload(source: german, target: english))

        stub.error = nil
        await model.languagesDownloaded()
        await waitForLookup(model)
        #expect(model.meaning != nil)
    }

    @Test("Saving keeps the word with its sentence and the text it came from, and can be undone")
    func save() async throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        let stub = WordStub()
        let model = reader(stub)
        model.select(try word("Nebenkostenabrechnung", in: model), with: stub)
        await waitForLookup(model)
        let meaning = try #require(model.meaning)

        model.toggleSave(in: container.mainContext)
        #expect(model.isSaved(meaning))
        let item = try #require(try container.mainContext.fetch(FetchDescriptor<MemoryItem>()).first)
        #expect(item.displayWord == "die Nebenkostenabrechnung")
        #expect(item.meaning == "service charge statement")
        #expect(item.context == "die Nebenkostenabrechnung ist da.")
        #expect(item.kind == .saved)
        #expect(item.source == .read)
        #expect(item.sourceDetail == "A test")

        model.toggleSave(in: container.mainContext)
        #expect(!model.isSaved(meaning))
        #expect(try container.mainContext.fetch(FetchDescriptor<MemoryItem>()).isEmpty)
    }

    @Test("A word saved earlier shows as saved")
    func savedEarlier() async throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        container.mainContext.insert(MemoryItem(article: "die ", word: "Nebenkostenabrechnung", meaning: "statement",
                                                kind: .saved, source: .translate))
        let stub = WordStub()
        let model = reader(stub)
        model.select(try word("Nebenkostenabrechnung", in: model), with: stub)
        await waitForLookup(model)
        model.refreshSaved(in: container.mainContext)
        #expect(model.isSaved(try #require(model.meaning)))
    }

    @Test("Listen reads the whole text aloud")
    func listen() async {
        let voice = MockVoiceService()
        let model = reader()
        await model.toggleListening(with: voice)
        #expect(voice.spoken.map { $0.text } == [Self.text.german])
        #expect(!model.isListening)
    }

    @Test("Every sample text has German to read and its own id")
    func samples() {
        let texts = MockReading.texts
        #expect(Set(texts.map(\.id)).count == texts.count)
        for text in texts {
            #expect(!ReadingWords.paragraphs(of: text.german).isEmpty)
            #expect(MockReading.text(id: text.id)?.german == text.german)
        }
    }
}
