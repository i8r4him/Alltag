//
//  TypingEngine.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import Foundation

/// The text field the keyboard types into: only what typing needs, so tests can stand in for it.
protocol TextDocument: AnyObject {
    /// The text before the cursor, as far as the app shares it.
    var textBeforeCursor: String { get }
    func insert(_ text: String)
    func deleteBackward()
    func moveCursor(by offset: Int)
}

enum ShiftState: Equatable {
    case off
    /// A capital for the next letter only.
    case once
    /// Caps Lock.
    case locked

    var isOn: Bool { self != .off }
}

/// When the keyboard puts a capital by itself; the text field says which.
enum AutoCapitalisation: Equatable {
    case none
    case words
    case sentences
    case allCharacters
}

/// What a key press does to the text and to Shift.
///
/// It works out the text after each step itself instead of asking the text
/// field again, because the field can answer late.
struct TypingEngine {
    private(set) var shift: ShiftState = .off
    /// The text before the cursor as the engine last knew it.
    private(set) var context = ""
    var capitalisation: AutoCapitalisation = .sentences
    /// A space the keyboard added after a chosen word: punctuation typed next takes its place.
    private var addedSpace = false

    /// Types a character key's text, as a capital when Shift is on.
    mutating func typeCharacter(_ text: String, in document: TextDocument) {
        let before = document.textBeforeCursor
        let typed = shift.isOn ? Self.capital(text) : text
        if addedSpace, before.hasSuffix(" "), typed.count == 1, ".,?!:;".contains(typed) {
            document.deleteBackward()
            document.insert(typed)
            settle(after: String(before.dropLast()) + typed)
        } else {
            document.insert(typed)
            settle(after: before + typed)
        }
    }

    /// A space; a second one after a word ends the sentence with a full stop.
    mutating func space(in document: TextDocument) {
        let before = document.textBeforeCursor
        if addedSpace, before.hasSuffix(" ") {
            // The space is there already.
            settle(after: before)
        } else if Self.endsSentence(before) {
            document.deleteBackward()
            document.insert(". ")
            settle(after: String(before.dropLast()) + ". ")
        } else {
            document.insert(" ")
            settle(after: before + " ")
        }
    }

    mutating func enter(in document: TextDocument) {
        let before = document.textBeforeCursor
        document.insert("\n")
        settle(after: before + "\n")
    }

    mutating func delete(in document: TextDocument) {
        let before = document.textBeforeCursor
        document.deleteBackward()
        settle(after: String(before.dropLast()))
    }

    /// Deletes back to the start of the last word, as holding delete does after a while.
    mutating func deleteWord(in document: TextDocument) {
        let before = document.textBeforeCursor
        let count = max(Self.lengthOfLastWord(in: before), 1)
        for _ in 0..<count { document.deleteBackward() }
        settle(after: String(before.dropLast(count)))
    }

    /// Puts a suggested word in place of the one being typed, with a space after it.
    mutating func apply(_ suggestion: String, in document: TextDocument) {
        let before = document.textBeforeCursor
        let word = Self.currentWord(in: before)
        for _ in 0..<word.count { document.deleteBackward() }
        document.insert(suggestion + " ")
        settle(after: String(before.dropLast(word.count)) + suggestion + " ")
        addedSpace = true
    }

    /// A tap on Shift. `again` is a second tap right after the first, which locks it.
    mutating func tapShift(again: Bool) {
        switch shift {
        case .off: shift = .once
        case .once: shift = again ? .locked : .off
        case .locked: shift = .off
        }
    }

    /// The text changed without the keyboard (the cursor moved, the app cleared the field).
    mutating func sync(with document: TextDocument) {
        let now = document.textBeforeCursor
        if !now.hasSuffix(" ") { addedSpace = false }
        context = now
        updateShift()
    }

    private mutating func settle(after text: String) {
        addedSpace = false
        context = text
        updateShift()
    }

    private mutating func updateShift() {
        guard shift != .locked else { return }
        shift = Self.capitalises(after: context, mode: capitalisation) ? .once : .off
    }
}

// MARK: - Rules

extension TypingEngine {
    /// Whether the next letter starts with a capital.
    static func capitalises(after context: String, mode: AutoCapitalisation) -> Bool {
        switch mode {
        case .none:
            return false
        case .allCharacters:
            return true
        case .words:
            return context.last?.isWhitespace ?? true
        case .sentences:
            guard let last = context.last else { return true }
            guard last.isWhitespace else { return false }
            if last.isNewline { return true }
            guard let end = context.last(where: { !$0.isWhitespace }) else { return true }
            return ".!?".contains(end)
        }
    }

    /// A space after "word " makes it "word. ".
    static func endsSentence(_ context: String) -> Bool {
        guard context.hasSuffix(" "), let last = context.dropLast().last else { return false }
        return last.isLetter || last.isNumber || ")\"“’".contains(last)
    }

    /// The letters of the word the cursor is at the end of.
    static func currentWord(in context: String) -> String {
        String(context.reversed().prefix(while: { $0.isLetter || $0 == "'" || $0 == "’" }).reversed())
    }

    /// The last word and the spaces after it, counted in characters.
    static func lengthOfLastWord(in context: String) -> Int {
        var count = 0
        var inWord = false
        for character in context.reversed() {
            if character.isNewline { break }
            if character.isWhitespace {
                if inWord { break }
            } else {
                inWord = true
            }
            count += 1
        }
        return count
    }

    /// The capital of a key's text. German has its own capital ß.
    static func capital(_ text: String) -> String {
        text == "ß" ? "ẞ" : text.uppercased()
    }
}
