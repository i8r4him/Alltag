//
//  MockTranslations.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The prototype's three sample translations (`TR`).
enum MockTranslations {
    typealias Word = TranslationResult.WordBreakdown
    typealias Tone = TranslationResult.ToneVariant
    typealias Example = TranslationResult.Example

    static let all: [TranslationResult] = [moveAppointment, letMeKnow, callingItADay]

    /// The sample whose English or German text matches `text`, ignoring case and spaces.
    static func match(_ text: String) -> TranslationResult? {
        let needle = normalized(text)
        return all.first { normalized($0.english) == needle || normalized($0.german) == needle }
    }

    private static func normalized(_ text: String) -> String {
        text.lowercased().filter { $0.isLetter || $0.isNumber }
    }

    static let moveAppointment = TranslationResult(
        english: "Can we move the appointment to tomorrow?",
        german: "Können wir den Termin auf morgen verschieben?",
        words: [
            Word(word: "der Termin", grammar: "noun · pl. Termine", meaning: "appointment"),
            Word(word: "auf morgen", grammar: "preposition + adverb", meaning: "to tomorrow"),
            Word(word: "verschieben", grammar: "verb + accusative", meaning: "to postpone, move")
        ],
        tones: [
            Tone(tone: .formal, german: "Könnten wir den Termin auf morgen verlegen?"),
            Tone(tone: .neutral, german: "Können wir den Termin auf morgen verschieben?"),
            Tone(tone: .casual, german: "Geht's auch morgen?")
        ],
        note: "Polite and neutral — right for a doctor, an office or a colleague. „Könnten“ softens it further.",
        examples: [
            Example(german: "Das Meeting wurde auf Freitag verschoben.", english: "The meeting was moved to Friday."),
            Example(german: "Wir müssen die Reise leider verschieben.", english: "Unfortunately we have to postpone the trip.")
        ]
    )

    static let letMeKnow = TranslationResult(
        english: "Let me know when you're free.",
        german: "Sag mir Bescheid, wann du Zeit hast.",
        words: [
            Word(word: "Bescheid sagen", grammar: "fixed phrase", meaning: "to let someone know"),
            Word(word: "Zeit haben", grammar: "verb phrase", meaning: "to be free"),
            Word(word: "wann", grammar: "question word", meaning: "when")
        ],
        tones: [
            Tone(tone: .formal, german: "Geben Sie mir bitte Bescheid, wann Sie Zeit haben."),
            Tone(tone: .neutral, german: "Sag mir Bescheid, wann du Zeit hast."),
            Tone(tone: .casual, german: "Sag Bescheid, wann's dir passt.")
        ],
        note: "Uses „du“ — for friends and colleagues on first-name terms. Notice „hast“ moves to the end.",
        examples: [
            Example(german: "Sag mir Bescheid, wenn du da bist.", english: "Let me know when you're there."),
            Example(german: "Ich gebe dir morgen Bescheid.", english: "I'll let you know tomorrow.")
        ]
    )

    static let callingItADay = TranslationResult(
        english: "I'm calling it a day.",
        german: "Ich mache jetzt Feierabend.",
        words: [
            Word(word: "der Feierabend", grammar: "noun", meaning: "time after work"),
            Word(word: "Feierabend machen", grammar: "verb phrase", meaning: "to finish work"),
            Word(word: "jetzt", grammar: "adverb", meaning: "now")
        ],
        tones: [
            Tone(tone: .formal, german: "Ich beende jetzt meinen Arbeitstag."),
            Tone(tone: .neutral, german: "Ich mache jetzt Feierabend."),
            Tone(tone: .casual, german: "Feierabend!")
        ],
        note: "„Feierabend“ has no one-word English equivalent — it is the evening that belongs to you after work.",
        examples: [
            Example(german: "Schönen Feierabend!", english: "Enjoy your evening! (said when leaving work)"),
            Example(german: "Nach Feierabend gehen wir oft ins Café.", english: "After work we often go to the café.")
        ]
    )
}
