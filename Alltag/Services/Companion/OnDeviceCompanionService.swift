//
//  OnDeviceCompanionService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import FoundationModels
import OSLog

/// Generates structured answers with a language model; replaced in tests.
protocol LanguageModelClient {
    func generate<Content: Generable>(_ type: Content.Type, instructions: String, prompt: String) async throws -> Content
}

/// Apple Intelligence's on-device model, one fresh session per request.
struct SystemLanguageModelClient: LanguageModelClient {
    func generate<Content: Generable>(_ type: Content.Type, instructions: String, prompt: String) async throws -> Content {
        try await LanguageModelSession(instructions: instructions).respond(to: prompt, generating: type).content
    }
}

/// The companion running on Apple Intelligence's on-device model.
///
/// Conversations keep their scripted replies, so every scenario still reaches
/// its goal; the model judges sentences the learner makes up and writes
/// debriefs. Whenever the model is unavailable or fails, `fallback` answers.
/// After a failure that isn't about one request (missing model assets, for
/// example), the model is left alone until the next launch.
final class OnDeviceCompanionService: CompanionService {
    private let fallback: any CompanionService
    private let client: any LanguageModelClient
    private let isModelAvailable: () -> Bool
    private var isModelWorking = true
    private let logger = Logger(subsystem: "Alltag", category: "Companion")

    init(fallback: any CompanionService = MockCompanionService(),
         client: any LanguageModelClient = SystemLanguageModelClient(),
         isModelAvailable: @escaping () -> Bool = { SystemLanguageModel.default.isAvailable }) {
        self.fallback = fallback
        self.client = client
        self.isModelAvailable = isModelAvailable
    }

    var usesOnDeviceModel: Bool { isModelWorking && isModelAvailable() }

    func respond(to learnerText: String, in scenario: Scenario, turn: Int) async throws -> CompanionResponse {
        try await fallback.respond(to: learnerText, in: scenario, turn: turn)
    }

    func feedback(on sentence: String, in scenario: Scenario, replyingTo previous: String?) async throws -> SentenceFeedback {
        let prompt = CompanionPrompt.feedback(on: sentence, in: scenario, replyingTo: previous)
        if usesOnDeviceModel, let generated = await generate(GeneratedFeedback.self, Self.feedbackInstructions, prompt) {
            return SentenceFeedback(generated)
        }
        return try await fallback.feedback(on: sentence, in: scenario, replyingTo: previous)
    }

    func debrief(_ input: String, about moment: Debrief) async throws -> Debrief {
        let prompt = CompanionPrompt.debrief(input, about: moment)
        if usesOnDeviceModel, let generated = await generate(GeneratedDebrief.self, Self.debriefInstructions, prompt) {
            return Debrief(generated, for: moment)
        }
        return try await fallback.debrief(input, about: moment)
    }

    /// The model's answer, or `nil` when it failed.
    private func generate<Content: Generable>(_ type: Content.Type, _ instructions: String, _ prompt: String) async -> Content? {
        do {
            return try await client.generate(type, instructions: instructions, prompt: prompt)
        } catch {
            let isAboutRequest = Self.isAboutRequest(error)
            if !isAboutRequest { isModelWorking = false }
            logger.error("""
                Fell back to the samples\(isAboutRequest ? "" : " until relaunch", privacy: .public): \
                \(error.localizedDescription, privacy: .public)
                """)
            return nil
        }
    }

    /// Whether `error` concerns this one request, so the next may succeed.
    static func isAboutRequest(_ error: any Error) -> Bool {
        guard let error = error as? LanguageModelError else { return false }
        switch error {
        case .contextSizeExceeded, .rateLimited, .guardrailViolation, .refusal, .unsupportedLanguageOrLocale, .timeout:
            return true
        default:
            return false
        }
    }

    private static let feedbackInstructions = """
        You are Alltag, a warm and precise German tutor. The learner is rehearsing a real conversation \
        in German and has said a sentence of their own. Judge only that sentence. \
        Use "good" when it is correct and natural, "fix" when it has a grammar, word-order or vocabulary \
        mistake, and "note" when it is correct but does not fit the situation or a more natural phrasing exists. \
        Write the title and note in British English, except for German words and corrections. \
        Quote German with „…“. Never lecture; one idea per note.
        """

