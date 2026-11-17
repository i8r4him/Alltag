//
//  TranslationService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// Why a text couldn't be translated.
enum TranslationServiceError: Error, Equatable {
    /// The languages are supported but not downloaded yet; the learner can download them.
    case needsDownload(source: Locale.Language, target: Locale.Language)
    /// This device can't translate between these languages.
    case unsupported
}

/// How the German answer should sound, for "How do I say …?".
enum GermanRegister: String, CaseIterable, Identifiable {
    /// Spoken, casual German, as people say it to friends, colleagues and in shops (the default).
    case everyday
    /// Polite, written German with Sie: an email, a letter, an office.
    case formal

    var id: Self { self }
}

/// Translates between English and German with explanations.
protocol TranslationService: AnyObject {
    func translate(_ text: String, onUpdate: @escaping (TranslationResult) -> Void) async throws -> TranslationResult?
    /// As `translate(_:onUpdate:)`, with German that sounds the way `register` asks;
    /// `nil` keeps the translator's natural German (Translate and the panel).
    func translate(_ text: String, register: GermanRegister?,
                   onUpdate: @escaping (TranslationResult) -> Void) async throws -> TranslationResult?
    /// The translation of `text`, or `nil` if it can't be translated.
    /// Works in both directions (English → German and German → English).
    /// The result may come without word-by-word, tones and examples; `explain` adds them.
    func translate(_ text: String) async throws -> TranslationResult?
    /// `result` with word-by-word, tones and examples added where possible.
    func explain(_ result: TranslationResult) async -> TranslationResult
}

extension TranslationService {
    func translate(_ text: String, onUpdate: @escaping (TranslationResult) -> Void) async throws -> TranslationResult? {
        try await translate(text)
    }

    /// Only the server can choose how the German sounds; other services translate as usual.
    func translate(_ text: String, register: GermanRegister?,
                   onUpdate: @escaping (TranslationResult) -> Void) async throws -> TranslationResult? {
        try await translate(text, onUpdate: onUpdate)
    }
}

/// Knows only the prototype's three samples; anything else returns `nil`.
/// Also used by previews and tests.
final class MockTranslationService: TranslationService {
    private let delay: Duration

    init(delay: Duration = .milliseconds(300)) {
        self.delay = delay
    }

    func translate(_ text: String) async throws -> TranslationResult? {
        try await Task.sleep(for: delay)
        return MockTranslations.match(text)
    }

    func explain(_ result: TranslationResult) async -> TranslationResult { result }
}
