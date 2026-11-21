//
//  TypingAccuracyTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 21.11.26.
//

import CoreGraphics
import Foundation
import Testing
@testable import Alltag

/// A typist whose fingers miss a little, in the same way at every run.
struct Typist {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed
    }

    /// A number between 0 and 1.
    mutating func unit() -> Double {
        state &+= 0x9E37_79B9_7F4A_7C15
        var value = state
        value = (value ^ (value >> 30)) &* 0xBF58_476D_1CE4_E5B9
        value = (value ^ (value >> 27)) &* 0x94D0_49BB_1331_11EB
        value ^= value >> 31
        return (Double(value >> 11) + 0.5) / 9_007_199_254_740_992
    }

    /// How far a touch lands from where it was aimed, in spreads: mostly near, now and then far.
    mutating func miss() -> Double {
        (-2 * log(unit())).squareRoot() * cos(2 * Double.pi * unit())
    }
}

/// How many words come out wrong when fingers miss, with and without auto-correction.
/// The touches are made up, the same at every run, so no test depends on a real finger or on time.
@Suite("Keyboard typing accuracy")
@MainActor
struct TypingAccuracyTests {
    static let sentences = [
        "Ich habe heute keine Zeit",
        "Wir gehen morgen ins Kino",
        "Kannst du mir bitte helfen",
        "Das Wetter ist heute sehr schön",
        "Ich komme aus Syrien und wohne in Berlin",
        "Wo ist der nächste Supermarkt",
        "Ich möchte einen Kaffee mit Milch",
        "Meine Schwester arbeitet im Krankenhaus",
        "Wir sehen uns am Samstag",
        "Hast du Lust auf einen Spaziergang",
        "Der Zug kommt um acht Uhr an",
        "Ich lerne jeden Tag neue Wörter",
        "Kannst du das bitte wiederholen",
        "Ich bin gestern spät nach Hause gekommen",
        "Die Wohnung ist klein aber gemütlich",
        "Vielen Dank für deine Hilfe",
        "Ich muss noch einkaufen gehen",
        "Was machst du am Wochenende",
        "Mein Deutsch wird langsam besser",
        "Entschuldigung ich habe eine Frage",
        "Wir treffen uns vor dem Bahnhof",
        "Ich habe den Termin vergessen",
        "Können Sie mir den Weg zeigen",
        "Das Essen war wirklich lecker",
        "Ich rufe dich später an",
        "Heute Abend koche ich Nudeln",
        "Der Bus hat wieder Verspätung",
        "Ich freue mich auf den Urlaub",
        "Sie hat mir ein Buch geschenkt",
        "Morgen muss ich früh aufstehen"
    ]

    /// The sentences' words and others that lie close to them on the keys.
    static let vocabulary = """
        ich habe heute keine Zeit wir gehen morgen ins Kino kannst du mir bitte helfen das Wetter ist sehr schön
        komme aus Syrien und wohne in Berlin wo der nächste Supermarkt möchte einen Kaffee mit Milch meine Schwester
        arbeitet im Krankenhaus sehen uns am Samstag hast Lust auf Spaziergang Zug kommt um acht Uhr an lerne jeden
        Tag neue Wörter wiederholen bin gestern spät nach Hause gekommen die Wohnung klein aber gemütlich vielen Dank
        für deine Hilfe muss noch einkaufen was machst Wochenende mein Deutsch wird langsam besser Entschuldigung
        eine Frage treffen vor dem Bahnhof den Termin vergessen können sie Weg zeigen Essen war wirklich lecker rufe
        dich später Abend koche Nudeln Bus hat wieder Verspätung freue mich Urlaub ein Buch geschenkt früh aufstehen
        dir des dass wer wie sich sein dein kein nein einem einer habt haben hatte bist sind seid waren kann musst
        müssen will willst wollen geht ging sieht kommen macht machen mache Nacht Woche Jahr Haus Hund Hand Kind Frau
        Mann oder auch nicht nur schon gut gern viel mehr von bei zu zum zur er es ihr man so da ja doch mal nun hier
        dort immer nie oft alle alles etwas nichts jetzt dann wenn weil ob als denn wann warum welche dieser diese
        dieses jeder jede unser euer ihn ihm ihnen euch meinen deinen seinen Hof Tor Ton Tod rot not Rat Tat hart Art
        Ort Wort Wert mut Mut Rad Bad bat bot Boot Brot Bein Wein fein rein Reim Raum kaum Baum Zaun Zahn Bahn Wahn
        Hahn Tisch Fisch frisch Stuhl Schule Schuhe Suche Sache Sprache Strasse Stadt statt Staat Start Stern fern
        Kern lesen leben geben nehmen stehen drehen fahren fragen sagen tragen trinken denken danken winken neu neun
        neuen neuer alt kalt halt bald Wald Geld Feld Welt hell schnell stellen spielen spülen fühlen
        """

