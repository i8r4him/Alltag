//
//  RealtimeConversationService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

struct RealtimeConversationContext {
    let scenario: String
    let instructions: String
    let slowerSpeech: Bool

    init(scenario: Scenario, level: Level, slowerSpeech: Bool) {
        self.scenario = scenario.id.rawValue
        self.instructions = """
            Scenario: \(scenario.title)
            Goal: \(scenario.goal)
            Learner's German level (CEFR): \(level.rawValue.uppercased())
            Start by greeting the learner in character and inviting them to speak.
            """
        self.slowerSpeech = slowerSpeech
    }
}

enum RealtimeConversationEvent {
    case phase(VoiceOrbState)
    case transcript(id: String, speaker: ConversationLine.Speaker, text: String, replacesPrevious: Bool)
    case discardTranscript(id: String)
}

protocol RealtimeConversationService {
    func makeSession(for context: RealtimeConversationContext) -> any RealtimeConversationSession
}

protocol RealtimeConversationSession: AnyObject {
    func run(emit: @escaping (RealtimeConversationEvent) -> Void) async throws
    func stop()
}

struct MockRealtimeConversationService: RealtimeConversationService {
    func makeSession(for context: RealtimeConversationContext) -> any RealtimeConversationSession {
        UnavailableSession()
    }

    private final class UnavailableSession: RealtimeConversationSession {
        func run(emit: @escaping (RealtimeConversationEvent) -> Void) async throws {
            throw RealtimeServiceError.unavailable
        }

        func stop() {}
    }
}
