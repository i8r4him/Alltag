//
//  SmartTypingTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 21.11.26.
//

import CoreGraphics
import Foundation
import Testing
@testable import Alltag

/// Keeps the learnt words in memory.
@MainActor
final class MemoryWordsStore: LearntWordsStore {
    var kept = LearntWords()

    func load() -> LearntWords { kept }

    func save(_ words: LearntWords) {
        kept = words
    }
}

/// Corrections and the next word, typed through the same calls the touch layer makes.
@Suite("Smart typing")
@MainActor
struct SmartTypingTests {
    let document = FakeDocument()
    let model = KeyboardModel()
    let size = CGSize(width: 440, height: 271)

    init() {
        model.document = document
        model.smart.checker = FixedDictionary("nicht ich bin wir gehen guten Morgen für der des")
        model.documentChanged(KeyboardTraits(capitalisation: .none))
    }

    var geometry: KeyboardGeometry { KeyboardGeometry(rows: model.rows, size: size) }

    func centre(of key: KeyboardKey) throws -> CGPoint {
        let frame = try #require(geometry.frame(of: key)).frame
        return CGPoint(x: frame.midX, y: frame.midY)
    }

    /// Taps the keys of a text in their middle, one finger after the other.
    func tap(_ text: String) throws {
        for character in text {
            let key: KeyboardKey = character == " " ? .space : .character(String(character))
            try model.touchDown(1, at: centre(of: key), in: geometry)
            model.touchUp(1)
        }
    }

    func tapDelete() throws {
        try model.touchDown(1, at: centre(of: .delete), in: geometry)
        model.touchUp(1)
    }

    @Test("A mistyped word shows what it will become, and the space puts it in")
    func space() throws {
        try tap("nichr")
        #expect(document.before == "nichr")
        model.refreshSuggestions()
        #expect(model.correction == Correction(typed: "nichr", replacement: "nicht"))
        try tap(" ")
        #expect(document.before == "nicht ")
        #expect(model.correction == nil)
    }

    @Test("Delete right after a correction brings the typed word back, and it is never changed again")
    func takeBack() throws {
        try tap("ich nichr ")
        #expect(document.before == "ich nicht ")
        try tapDelete()
        #expect(document.before == "ich nichr")
        try tap(" nichr ")
        #expect(document.before == "ich nichr nichr ")
    }

    @Test("After another key, delete only deletes")
    func noTakeBack() throws {
        try tap("nichr i")
        try tapDelete()
        try tapDelete()
        #expect(document.before == "nicht")
    }

    @Test("A tap on the typed word in the words row keeps it")
    func keepTyped() throws {
        try tap("nichr")
        model.refreshSuggestions()
        model.keepTyped()
        #expect(document.before == "nichr ")
        try tap("nichr ")
        #expect(document.before == "nichr nichr ")
    }

    @Test("A full stop ends a word like a space")
    func fullStop() throws {
        try tap("nichr")
        model.activate(.character("."))
        #expect(document.before == "nicht.")
    }

    @Test("Where the finger landed decides which word it becomes")
    func touch() throws {
        try tap("de")
        let own = try centre(of: .character("e"))
        let other = try centre(of: .character("s"))
        let point = CGPoint(x: own.x + (other.x - own.x) * 0.45, y: own.y + (other.y - own.y) * 0.45)
        // Low and left on e, towards s, but still e's touch.
        #expect(geometry.key(at: point)?.key == .character("e"))
        model.touchDown(1, at: point, in: geometry)
        model.touchUp(1)
        try tap(" de")
        try tap("e ")
        #expect(document.before == "des der ")
    }

    @Test("Two words run together are split, and a left-out umlaut is put in")
    func splitAndUmlaut() throws {
        try tap("ichbin fur ")
        #expect(document.before == "ich bin für ")
    }

    @Test("Without auto-correction the word stays as typed")
    func switchedOff() throws {
        model.set(.autoCorrection, to: false)
        try tap("nichr")
        model.refreshSuggestions()
        #expect(model.correction == nil)
        try tap(" ")
        #expect(document.before == "nichr ")
    }

    @Test("Nothing is corrected in an address, inside a word, or where the text field wants no words")
    func leftAlone() throws {
        model.activate(.character("@"))
        try tap("nichr ")
        #expect(document.before == "@nichr ")

        document.before = ""
        model.documentChanged(KeyboardTraits(capitalisation: .none))
        try tap("nichr")
        document.after = "en"
        try tap(" ")
        #expect(document.before == "nichr ")

        document.before = ""
        document.after = ""
        model.documentChanged(KeyboardTraits(capitalisation: .none, offersSuggestions: false))
        try tap("nichr ")
        #expect(document.before == "nichr ")
    }

