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
    private(set) var hasAttempted = false
    /// Word-by-word, tones and examples are being added.
    private(set) var isExplaining = false
    /// Why the last translation failed, until the text changes or it is tried again.
    private(set) var failure: CloudFailure?
    /// Languages to download before this text can be translated on device.
    private(set) var missingLanguages: (source: Locale.Language, target: Locale.Language)?
    /// Direction chosen with the swap button when the text isn't recognised.
    private var prefersGermanSource = false
    /// The text put in the field from the history, with its translation: changing
    /// the field to it must not clear what was just shown.
    private(set) var restoredInput: String?
    /// The recent translations, for the toolbar's history.
    let history: TranslationHistory

    private let translation: any TranslationService
    private let voice: any VoiceService

    /// Starts empty unless another screen supplied text.
    init(text: String?, services: AppServices, defaults: UserDefaults = .standard) {
        history = TranslationHistory(defaults: defaults)
        let trimmed = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        input = trimmed
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
        defer { isTranslating = false }
        hasAttempted = true
        missingLanguages = nil
        failure = nil
        do {
            let translated = try await translation.translate(text) { partial in
                guard !Task.isCancelled, self.input.trimmingCharacters(in: .whitespacesAndNewlines) == text else { return }
                self.result = partial
            }
            guard !Task.isCancelled, input.trimmingCharacters(in: .whitespacesAndNewlines) == text else { return }
            result = translated
        } catch TranslationServiceError.needsDownload(let source, let target) {
            guard !Task.isCancelled, input.trimmingCharacters(in: .whitespacesAndNewlines) == text else { return }
            result = nil
            missingLanguages = (source, target)
        } catch {
            guard !Task.isCancelled, input.trimmingCharacters(in: .whitespacesAndNewlines) == text else { return }
            result = nil
            failure = CloudFailure(error)
        }

        if let plain = result, !plain.isExplained {
            isExplaining = true
            let explained = await translation.explain(plain)
            // Only if the learner hasn't typed something else meanwhile.
            if !Task.isCancelled, input.trimmingCharacters(in: .whitespacesAndNewlines) == text, result == plain { result = explained }
            isExplaining = false
        }
        if !Task.isCancelled, let result, input.trimmingCharacters(in: .whitespacesAndNewlines) == text {
            history.remember(text, result: result)
        }
    }

    /// Shows a translation from the history again, as it was, without asking the server.
    func show(_ lookup: TranslationLookup) {
        restoredInput = lookup.input
        input = lookup.input
        result = lookup.result
        missingLanguages = nil
        failure = nil
        isTranslating = false
        isExplaining = false
        hasAttempted = true
        history.remember(lookup.input, result: lookup.result)
    }

    func clearResult() {
        result = nil
        missingLanguages = nil
        failure = nil
        hasAttempted = false
        restoredInput = nil
    }

    /// The languages finished downloading: try again.
    func languagesDownloaded() async {
        missingLanguages = nil
        await translate()
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

    func listen(to german: String, slowly: Bool = false) async {
        await voice.speak(german, rate: slowly ? .slow : .normal)
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
