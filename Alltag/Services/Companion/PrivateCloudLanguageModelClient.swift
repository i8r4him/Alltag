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

    /// Whether this build is signed with Apple's entitlement for the cloud model.
    ///
    /// **Off until Apple has assigned the entitlement to the developer account**
    /// (it needs the App Store Small Business Program). Without the entitlement in
    /// the signing profile, the model still reports itself available, and a request
    /// then stops the process instead of throwing. To switch it on, do both:
    /// 1. set `CODE_SIGN_ENTITLEMENTS = Alltag/Alltag.entitlements` for the app target
    ///    (Signing & Capabilities › + Capability does the same), and
    /// 2. set this to `true`.
    static let isEntitled = false

    /// Whether the model can take requests right now. The quota is separate:
    /// a model that is available can still refuse when the day's limit is used up.
    static var isAvailable: Bool {
        isEntitled && PrivateCloudComputeLanguageModel().availability == .available
    }

    func generate<Content: Generable>(_ type: Content.Type, instructions: String, prompt: String) async throws -> Content {
        let session = LanguageModelSession(model: PrivateCloudComputeLanguageModel(), instructions: instructions)
        return try await session.respond(to: prompt, generating: type,
                                         contextOptions: ContextOptions(reasoningLevel: reasoning)).content
    }
}
