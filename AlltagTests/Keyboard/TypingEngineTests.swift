//
//  TypingEngineTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Typing: capitals, spaces, deleting and chosen words")
@MainActor
struct TypingEngineTests {
    let document = FakeDocument()

    func type(_ text: String, with engine: inout TypingEngine) {
        for character in text {
            if character == " " {
                engine.space(in: document)
            } else {
                engine.typeCharacter(String(character), in: document)
            }
        }
    }

    @Test("A sentence starts with a capital, and only its first letter")
    func firstLetter() {
        var engine = TypingEngine()
        engine.sync(with: document)
        #expect(engine.shift == .once)
        type("hi", with: &engine)
        #expect(document.before == "Hi")
        #expect(engine.shift == .off)
    }

    @Test("After a full stop the next word starts with a capital; after a comma it doesn't")
    func nextSentence() {
        var engine = TypingEngine()
        engine.sync(with: document)
        type("ja. gut, danke", with: &engine)
        #expect(document.before == "Ja. Gut, danke")
    }

    @Test("A field that still says the old text right after a key isn't believed; a while later it is")
    func lateAnswer() {
        var engine = TypingEngine()
        engine.sync(with: document)
        engine.typeCharacter("h", in: document)
        #expect(engine.shift == .off)
        let stale = FakeDocument()
        engine.sync(with: stale)
        #expect(engine.context == "H")
        #expect(engine.shift == .off)
        // Later the app has really cleared the field: a new sentence starts.
        engine.sync(with: stale, at: Date.now.addingTimeInterval(1))
        #expect(engine.context.isEmpty)
        #expect(engine.shift == .once)
    }

    @Test("An emoji goes in as it is")
    func emoji() {
        var engine = TypingEngine()
        document.before = "Bis morgen "
        engine.insert("👋", in: document)
        #expect(document.before == "Bis morgen 👋")
        #expect(engine.context == "Bis morgen 👋")
    }

    @Test("A new line starts with a capital")
    func newLine() {
        var engine = TypingEngine()
        document.before = "Hallo"
        engine.enter(in: document)
        #expect(document.before == "Hallo\n")
        #expect(engine.shift == .once)
    }

    @Test("A second space after a word ends the sentence")
    func doubleSpace() {
        var engine = TypingEngine()
        engine.sync(with: document)
        type("hallo  ", with: &engine)
        #expect(document.before == "Hallo. ")
        #expect(engine.shift == .once)
        engine.space(in: document)
        #expect(document.before == "Hallo.  ")
    }

    @Test("A chosen word takes the place of the typed one; punctuation closes up to it")
    func chosenWord() {
        var engine = TypingEngine()
        document.before = "Ich gehe nach Hau"
        engine.apply("Hause", in: document)
        #expect(document.before == "Ich gehe nach Hause ")
        engine.typeCharacter(".", in: document)
        #expect(document.before == "Ich gehe nach Hause.")
        engine.space(in: document)
        #expect(document.before == "Ich gehe nach Hause. ")
        #expect(engine.shift == .once)
    }

    @Test("A space after a chosen word isn't doubled or turned into a full stop")
    func spaceAfterChosenWord() {
        var engine = TypingEngine()
        document.before = "Gute Nach"
        engine.apply("Nacht", in: document)
        engine.space(in: document)
        #expect(document.before == "Gute Nacht ")
        engine.typeCharacter("u", in: document)
        #expect(document.before == "Gute Nacht u")
    }

    @Test("Delete takes a letter, and a whole word when held")
    func deleting() {
        var engine = TypingEngine()
        document.before = "Guten Morgen"
        engine.delete(in: document)
        #expect(document.before == "Guten Morge")
        engine.deleteWord(in: document)
        #expect(document.before == "Guten ")
        engine.deleteWord(in: document)
        #expect(document.before.isEmpty)
        #expect(engine.shift == .once)
    }

    @Test("Two taps on Shift lock it until the next tap")
    func capsLock() {
        var engine = TypingEngine()
        engine.capitalisation = .none
        engine.tapShift(again: false)
        #expect(engine.shift == .once)
        engine.tapShift(again: true)
        #expect(engine.shift == .locked)
        type("abß", with: &engine)
        #expect(document.before == "ABẞ")
        #expect(engine.shift == .locked)
        engine.tapShift(again: false)
        #expect(engine.shift == .off)
    }

    @Test("A slow second tap on Shift switches it off again")
    func shiftOff() {
        var engine = TypingEngine()
        engine.capitalisation = .none
        engine.tapShift(again: false)
        engine.tapShift(again: false)
        #expect(engine.shift == .off)
    }

    @Test("The text field decides about capitals",
          arguments: [(AutoCapitalisation.none, "", false), (.sentences, "", true), (.sentences, "Ja", false),
                      (.sentences, "Ja? ", true), (.sentences, "z. B. ", true), (.sentences, "eins, ", false),
                      (.words, "Anna ", true), (.words, "Ann", false), (.allCharacters, "AB", true)])
    func capitals(mode: AutoCapitalisation, context: String, expected: Bool) {
        #expect(TypingEngine.capitalises(after: context, mode: mode) == expected)
    }

    @Test("The word at the cursor is its letters back to the last space",
          arguments: [("Ich geh", "geh"), ("Ich ", ""), ("", ""), ("Wie geht's", "geht's"), ("E-Mail", "Mail"), ("Straße", "Straße")])
    func currentWord(context: String, expected: String) {
        #expect(TypingEngine.currentWord(in: context) == expected)
    }

    @Test("Suggestions: corrections first, never the typed word, never twice")
    func picking() {
        #expect(SuggestionPicker.pick(typed: "hau", guesses: [], completions: ["haus", "haut", "haube", "hauch"])
                == ["haus", "haut", "haube"])
        #expect(SuggestionPicker.pick(typed: "hasue", guesses: ["hause", "hasse", "hast"], completions: ["hasuen"])
                == ["hause", "hasse", "hasuen"])
        #expect(SuggestionPicker.pick(typed: "Haus", guesses: [], completions: ["Haus", "Hause", "Hause"]) == ["Hause"])
    }

    @Test("A word typed with a capital keeps it in the suggestions")
    func nounCapital() {
        #expect(SuggestionPicker.pick(typed: "Schul", guesses: [], completions: ["schule", "schulen"]) == ["Schule", "Schulen"])
        #expect(SuggestionPicker.pick(typed: "schul", guesses: [], completions: ["Schule"]) == ["Schule"])
    }
}
