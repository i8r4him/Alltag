//
//  TranslateModel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Observation
import SwiftData

/// Translate's state: the text, its translation, the direction and saving.
@Observable
final class TranslateModel {
    /// What the learner typed (either language).
    var input: String
    private(set) var result: TranslationResult?
    private(set) var isTranslating = false
    /// Direction chosen with the swap button when the text isn't recognised.
    private var prefersGermanSource = false

    private let translation: any TranslationService
    private let voice: any VoiceService

    /// Starts with `text`, or the first sample if there is none.
    init(text: String?, services: AppServices) {
        let trimmed = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        input = trimmed.isEmpty ? MockTranslations.all[0].english : trimmed
        translation = services.translation
        voice = services.voice
    }

    // MARK: Direction

    /// Whether the input is German (so the result is English).
    var sourceIsGerman: Bool {
        guard let result else { return prefersGermanSource }
        return ConversationModel.normalized(input) == ConversationModel.normalized(result.german)
    }

    var sourceLabel: LocalizedStringResource { sourceIsGerman ? "German" : "English" }
    var resultLabel: LocalizedStringResource { sourceIsGerman ? "English" : "German" }

    /// The translation in the target language.
    var resultText: String? {
        guard let result else { return nil }
        return sourceIsGerman ? result.english : result.german
    }

    /// Swaps the languages: the translation becomes the input.
    func swap() {
        if let result {
            input = sourceIsGerman ? result.english : result.german
        } else {
            prefersGermanSource.toggle()
        }
    }

    // MARK: Translating

    func translate() async {
        let text = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else {
            result = nil
            return
        }
        isTranslating = true
        result = try? await translation.translate(text)
        isTranslating = false
    }

    /// Shows a sample translation.
    func use(_ sample: TranslationResult) {
        input = sample.english
    }

    // MARK: Listening

    /// Speaks the German side of the translation.
    func listen(slowly: Bool = false) async {
        guard let german = result?.german else { return }
        await voice.speak(german, rate: slowly ? .slow : .normal)
    }

    func listen(to german: String) async {
        await voice.speak(german, rate: .normal)
    }

    // MARK: Saving

    func isSaved(in translations: [SavedTranslation]) -> Bool {
        guard let result else { return false }
        return translations.contains { $0.german == result.german }
    }

    /// Saves the translation, or removes it if it's already saved. Returns
    /// `true` if it is saved afterwards.
    @discardableResult
    func toggleSave(in context: ModelContext) -> Bool {
        guard let result else { return false }
        let german = result.german
        let existing = (try? context.fetch(FetchDescriptor<SavedTranslation>(predicate: #Predicate { $0.german == german }))) ?? []
        if existing.isEmpty {
            context.insert(SavedTranslation(english: result.english, german: result.german))
        } else {
            existing.forEach(context.delete)
        }
        try? context.save()
        return existing.isEmpty
    }
}
