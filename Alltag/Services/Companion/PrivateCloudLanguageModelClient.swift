//
//  PrivateCloudLanguageModelClient.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import Foundation
import FoundationModels

/// Apple's larger language model, running in Private Cloud Compute: one fresh
/// session per request, like the on-device client. It needs a network
/// connection, Apple Intelligence, and the learner's daily quota from Apple.
struct PrivateCloudLanguageModelClient: LanguageModelClient {
    /// Light reasoning: a correction or a translation needs a quick answer, not an essay.
    var reasoning: ContextOptions.ReasoningLevel = .light

    /// Whether the model can take requests right now. The quota is separate:
    /// a model that is available can still refuse when the day's limit is used up.
    static var isAvailable: Bool {
        PrivateCloudComputeLanguageModel().availability == .available
    }

    func generate<Content: Generable>(_ type: Content.Type, instructions: String, prompt: String) async throws -> Content {
        let session = LanguageModelSession(model: PrivateCloudComputeLanguageModel(), instructions: instructions)
        return try await session.respond(to: prompt, generating: type,
                                         contextOptions: ContextOptions(reasoningLevel: reasoning)).content
    }
}
