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
        self.instructions = scenario.isFreeTalk ? """
            Free conversation, no role-play and no situation: talk like a friendly friend \
            about anything the learner wants, such as their day, plans or interests.
            Ask one short question at a time and let the learner do most of the talking.
            When the learner makes a mistake, keep talking and use the correct form naturally in your reply.
            Learner's German level (CEFR): \(level.rawValue.uppercased())
            Start with a short, warm greeting and ask how their day is going.
            """ : """
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
    /// The learner started talking over the companion: its line stops here
    /// and stays on screen, marked as cut off.
    case interruptTranscript(id: String)
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

/// The simulator can't use the microphone with the live voice, so free talk
/// plays a short made-up exchange there to show the screen. Role-plays stay
/// unavailable, so they keep their script.
struct SimulatedRealtimeConversationService: RealtimeConversationService {
    func makeSession(for context: RealtimeConversationContext) -> any RealtimeConversationSession {
        context.scenario == Scenario.ID.freeTalk.rawValue ? FreeTalkSession() : MockRealtimeConversationService().makeSession(for: context)
    }

    private final class FreeTalkSession: RealtimeConversationSession {
        private var isStopped = false

        func run(emit: @escaping (RealtimeConversationEvent) -> Void) async throws {
            let lines: [(ConversationLine.Speaker, String)] = [
                (.companion, "Hallo! Wie geht's dir heute?"),
                (.learner, "Gut, ich war heute in die Stadt."),
                (.companion, "Schön! Du warst heute in der Stadt? Was hast du dort gemacht?")
            ]
            for (index, line) in lines.enumerated() {
                emit(.phase(line.0 == .companion ? .speaking : .listening))
                emit(.transcript(id: "simulated-\(index)", speaker: line.0, text: line.1, replacesPrevious: true))
                try await Task.sleep(for: .seconds(2))
                if line.0 == .learner { emit(.phase(.thinking)); try await Task.sleep(for: .seconds(1)) }
                guard !isStopped else { return }
            }
            emit(.phase(.listening))
            while !isStopped { try await Task.sleep(for: .milliseconds(200)) }
        }

        func stop() { isStopped = true }
    }
}