    @Test("After a word the next one is offered, and a tap types it")
    func nextWord() throws {
        model.smart.words.seed = ["guten": ["Morgen", "Tag"]]
        try tap("guten ")
        #expect(model.suggestions == ["Morgen", "Tag"])
        model.choose("Morgen")
        #expect(document.before == "guten Morgen ")
        #expect(model.suggestions.isEmpty)
    }

    @Test("The keyboard learns which word the learner writes after which, and can forget it")
    func learns() throws {
        let store = MemoryWordsStore()
        model.smart.store = store
        try tap("wir gehen ")
        #expect(model.suggestions.isEmpty)
        try tap("wir ")
        #expect(model.suggestions == ["gehen"])
        // A mistyped word is learnt as what it became, and a word no dictionary knows not at all.
        try tap("nichr xqx ")
        #expect(model.smart.words.learnt.pairs["wir"] == ["gehen": 1, "nicht": 1])
        #expect(model.smart.words.learnt.pairs["nicht"] == nil)
        model.smart.save()
        #expect(store.kept.pairs["wir"]?["gehen"] == 1)
        model.forgetLearntWords()
        #expect(store.kept == LearntWords())
        #expect(model.suggestions.isEmpty)
    }

    @Test("Without word suggestions nothing is offered and nothing is learnt")
    func noSuggestions() throws {
        model.smart.words.seed = ["guten": ["Morgen"]]
        model.set(.suggestions, to: false)
        try tap("guten wir gehen ")
        #expect(model.suggestions.isEmpty)
        #expect(model.smart.words.learnt == LearntWords())
    }

    @Test("The learner's own pairs come first, then the common ones, then what was written once")
    func order() {
        var words = NextWords(seed: ["ich": ["bin", "habe"]])
        words.learn("gehe", after: "Ich")
        words.learn("komme", after: "ich")
        words.learn("komme", after: "ich")
        words.learn("bin", after: "ich")
        #expect(words.after("ich") == ["komme", "bin", "habe"])
        #expect(words.after("ich", limit: 5) == ["komme", "bin", "habe", "gehe"])
        #expect(words.follows("ich", "Habe"))
        #expect(words.follows("ich", "komme"))
        #expect(!words.follows("ich", "gehe"))
        #expect(words.after("").isEmpty)
    }

    @Test("What is learnt stays small: the rarest pair goes first")
    func limits() {
        var words = NextWords()
        words.learn("oft", after: "sehr")
        words.learn("oft", after: "sehr")
        for index in 0..<NextWords.followerLimit { words.learn("wort\(index)", after: "sehr") }
        let followers = words.learnt.pairs["sehr"] ?? [:]
        #expect(followers.count == NextWords.followerLimit)
        #expect(followers["oft"] == 2)
        words.keep("Nichr")
        #expect(words.keeps("nichr"))
    }

    @Test("The learnt words are kept in a file and read again")
    func file() throws {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("words-\(UUID().uuidString)/words.json")
        defer { try? FileManager.default.removeItem(at: url.deletingLastPathComponent()) }
        let store = FileLearntWordsStore(url: url)
        #expect(store.load() == LearntWords())
        var words = NextWords()
        words.learn("gehen", after: "wir")
        words.keep("nichr")
        store.save(words.learnt)
        #expect(store.load() == words.learnt)
    }

    @Test("The word before, and whether a word stands by itself")
    func reading() {
        #expect(SmartTyping.previousWord(in: "Ich bin ") == "bin")
        #expect(SmartTyping.previousWord(in: "Ich bin. ").isEmpty)
        #expect(SmartTyping.previousWord(in: "Hallo,\n").isEmpty)
        #expect(SmartTyping.previousWord(in: "").isEmpty)
        #expect(SmartTyping.standsAlone("nichr", in: "ich nichr"))
        #expect(SmartTyping.standsAlone("nichr", in: "nichr"))
        #expect(SmartTyping.standsAlone("nichr", in: "(nichr"))
        #expect(!SmartTyping.standsAlone("de", in: "alltag.de"))
        #expect(!SmartTyping.standsAlone("Adresse", in: "E-Mail-Adresse"))
    }

    @Test("A correction types only the end of the word again")
    func engine() {
        var engine = TypingEngine()
        engine.capitalisation = .none
        let document = FakeDocument("ich nichr")
        engine.correct("nichr", to: "nicht", in: document)
        #expect(document.before == "ich nicht")
        #expect(engine.context == "ich nicht")
        engine.correct("nicht", to: "noch immer", in: document)
        #expect(document.before == "ich noch immer")
        // A word that isn't there is not corrected.
        engine.correct("nicht", to: "nie", in: document)
        #expect(document.before == "ich noch immer")
    }
}
