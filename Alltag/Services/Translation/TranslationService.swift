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

/// Translates between English and German with explanations.
protocol TranslationService: AnyObject {
    /// The translation of `text`, or `nil` if it can't be translated.
    /// Works in both directions (English → German and German → English).
    /// The result may come without word-by-word, tones and examples; `explain` adds them.
    func translate(_ text: String) async throws -> TranslationResult?
    /// `result` with word-by-word, tones and examples added where possible.
    func explain(_ result: TranslationResult) async -> TranslationResult
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
