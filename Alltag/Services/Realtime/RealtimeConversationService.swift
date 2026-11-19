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
    /// How long the learner may stay silent, in milliseconds, before the
    /// companion answers. Beginners get more time to find their words.
    let thinkingPause: Int
    /// No script to fall back to (free talk and situations).
    let isLiveOnly: Bool
    /// Hold to talk: the companion answers when the learner lets go, not after a pause.
    var holdsToTalk = false
    /// What was said before, when the live voice reconnects in the middle of a conversation.
    var history = ""

    init(scenario: Scenario, level: Level, slowerSpeech: Bool) {
        self.scenario = scenario.id.rawValue
        self.instructions = scenario.isFreeTalk ? """
            Free conversation, no role-play and no situation: talk like a friendly friend \
            about anything the learner wants, such as their day, plans or interests.
            Ask one short question at a time and let the learner do most of the talking.
            When the learner makes a mistake, keep talking and use the correct form naturally in your reply.
            Learner's German level (CEFR): \(level.rawValue.uppercased())
            Start with a short, warm greeting and ask how their day is going.
            """ : scenario.id == .situation ? """
            Role-play an everyday situation in Germany: \(scenario.title).
            You play \(scenario.role). Stay in that role and speak as that person really would.
            The learner wants to \(scenario.aim). Don't do it for them: ask, react and let them get there.
            When they have got it done, close the conversation naturally, the way that person would.
            Learner's German level (CEFR): \(level.rawValue.uppercased())
            Start by greeting the learner in character.
            """ : """
            Scenario: \(scenario.title)
            Goal: \(scenario.goal)
            Learner's German level (CEFR): \(level.rawValue.uppercased())
            Start by greeting the learner in character and inviting them to speak.
            """
        self.slowerSpeech = slowerSpeech
        self.isLiveOnly = scenario.isLiveOnly
        self.thinkingPause = Self.thinkingPause(for: level)
    }

    static func thinkingPause(for level: Level) -> Int {
        switch level {
        case .a1: 2800
        case .a2: 2400
        case .b1: 2000
        case .b2: 1600
        case .c1, .c2: 1200
        }
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
    /// Hold to talk: the learner pressed the orb and starts talking.
    func beginTurn()
    /// Hold to talk: the learner let go; the companion answers.
    func endTurn()
}

extension RealtimeConversationSession {
    func beginTurn() {}
    func endTurn() {}
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
        context.isLiveOnly ? FreeTalkSession(holdsToTalk: context.holdsToTalk) : MockRealtimeConversationService().makeSession(for: context)
    }

    private final class FreeTalkSession: RealtimeConversationSession {
        private let holdsToTalk: Bool
        private var isStopped = false
        private var emit: ((RealtimeConversationEvent) -> Void)?
        /// Hold to talk: the made-up learner talking while the orb is held, and the reply after.
        private var talking: Task<Void, Never>?
        private var reply: Task<Void, Never>?
        private var turns = 0

        init(holdsToTalk: Bool) {
            self.holdsToTalk = holdsToTalk
        }

        func run(emit: @escaping (RealtimeConversationEvent) -> Void) async throws {
            if holdsToTalk {
                self.emit = emit
                try await say(.companion, "Hallo! Wie geht's dir heute?", id: "simulated-0", emit: emit)
                emit(.phase(.idle))
            } else {
                let lines: [(ConversationLine.Speaker, String)] = [
                    (.companion, "Hallo! Wie geht's dir heute?"),
                    (.learner, "Gut, ich war heute in die Stadt."),
                    (.companion, "Schön! Du warst heute in der Stadt? Was hast du dort gemacht?")
                ]
                for (index, line) in lines.enumerated() {
                    try await say(line.0, line.1, id: "simulated-\(index)", emit: emit)
                    if line.0 == .learner { emit(.phase(.thinking)); try await Task.sleep(for: .seconds(1)) }
                    guard !isStopped else { return }
                }
                emit(.phase(.listening))
            }
            while !isStopped { try await Task.sleep(for: .milliseconds(200)) }
        }

        func stop() {
            isStopped = true
            talking?.cancel()
            reply?.cancel()
        }

        func beginTurn() {
            guard holdsToTalk, !isStopped, talking == nil, let emit else { return }
            reply?.cancel()
            emit(.phase(.listening))
            talking = Task { [weak self] in try? await self?.pulse(.learner, for: .seconds(60)) }
        }

        func endTurn() {
            guard let emit, let talking else { return }
            talking.cancel()
            self.talking = nil
            turns += 1
            let turn = turns
            emit(.transcript(id: "simulated-learner-\(turn)", speaker: .learner,
                             text: "Gut, ich war heute in der Stadt.", replacesPrevious: true))
            emit(.phase(.thinking))
            reply = Task { [weak self] in
                do {
                    try await Task.sleep(for: .seconds(1))
                    try await self?.say(.companion, "Schön! Was hast du dort gemacht?", id: "simulated-reply-\(turn)", emit: emit)
                    emit(.phase(.idle))
                } catch {
                    return
                }
            }
        }

        private func say(_ speaker: ConversationLine.Speaker, _ text: String, id: String,
                         emit: (RealtimeConversationEvent) -> Void) async throws {
            emit(.phase(speaker == .companion ? .speaking : .listening))
            emit(.transcript(id: id, speaker: speaker, text: text, replacesPrevious: true))
            try await pulse(speaker == .companion ? .companion : .learner, for: .seconds(2))
        }

        /// Loudness for the orb, as if someone were talking: a pulse per syllable.
        private func pulse(_ source: VoiceMeter.Source, for duration: Duration) async throws {
            let end = ContinuousClock.now + duration
            while ContinuousClock.now < end, !isStopped {
                VoiceMeter.shared.record(.random(in: 0.45...0.95), from: source)
                try await Task.sleep(for: .milliseconds(Int.random(in: 140...240)))
            }
        }
    }
}