    /// Mistyped words the report asks the device's dictionary about.
    static let probes = """
        eiben Eiben bergessen Bergessen einkufen Einkufen tisch nuss ost mut ir sn day abet it Wit wit deb nir gat sm \
        Yank Bis Och loche leine zeihen Krankengaus Spazierfang eohnr eorklich nöxhte Sruen zna langam nichr hsus \
        ichbin fur strase gehem nocv machsz dss levker icj aifstehen niss kwime einek gwmütlich nice cool love ok
        """

    let size = CGSize(width: 440, height: 271)
    /// How far the fingers scatter, in points: about a quarter of a key.
    let spread = CGSize(width: 9, height: 10)

    /// Types every sentence `rounds` times, each on a fresh keyboard, and gives back what stands in the text field.
    func type(checker: WordChecking, isSmart: Bool, spread: CGSize, rounds: Int) -> [String] {
        var typist = Typist(seed: 2026)
        var texts: [String] = []
        for _ in 0..<rounds {
            for sentence in Self.sentences {
                let document = FakeDocument()
                let model = KeyboardModel()
                model.document = document
                model.smart.checker = checker
                model.smart.words.seed = GermanWords.pairs
                model.set(.autoCorrection, to: isSmart)
                model.documentChanged(KeyboardTraits())
                type(sentence + " ", on: model, typist: &typist, spread: spread)
                texts.append(document.before)
            }
        }
        return texts
    }

    /// Aims at each key's middle and lands where the typist's miss puts the finger.
    func type(_ text: String, on model: KeyboardModel, typist: inout Typist, spread: CGSize) {
        for character in text {
            // What a learner does after a slip onto another key: back to the letters.
            if model.showsEmoji { model.closeEmoji() }
            if model.page != .letters { model.activate(.page(.letters)) }
            var key = KeyboardKey.space
            if character != " " {
                while character.isUppercase != model.shift.isOn { model.activate(.shift) }
                key = .character(character.lowercased())
            }
            let geometry = KeyboardGeometry(rows: model.rows, size: size)
            // A thumb lands anywhere in the middle half of the space bar.
            let along = key == .space ? typist.unit() - 0.5 : 0
            let missX = typist.miss() * spread.width
            let missY = typist.miss() * spread.height
            guard let frame = geometry.frame(of: key)?.frame else { continue }
            let point = CGPoint(x: frame.midX + along * frame.width * 0.5 + missX, y: frame.midY + missY)
            model.touchDown(1, at: point, in: geometry)
            model.touchUp(1)
        }
    }

    /// How many of the wanted words are missing from what was typed.
    static func wrongWords(in typed: String, wanted: String) -> Int {
        let old = wanted.split(separator: " ").map(String.init)
        let new = typed.split(whereSeparator: \.isWhitespace).map(String.init)
        var lengths = Array(repeating: Array(repeating: 0, count: new.count + 1), count: old.count + 1)
        for (oldIndex, word) in old.enumerated() {
            for (newIndex, other) in new.enumerated() {
                lengths[oldIndex + 1][newIndex + 1] = word == other
                    ? lengths[oldIndex][newIndex] + 1
                    : max(lengths[oldIndex][newIndex + 1], lengths[oldIndex + 1][newIndex])
            }
        }
        return old.count - lengths[old.count][new.count]
    }

