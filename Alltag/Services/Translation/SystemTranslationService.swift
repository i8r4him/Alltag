//
//  SystemTranslationService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import FoundationModels
import NaturalLanguage
import OSLog
import Translation

/// English ⇄ German with Apple's Translation framework, on device.
///
/// The three curated samples keep their hand-written explanations. Anything
/// else is translated by the system, and Apple Intelligence adds word-by-word,
/// tones and examples when it's available.
final class SystemTranslationService: TranslationService {
    private let client: any LanguageModelClient
    private let isModelAvailable: () -> Bool
    private let logger = Logger(subsystem: "Alltag", category: "Translation")

    static let english = Locale.Language(identifier: "en")
    static let german = Locale.Language(identifier: "de")

    init(client: any LanguageModelClient = SystemLanguageModelClient(),
         isModelAvailable: @escaping () -> Bool = { SystemLanguageModel.default.isAvailable }) {
        self.client = client
        self.isModelAvailable = isModelAvailable
    }

    func translate(_ text: String) async throws -> TranslationResult? {
        if let sample = MockTranslations.match(text) { return sample }

        let isGerman = Self.isGerman(text)
        let (source, target) = isGerman ? (Self.german, Self.english) : (Self.english, Self.german)
        switch await LanguageAvailability().status(from: source, to: target) {
        case .installed: break
        case .supported: throw TranslationServiceError.needsDownload(source: source, target: target)
        case .unsupported: throw TranslationServiceError.unsupported
        @unknown default: throw TranslationServiceError.unsupported
        }

        let response = try await TranslationSession(installedSource: source, target: target).translate(text)
        let translated = response.targetText
        return TranslationResult(english: isGerman ? translated : text, german: isGerman ? text : translated,
                                 words: [], tones: [], note: "", examples: [])
    }

    func explain(_ result: TranslationResult) async -> TranslationResult {
        guard !result.isExplained, isModelAvailable() else { return result }
        do {
            let details = try await client.generate(GeneratedTranslationDetails.self,
                                                    instructions: Self.instructions,
                                                    prompt: "English: \(result.english)\nGerman: \(result.german)")
            return TranslationResult(result, details)
        } catch {
            logger.error("Explaining fell back to the plain translation: \(error.localizedDescription, privacy: .public)")
            return result
        }
    }

    /// Whether `text` reads as German rather than English.
    static func isGerman(_ text: String) -> Bool {
        let recogniser = NLLanguageRecognizer()
        recogniser.languageConstraints = [.english, .german]
        recogniser.processString(text)
        let hypotheses = recogniser.languageHypotheses(withMaximum: 2)
        return (hypotheses[.german] ?? 0) > (hypotheses[.english] ?? 0)
    }

    private static let instructions = """
        You are Alltag, a German tutor for English speakers. Explain a German sentence and its English \
        translation for a learner: the key words, how to say it in other registers, and how it is used. \
        Write explanations in British English and keep every field short.
        """
}

@Generable
struct GeneratedTranslationDetails {
    @Generable
    struct Word {
        @Guide(description: "A German word or short phrase from the sentence, with its article if it is a noun")
        var word: String
        @Guide(description: "Very short grammar note, e.g. „noun · pl. Termine“ or „verb · separable“")
        var grammar: String
        @Guide(description: "Its meaning in British English")
        var meaning: String
    }

    @Generable
    struct Tone {
        @Generable
        enum Register {
            case formal
            case neutral
            case casual
        }

        var register: Register
        @Guide(description: "The German sentence in this register")
        var german: String
    }

    @Generable
    struct Example {
        @Guide(description: "A short German sentence using the same words in another situation")
        var german: String
        @Guide(description: "Its meaning in British English")
        var english: String
    }

    @Guide(description: "The key words of the German sentence", .count(1...4))
    var words: [Word]
    @Guide(description: "The sentence in formal, neutral and casual German, in that order", .count(3))
    var tones: [Tone]
    @Guide(description: "One sentence about register and when to use it")
    var note: String
    @Guide(description: "Example sentences", .count(2))
    var examples: [Example]
}

extension TranslationResult {
    /// `result` with the model's explanations.
    init(_ result: TranslationResult, _ details: GeneratedTranslationDetails) {
        self.init(
            english: result.english,
            german: result.german,
            words: details.words.map { WordBreakdown(word: $0.word, grammar: $0.grammar, meaning: $0.meaning) },
            tones: details.tones.map { ToneVariant(tone: ToneVariant.Tone($0.register), german: $0.german) },
            note: details.note,
            examples: details.examples.map { Example(german: $0.german, english: $0.english) }
        )
    }
}

extension TranslationResult.ToneVariant.Tone {
    init(_ register: GeneratedTranslationDetails.Tone.Register) {
        self = switch register {
        case .formal: .formal
        case .neutral: .neutral
        case .casual: .casual
        }
    }
}
