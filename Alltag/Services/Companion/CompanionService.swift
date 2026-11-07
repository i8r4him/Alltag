//
//  CompanionService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The companion's answer to a learner turn.
struct CompanionResponse: Equatable, Sendable {
    /// Feedback on what the learner said.
    var feedback: Feedback?
    /// The companion's next line, or `nil` when the conversation is over.
    var reply: ConversationLine?
}

/// Feedback on a sentence the learner made up themselves, with its meaning.
struct SentenceFeedback: Equatable, Sendable {
    var feedback: Feedback
    /// What the learner's sentence means in English; empty when unknown.
    var english: String
}

/// The conversation partner: replies, corrections and debriefs.
protocol CompanionService: AnyObject {
    /// Whether answers come from the on-device language model right now,
    /// rather than from Alltag's built-in samples.
    var usesOnDeviceModel: Bool { get }
    /// Responds to the learner's line at `turn` (0-based index into the
    /// scenario's learner turns).
    func respond(to learnerText: String, in scenario: Scenario, turn: Int) async throws -> CompanionResponse
    /// Judges a sentence the learner said instead of the scripted one at `turn`.
    func feedback(on sentence: String, in scenario: Scenario, turn: Int) async throws -> SentenceFeedback
    /// Suggests how to say what the learner wanted to say during `moment`.
    func debrief(_ input: String, about moment: Debrief) async throws -> Debrief
}

/// Follows the scenario scripts and returns the prototype's debrief. Also the
/// fallback of the on-device companion when Apple Intelligence is unavailable.
final class MockCompanionService: CompanionService {
    private let thinkingTime: Duration

    init(thinkingTime: Duration = .milliseconds(900)) {
        self.thinkingTime = thinkingTime
    }

    var usesOnDeviceModel: Bool { false }

    func respond(to learnerText: String, in scenario: Scenario, turn: Int) async throws -> CompanionResponse {
        try await Task.sleep(for: thinkingTime)
        let learnerIndices = scenario.script.indices.filter { scenario.script[$0].speaker == .learner }
        guard learnerIndices.indices.contains(turn) else { return CompanionResponse() }

        let index = learnerIndices[turn]
        let next = scenario.script.index(after: index)
        let reply = scenario.script.indices.contains(next) && scenario.script[next].speaker == .companion
            ? scenario.script[next] : nil
        return CompanionResponse(feedback: scenario.script[index].feedback, reply: reply)
    }

    func feedback(on sentence: String, in scenario: Scenario, turn: Int) async throws -> SentenceFeedback {
        SentenceFeedback(feedback: Self.ownSentenceNote, english: "")
    }

    func debrief(_ input: String, about moment: Debrief) async throws -> Debrief {
        try await Task.sleep(for: thinkingTime)
        return MockDebrief.bakery
    }

    /// Without the on-device model, Alltag can't judge free sentences.
    static let ownSentenceNote = Feedback(
        kind: .note,
        title: String(localized: "Your own sentence"),
        note: String(localized: "Turn on Apple Intelligence to get feedback on sentences you make up yourself.")
    )
}
