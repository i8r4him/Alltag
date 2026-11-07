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

/// The conversation partner: replies, corrections and debriefs.
protocol CompanionService: AnyObject {
    /// Responds to the learner's line at `turn` (0-based index into the
    /// scenario's learner turns).
    func respond(to learnerText: String, in scenario: Scenario, turn: Int) async throws -> CompanionResponse
    /// Suggests how to say what the learner wanted to say.
    func debrief(_ input: String) async throws -> Debrief
}

/// Follows the scenario scripts and returns the prototype's debrief. The live
/// companion uses on-device Foundation Models (#49).
final class MockCompanionService: CompanionService {
    private let thinkingTime: Duration

    init(thinkingTime: Duration = .milliseconds(900)) {
        self.thinkingTime = thinkingTime
    }

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

    func debrief(_ input: String) async throws -> Debrief {
        try await Task.sleep(for: thinkingTime)
        return MockDebrief.bakery
    }
}