    private static let debriefInstructions = """
        You are Alltag, a warm German tutor. The learner tells you, in any language, what they wanted to say \
        during a moment of their day but couldn't. Give short, natural, everyday German sentences they can say \
        next time, each with its British English meaning, and one grammar tip about them. Use the polite „Sie“ \
        only when the situation calls for it.
        """
}

/// The prompts sent to the model, kept apart so tests can check them.
enum CompanionPrompt {
    /// How a spoken sentence is judged by Apple's cloud model. The same rules as the
    /// `check-german` Edge Function: real mistakes only, nothing about punctuation or the topic.
    static let checkInstructions = """
        You are Alltag, a warm and precise German tutor. A learner SAID the sentence below out loud; \
        speech recognition wrote it down. Judge only that sentence, as spoken German. \
        Use "fix" for a real mistake in grammar, word order, case, gender, verb form, preposition or word choice; \
        "note" when it is correct but a native speaker would clearly say it differently; \
        "good" when it is correct and natural. When in doubt between "good" and "note", choose "good". \
        Do not correct punctuation, capital letters or spelling that sounds the same: they come from the speech \
        recognition. Do not invent mistakes, never change the meaning, and do not judge what the learner talks about. \
        Write the title and note in British English, simply for A1 and A2 learners. Quote German with „…“.
        """

    static func feedback(on sentence: String, in scenario: Scenario, replyingTo previous: String?) -> String {
        var lines = [
            "Situation: \(scenario.title). The learner's goal: \(scenario.goal)."
        ]
        if let previous { lines.append("The other person just said: „\(previous)“") }
        lines.append("The learner said: „\(sentence)“")
        return lines.joined(separator: "\n")
    }

    static func debrief(_ input: String, about moment: Debrief) -> String {
        """
        Moment: \(moment.event) at \(moment.time).
        What the learner wanted to say: \(input)
        """
    }
}

@Generable
struct GeneratedFeedback {
    @Generable
    enum Kind {
        case good
        case fix
        case note
    }

    @Guide(description: "good, fix or note")
    var kind: Kind
    @Guide(description: "At most six words naming what is good or the rule broken, e.g. „Verb goes last after „wenn““")
    var title: String
    @Guide(description: "One short sentence. For fix, start with the corrected German sentence.")
    var note: String
    @Guide(description: "What the learner's sentence means, in British English")
    var english: String
    @Guide(description: "For fix: the learner's whole sentence, corrected. Otherwise empty.")
    var correction: String
}

@Generable
struct GeneratedDebrief {
    @Generable
    struct Example {
        @Guide(description: "A short, natural German sentence")
        var german: String
        @Guide(description: "Its meaning in British English")
        var english: String
    }

    @Guide(description: "Sentences to say next time", .count(2))
    var phrases: [Example]
    @Guide(description: """
        One grammar tip about the sentences: the German pattern, then „ + “, e.g. „allergisch gegen + accusative. …“
        """)
    var grammarTip: String
}

extension SentenceFeedback {
    init(_ generated: GeneratedFeedback) {
        let kind: Feedback.Kind = switch generated.kind {
        case .good: .good
        case .fix: .fix
        case .note: .note
        }
        let correction = generated.correction.trimmingCharacters(in: .whitespacesAndNewlines)
        self.init(feedback: Feedback(kind: kind, title: generated.title, note: generated.note,
                                     correction: kind == .fix && !correction.isEmpty ? correction : nil),
                  english: generated.english)
    }
}

extension Debrief {
    /// The model's phrases and tip for `moment`, saved to the moment's phrasebook place.
    init(_ generated: GeneratedDebrief, for moment: Debrief) {
        self.init(event: moment.event, time: moment.time, sampleInput: moment.sampleInput,
                  phrases: generated.phrases.map { Example(german: $0.german, english: $0.english) },
                  grammarTip: generated.grammarTip,
                  phrasebookPlace: moment.phrasebookPlace, phrasebookSymbol: moment.phrasebookSymbol)
    }
}
