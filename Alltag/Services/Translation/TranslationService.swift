//
//  TranslationService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// Translates between English and German with explanations.
protocol TranslationService: AnyObject {
    /// The translation of `text`, or `nil` if it can't be translated.
    /// Works in both directions (English → German and German → English).
    func translate(_ text: String) async throws -> TranslationResult?
}

/// Knows only the prototype's three samples; anything else returns `nil`, and
/// Translate explains that live translation comes with Apple's Translation
/// framework (#50).
final class MockTranslationService: TranslationService {
    private let delay: Duration

    init(delay: Duration = .milliseconds(300)) {
        self.delay = delay
    }

    func translate(_ text: String) async throws -> TranslationResult? {
        try await Task.sleep(for: delay)
        return MockTranslations.match(text)
    }
}