    func wrongWords(in texts: [String]) -> Int {
        texts.enumerated().reduce(0) { sum, text in
            sum + Self.wrongWords(in: text.element, wanted: Self.sentences[text.offset % Self.sentences.count])
        }
    }

    @Test("Auto-correction takes away many of the words a missing finger gets wrong")
    func fewerMistakes() {
        let checker = FixedDictionary(Self.vocabulary)
        let plain = wrongWords(in: type(checker: checker, isSmart: false, spread: spread, rounds: 4))
        let smart = wrongWords(in: type(checker: checker, isSmart: true, spread: spread, rounds: 4))
        #expect(plain > 20)
        #expect(Double(smart) < Double(plain) * 0.7)
    }

    @Test("Typing that hits every key is left as it is")
    func exactTyping() {
        let texts = type(checker: FixedDictionary(Self.vocabulary), isSmart: true, spread: .zero, rounds: 1)
        #expect(texts == Self.sentences.map { $0 + " " })
    }

    @Test("Where a folder waits for the keyboard's pictures, the accuracy is written there too")
    func report() throws {
        guard let folder = KeyboardPictureTests.folder else { return }
        let dictionary = DictionarySuggestions()
        var lines = summary(of: "test dictionary", checker: FixedDictionary(Self.vocabulary))
            + summary(of: "the dictionary of this device", checker: dictionary)
        // What the device's dictionary makes of words that came out wrong: the costs are set with this in view.
        lines.append("what the dictionary of this device says (German, other language, guesses):")
        for word in Self.probes.split(separator: " ").map(String.init) {
            let guesses = dictionary.guesses(for: word).prefix(5).joined(separator: ", ")
            lines.append("  \(word): \(dictionary.isWord(word)) \(dictionary.isForeignWord(word)) [\(guesses)]")
        }
        try lines.joined(separator: "\n").write(to: folder.appendingPathComponent("typing-accuracy.txt"),
                                                atomically: true, encoding: .utf8)
    }

    /// The share of wrong words with and without auto-correction, how long it took, and what went wrong.
    func summary(of name: String, checker: WordChecking) -> [String] {
        let rounds = 6
        let start = Date.now
        let plain = type(checker: checker, isSmart: false, spread: spread, rounds: rounds)
        let middle = Date.now
        let smart = type(checker: checker, isSmart: true, spread: spread, rounds: rounds)
        let end = Date.now
        let exact = type(checker: checker, isSmart: true, spread: .zero, rounds: 1)
        let words = Self.sentences.reduce(0) { $0 + $1.split(separator: " ").count } * rounds
        func share(_ wrong: Int) -> String { String(format: "%.1f %%", Double(wrong) * 100 / Double(words)) }
        var lines = [
            "\(name): \(words) words, spread \(Int(spread.width)) x \(Int(spread.height)) pt",
            "  wrong without auto-correction: \(share(wrongWords(in: plain)))",
            "  wrong with auto-correction: \(share(wrongWords(in: smart)))",
            String(format: "  time: %.2f s without, %.2f s with", middle.timeIntervalSince(start), end.timeIntervalSince(middle)),
            "  exact typing that came out changed:"
        ]
        for (index, text) in exact.enumerated() where text != Self.sentences[index] + " " {
            lines.append("    \(Self.sentences[index]) | \(text)")
        }
        lines.append("  still wrong with auto-correction (wanted | without | with):")
        for (index, text) in smart.enumerated() {
            let wanted = Self.sentences[index % Self.sentences.count]
            if Self.wrongWords(in: text, wanted: wanted) > 0 { lines.append("    \(wanted) | \(plain[index]) | \(text)") }
        }
        return lines + [""]
    }
}
