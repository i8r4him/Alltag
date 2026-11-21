//
//  SmartTyping.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 21.11.26.
//

import CoreGraphics
import Foundation

/// The keyboard's memory of the word being typed: where the finger landed for each letter,
/// which word was most likely meant, and which word tends to come next.
///
/// Everything happens on the iPhone. What it learns is kept in the keyboard's own container.
final class SmartTyping {
    /// The dictionary; without one nothing is corrected or learnt.
    var checker: WordChecking?
    var words = NextWords()
    /// Where the learnt words are kept; setting it loads them.
    var store: LearntWordsStore? {
        didSet {
            if let store { words.learnt = store.load() }
        }
    }

    /// The letters typed since the last word ended, with their touches.
    private var trace: [TypedLetter] = []
    private var centres = KeyCentres.standard
    /// The last correction and the text up to and with the word it put in.
    private var last: (correction: Correction, context: String)?
    /// The last word looked at and what was found for it: the space after it asks again.
    private var remembered: Remembered?
    private var unsaved = 0

    private struct Remembered {
        var letters: [TypedLetter]
        var previous: String
        var correction: Correction?
    }

    /// The keys as they lie now: touches are measured against them.
    func look(at geometry: KeyboardGeometry) {
        guard geometry.size != centres.size else { return }
        let seen = KeyCentres(geometry)
        if !seen.isEmpty { centres = seen }
    }

    // MARK: - The word being typed

    func typed(_ text: String, at point: CGPoint?) {
        guard text.count == 1, let letter = text.first, letter.isLetter else {
            trace = []
            return
        }
        trace.append(TypedLetter(text: letter, point: point))
        if trace.count > 40 { trace.removeFirst(trace.count - 40) }
    }

    /// A letter was deleted.
    func deleted() {
        if !trace.isEmpty { trace.removeLast() }
        last = nil
    }

    func endWord() {
        trace = []
    }

    /// Something else was typed: the last correction can no longer be taken back.
    func moveOn() {
        last = nil
    }

    /// The text changed in another way: a chosen word, an emoji, a tool's answer.
    func reset() {
        trace = []
        last = nil
    }

    /// The letters of a word with the touches that typed them, as far as the keyboard saw them.
    func letters(of word: String) -> [TypedLetter] {
        let characters = Array(word)
        let tail = Array(trace.suffix(characters.count))
        let isSeen = tail.count == characters.count
            && zip(tail, characters).allSatisfy { String($0.text).lowercased() == String($1).lowercased() }
        return characters.enumerated().map { index, character in
            TypedLetter(text: character, point: isSeen ? tail[index].point : nil)
        }
    }

    // MARK: - Corrections

    /// The word a mistyped one was most likely meant to be; nil for a word that is fine as it is.
    func correction(of word: String, after previous: String) -> Correction? {
        guard let checker, !words.keeps(word), !GermanWords.chat.contains(word.lowercased()) else { return nil }
        let typed = letters(of: word)
        if let remembered, remembered.letters == typed, remembered.previous == previous { return remembered.correction }
        var corrector = AutoCorrector(centres: centres, checker: checker)
        corrector.isCommon = { GermanWords.common.contains($0) }
        corrector.fits = { [words] in words.follows(previous, $0) }
        let found = corrector.correction(of: typed)
        remembered = Remembered(letters: typed, previous: previous, correction: found)
        return found
    }

    /// A correction went in. `context` is the text up to and with the new word.
    func applied(_ correction: Correction, context: String) {
        last = (correction, context)
    }

    /// Delete right after a correction takes it back: the text to remove and the word to put there.
    /// The learner wanted that word, so it is never changed again.
    func takeBack(from context: String) -> (old: String, typed: String)? {
        guard let last, context.count == last.context.count + 1, context.hasPrefix(last.context),
              let end = context.last else { return nil }
        self.last = nil
        keep(last.correction.typed)
        return (last.correction.replacement + String(end), last.correction.typed)
    }

    /// The learner wants this word as typed.
    func keep(_ word: String) {
        words.keep(word)
        remembered = nil
        changed()
    }

    // MARK: - The next word

    /// A word was finished after `previous`: the pair is learnt, if the word is a real one.
    func learn(_ word: String, after previous: String) {
        guard !previous.isEmpty, isReal(word) else { return }
        words.learn(word, after: previous)
        changed()
    }

    func predictions(after previous: String) -> [String] {
        words.after(previous)
    }

    private func isReal(_ word: String) -> Bool {
        if words.keeps(word) || GermanWords.chat.contains(word.lowercased()) { return true }
        guard let checker, word.allSatisfy(\.isLetter) else { return false }
        return checker.isWord(word) || checker.isWord(word.lowercased()) || checker.isForeignWord(word)
    }

    // MARK: - Keeping

    private func changed() {
        unsaved += 1
        if unsaved >= 20 { save() }
    }

    /// Writes what was learnt; the keyboard calls it when it goes away.
    func save() {
        guard unsaved > 0 else { return }
        store?.save(words.learnt)
        unsaved = 0
    }

    /// Forgets everything the keyboard learnt from the learner.
    func forget() {
        words.learnt = LearntWords()
        remembered = nil
        unsaved = 0
        store?.save(words.learnt)
    }

    // MARK: - Reading the text

    /// The word before the one being typed, if both are in one sentence; empty at a sentence's start.
    static func previousWord(in text: String) -> String {
        var rest = Substring(text)
        while rest.last == " " { rest.removeLast() }
        guard let end = rest.last, end.isLetter else { return "" }
        return TypingEngine.currentWord(in: String(rest))
    }

    /// Whether a word stands by itself, and not at the end of an address, a number or a hyphenated name.
    static func standsAlone(_ word: String, in text: String) -> Bool {
        guard let before = text.dropLast(word.count).last else { return true }
        return before.isWhitespace || "(„“\"«»‚‘[".contains(before)
    }
}
