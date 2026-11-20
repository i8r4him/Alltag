//
//  KeyboardAssistant.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 21.11.26.
//

import Foundation

/// What Fix found in the text before the cursor.
struct KeyboardFix: Equatable {
    /// The text as it was typed.
    var original: String
    /// The same text as it should read.
    var corrected: String
    /// Why, one line per sentence that changed.
    var reasons: [String] = []

    /// Nothing had to change.
    var isClean: Bool {
        Self.plain(corrected) == Self.plain(original)
    }

    private static func plain(_ text: String) -> String {
        text.split(whereSeparator: \.isWhitespace).joined(separator: " ")
    }
}

/// How the German of "How do I say …?" should sound.
enum KeyboardRegister: String, CaseIterable, Equatable {
    case everyday
    case formal
}

/// What "How do I say …?" answers.
struct KeyboardAnswer: Equatable {
    /// What the learner typed, in any language.
    var asked: String
    var german: String
    /// One line on when this German fits; may be empty.
    var note = ""
}

/// A noun with its article, as der · die · das shows it.
struct KeyboardNoun: Equatable {
    var article: String
    var word: String
    /// Empty when the noun has no everyday plural.
    var plural = ""
    var meaning: String
    /// Why it has this article, or that it has to be learnt with it.
    var explanation = ""

    var withArticle: String { "\(article) \(word)" }
}

/// The tools' helper. The keyboard asks it only when a tool is tapped;
/// nothing that is typed leaves the iPhone before that.
protocol KeyboardAssistant {
    func fix(_ text: String) async throws -> KeyboardFix
    func say(_ text: String, register: KeyboardRegister) async throws -> KeyboardAnswer
    /// The nouns a word can be, one per meaning with its own article; none when it isn't a noun.
    func nouns(for word: String) async throws -> [KeyboardNoun]
}

/// Asks Alltag's server: `write` corrects written German, `translate` says it in German,
/// `articles` knows a noun's article.
struct ServerKeyboardAssistant: KeyboardAssistant {
    typealias Send = (_ function: String, _ body: [String: String]) async throws -> Data

    /// The learner's own language, for the notes.
    var language = "English"
    var send: Send = { try await SupabaseRealtimeClient.shared.post(to: $0, body: $1) }

    private struct Check: Decodable {
        struct Sentence: Decodable {
            let kind: String
            let title: String
            let note: String
        }

        let sentences: [Sentence]
        let corrected: String
    }

    private struct Translation: Decodable {
        let german: String
        let note: String
    }

    private struct Articles: Decodable {
        struct Noun: Decodable {
            let article: String
            let word: String
            let plural: String
            let meaning: String
            let explanation: String
        }

        let nouns: [Noun]
    }

    func fix(_ text: String) async throws -> KeyboardFix {
        let data = try await send("write", ["action": "check", "text": text])
        let check = try JSONDecoder().decode(Check.self, from: data)
        let reasons = check.sentences.filter { $0.kind == "fix" }.map { sentence in
            sentence.title.isEmpty ? sentence.note : "\(sentence.title): \(sentence.note)"
        }
        let corrected = check.corrected.trimmingCharacters(in: .whitespacesAndNewlines)
        return KeyboardFix(original: text, corrected: corrected.isEmpty ? text : corrected, reasons: reasons)
    }

    func say(_ text: String, register: KeyboardRegister) async throws -> KeyboardAnswer {
        let data = try await send("translate", ["text": text, "language": language, "register": register.rawValue])
        let translation = try JSONDecoder().decode(Translation.self, from: data)
        let german = translation.german.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !german.isEmpty else { throw RealtimeServiceError.unexpectedResponse }
        return KeyboardAnswer(asked: text, german: german, note: translation.note)
    }

    func nouns(for word: String) async throws -> [KeyboardNoun] {
        let data = try await send("articles", ["action": "lookup", "text": word, "language": language])
        return try JSONDecoder().decode(Articles.self, from: data).nouns
            .filter { ["der", "die", "das"].contains($0.article) && !$0.word.isEmpty }
            .map {
                KeyboardNoun(article: $0.article, word: $0.word, plural: $0.plural, meaning: $0.meaning,
                             explanation: $0.explanation)
            }
    }
}

/// Which words of a corrected text are new, to mark them in the strip.
enum FixMarks {
    struct Word: Equatable {
        var text: String
        var isChanged: Bool
    }

    /// The corrected text word by word; a word the learner didn't write in that place is marked.
    static func words(of fix: KeyboardFix) -> [Word] {
        let old = fix.original.split(whereSeparator: \.isWhitespace).map(String.init)
        let new = fix.corrected.split(whereSeparator: \.isWhitespace).map(String.init)
        guard !old.isEmpty, !new.isEmpty else { return new.map { Word(text: $0, isChanged: true) } }
        // The longest run of words both texts share, in order; the rest of the new text is what changed.
        var lengths = Array(repeating: Array(repeating: 0, count: new.count + 1), count: old.count + 1)
        for oldIndex in stride(from: old.count - 1, through: 0, by: -1) {
            for newIndex in stride(from: new.count - 1, through: 0, by: -1) {
                lengths[oldIndex][newIndex] = old[oldIndex] == new[newIndex]
                    ? lengths[oldIndex + 1][newIndex + 1] + 1
                    : max(lengths[oldIndex + 1][newIndex], lengths[oldIndex][newIndex + 1])
            }
        }
        var words: [Word] = []
        var oldIndex = 0
        var newIndex = 0
        while newIndex < new.count {
            if oldIndex < old.count, old[oldIndex] == new[newIndex] {
                words.append(Word(text: new[newIndex], isChanged: false))
                oldIndex += 1
                newIndex += 1
            } else if oldIndex < old.count, lengths[oldIndex + 1][newIndex] >= lengths[oldIndex][newIndex + 1] {
                oldIndex += 1
            } else {
                words.append(Word(text: new[newIndex], isChanged: true))
                newIndex += 1
            }
        }
        return words
    }

    /// The words to show in one line: from just before the first change, so it is in view.
    static func excerpt(of fix: KeyboardFix) -> (words: [Word], startsLater: Bool) {
        let all = words(of: fix)
        guard let first = all.firstIndex(where: \.isChanged), first > 2 else { return (all, false) }
        return (Array(all[(first - 1)...]), true)
    }
}
