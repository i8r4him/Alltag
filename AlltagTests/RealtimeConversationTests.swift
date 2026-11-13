//
//  RealtimeConversationTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

@Suite("Live conversation model", .timeLimit(.minutes(1)))
@MainActor
struct RealtimeConversationTests {
    @Test("Cloud opt-out uses the scripted flow without creating a live session")
    func cloudOff() async {
        let realtime = StubRealtimeService()
        let model = makeModel(realtime: realtime, allowed: false)

        model.orbTapped()
        await model.waitForTurn()

        #expect(realtime.starts == 0)
        #expect(model.messages.map(\.line.german) == MockScenarios.dentist.script.prefix(3).map(\.german))
    }

    @Test("Live errors show a notice and return to scripted practice", arguments: [
        RealtimeServiceError.dailyLimit, .busy, .upstream, .unauthorised, .notConfigured, .unavailable
    ])
    func fallback(error: RealtimeServiceError) async throws {
        let realtime = StubRealtimeService(error: error)
        let model = makeModel(realtime: realtime)

        model.orbTapped()
        await model.waitForCloudConversation()

        #expect(!model.isUsingCloudVoice)
        #expect(realtime.session.stops == 1)
        let message = String(localized: try #require(model.notice?.text))
        switch error {
        case .dailyLimit: #expect(message.contains("limit"))
        case .busy: #expect(message.contains("busy"))
        default: #expect(message.contains("unavailable"))
        }
        model.orbTapped()
        await model.waitForTurn()
        #expect(realtime.starts == 1)
        #expect(model.turnCount == 1)
    }

    @Test("Closing, switching to keyboard, or withdrawing consent stops a live session",
          arguments: ["close", "keyboard", "consent", "background"])
    func close(action: String) async {
        let realtime = StubRealtimeService()
        let model = makeModel(realtime: realtime)
        model.orbTapped()

        switch action {
        case "close": model.stop()
        case "keyboard": model.mode = .text
        case "consent": model.setCloudVoiceConsent(false)
        default: model.suspendCloudVoice()
        }

        #expect(realtime.session.stops == 1)
        #expect(!model.isUsingCloudVoice)
        #expect(model.phase == .idle)
    }

    @Test("The deadline ends live voice and closes the session")
    func timeout() async {
        let realtime = StubRealtimeService()
        let model = makeModel(realtime: realtime, limit: .zero)

        model.orbTapped()
        await model.waitForCloudConversation()

        #expect(realtime.session.stops == 1)
        #expect(!model.isUsingCloudVoice)
        #expect(model.finishedLiveConversation)
        #expect(model.isFinished)
    }

    @Test("A late learner transcript fills its original place and retains the row identity")
    func transcripts() async throws {
        let realtime = StubRealtimeService()
        let model = makeModel(realtime: realtime)
        model.orbTapped()
        await realtime.session.waitUntilRunning()

        realtime.session.emit?(.transcript(id: "user", speaker: .learner, text: "", replacesPrevious: false))
        let learnerID = try #require(model.messages.first?.id)
        realtime.session.emit?(.transcript(id: "reply", speaker: .companion, text: "Ja, ", replacesPrevious: false))
        realtime.session.emit?(.transcript(id: "user", speaker: .learner, text: "Morgen?", replacesPrevious: true))
        realtime.session.emit?(.transcript(id: "reply", speaker: .companion, text: "Ja, gerne.", replacesPrevious: true))

        #expect(model.messages.map(\.line.german) == ["Morgen?", "Ja, gerne."])
        #expect(model.messages.first?.id == learnerID)
        #expect(model.turnCount == 1)
        model.orbTapped()
        #expect(realtime.session.stops == 1)
        #expect(model.finishedLiveConversation)
    }

    @Test("A finished live conversation is checked for mistakes on device")
    func review() async {
        let realtime = StubRealtimeService()
        let companion = ReviewingCompanion()
        let model = makeModel(realtime: realtime, companion: companion)
        model.orbTapped()
        await realtime.session.waitUntilRunning()
        realtime.session.emit?(.transcript(id: "ask", speaker: .companion, text: "Wann möchten Sie kommen?", replacesPrevious: true))
        realtime.session.emit?(.transcript(id: "say", speaker: .learner, text: "Ich komme morgen.", replacesPrevious: true))

        model.orbTapped()
        #expect(model.liveReview == .reviewing)
        await model.waitForReview()

        #expect(model.liveReview == .done)
        #expect(model.fixCount == 1)
        #expect(companion.heard == ["Ich komme morgen."])
        #expect(companion.previous == ["Wann möchten Sie kommen?"])
    }

    @Test("Lines are checked while the conversation goes on, and shown at the end")
    func reviewDuringConversation() async {
        let realtime = StubRealtimeService()
        let companion = ReviewingCompanion()
        let model = makeModel(realtime: realtime, companion: companion)
        model.orbTapped()
        await realtime.session.waitUntilRunning()
        realtime.session.emit?(.transcript(id: "say", speaker: .learner, text: "Ich komme", replacesPrevious: false))
        #expect(companion.heard.isEmpty)
        realtime.session.emit?(.transcript(id: "say", speaker: .learner, text: "Ich komme morgen.", replacesPrevious: true))
        realtime.session.emit?(.transcript(id: "yes", speaker: .learner, text: "Ja, gerne.", replacesPrevious: true))
        await model.waitForReview()

        // Checked already, but nothing is shown while they are still talking.
        #expect(companion.heard == ["Ich komme morgen."])
        #expect(model.fixCount == 0)

        model.orbTapped()
        #expect(model.liveReview == .done)
        #expect(model.fixCount == 1)
        #expect(companion.heard == ["Ich komme morgen."])
    }

    @Test("Without Apple Intelligence a live conversation isn't checked")
    func noReview() async {
        let realtime = StubRealtimeService()
        let model = makeModel(realtime: realtime)
        model.orbTapped()
        await realtime.session.waitUntilRunning()
        realtime.session.emit?(.transcript(id: "say", speaker: .learner, text: "Ich komme morgen.", replacesPrevious: true))
        model.orbTapped()
        #expect(model.liveReview == .none)
        #expect(model.fixCount == 0)
    }

    @Test("Free talk without consent asks first and starts nothing")
    func freeTalkNeedsConsent() {
        let realtime = StubRealtimeService()
        let model = makeModel(realtime: realtime, allowed: false, scenario: MockScenarios.freeTalk)

        #expect(model.needsCloudConsent)
        #expect(!model.canRespond)
        model.orbTapped()
        #expect(realtime.starts == 0)
    }

    @Test("Free talk starts the live voice with free-conversation instructions")
    func freeTalkStarts() async throws {
        let realtime = StubRealtimeService()
        let model = makeModel(realtime: realtime, scenario: MockScenarios.freeTalk)

        #expect(!model.needsCloudConsent)
        #expect(model.canRespond)
        model.orbTapped()
        await realtime.session.waitUntilRunning()

        #expect(model.isUsingCloudVoice)
        // No placeholder greeting: the first line is the live voice's own.
        #expect(model.messages.isEmpty)
        #expect(String(localized: try #require(model.stateLabel)) == "Connecting…")
        let emit = try #require(realtime.session.emit)
        emit(.transcript(id: "hello", speaker: .companion, text: "Hallo!", replacesPrevious: true))
        #expect(model.messages.map(\.line.german) == ["Hallo!"])
        #expect(String(localized: try #require(model.stateLabel)) != "Connecting…")
        #expect(realtime.context?.scenario == "freeTalk")
        #expect(realtime.context?.instructions.contains("Free conversation") == true)
        model.stop()
    }

    @Test("Free talk that can't start says why, and Try again starts it again")
    func freeTalkRetries() async {
        let realtime = StubRealtimeService(error: RealtimeServiceError.upstream)
        let model = makeModel(realtime: realtime, scenario: MockScenarios.freeTalk)

        model.orbTapped()
        await model.waitForCloudConversation()
        #expect(model.problem == .unavailable)
        #expect(model.notice == nil)

        model.retryLive()
        #expect(model.problem == nil)
        await model.waitForCloudConversation()
        #expect(realtime.starts == 2)
    }

    @Test("Each reason free talk can't start gets its own screen")
    func freeTalkProblems() async {
        let cases: [(any Error, LiveProblem)] = [
            (RealtimeServiceError.dailyLimit, .limit),
            (RealtimeServiceError.microphoneDenied, .microphone),
            (RealtimeServiceError.busy, .busy),
            (RealtimeServiceError.unavailable, .unavailable),
            (URLError(.notConnectedToInternet), .offline),
            (URLError(.timedOut), .offline)
        ]
        for (error, problem) in cases {
            let model = makeModel(realtime: StubRealtimeService(error: error), scenario: MockScenarios.freeTalk)
            model.orbTapped()
            await model.waitForCloudConversation()

            #expect(model.problem == problem)
            #expect(model.notice == nil)
            #expect(!model.isUsingCloudVoice)
        }
    }

    @Test("A role-play with a script keeps going on the iPhone instead")
    func scriptedHasNoProblemScreen() async {
        let model = makeModel(realtime: StubRealtimeService(error: URLError(.notConnectedToInternet)))
        model.orbTapped()
        await model.waitForCloudConversation()

        #expect(model.problem == nil)
        #expect(model.notice != nil)
    }

    @Test("When the learner talks over the companion, its line stays and ends in …")
    func interruptedLine() async throws {
        let realtime = StubRealtimeService()
        let model = makeModel(realtime: realtime, scenario: MockScenarios.freeTalk)
        model.orbTapped()
        await realtime.session.waitUntilRunning()
        let emit = try #require(realtime.session.emit)

        emit(.transcript(id: "cut", speaker: .companion, text: "Was hast du heute", replacesPrevious: true))
        emit(.interruptTranscript(id: "cut"))
        emit(.transcript(id: "whole", speaker: .companion, text: "Schön!", replacesPrevious: true))
        emit(.interruptTranscript(id: "whole"))

        #expect(model.messages.map(\.line.german) == ["Was hast du heute…", "Schön!"])
        model.stop()
    }

    @Test("A conversation is saved as practice once, and only when the learner spoke")
    func recordsPractice() async throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        let realtime = StubRealtimeService()
        let model = makeModel(realtime: realtime, scenario: MockScenarios.freeTalk)
        model.orbTapped()
        await realtime.session.waitUntilRunning()
        let emit = try #require(realtime.session.emit)

        model.recordPractice(in: container.mainContext)
        #expect(try container.mainContext.fetchCount(FetchDescriptor<PracticeSession>()) == 0)

        emit(.transcript(id: "me", speaker: .learner, text: "Mir geht's gut.", replacesPrevious: true))
        model.stop()
        model.recordPractice(in: container.mainContext, now: .now.addingTimeInterval(90))
        model.recordPractice(in: container.mainContext)

        let sessions = try container.mainContext.fetch(FetchDescriptor<PracticeSession>())
        #expect(sessions.map(\.kind) == [.conversation])
        // And one copy to reread from Learn, with what was said.
        let records = try container.mainContext.fetch(FetchDescriptor<SessionRecord>())
        #expect(records.map(\.title) == [MockScenarios.freeTalk.title])
        #expect(records.first?.lines.map(\.german) == ["Mir geht's gut."])
        #expect(records.first?.lines.first?.isLearner == true)
    }

    private func makeModel(realtime: StubRealtimeService, allowed: Bool = true, limit: Duration = .seconds(600),
                           companion: (any CompanionService)? = nil,
                           scenario: Scenario = MockScenarios.dentist) -> ConversationModel {
        let services = AppServices(
            speech: MockSpeechService(wordInterval: .zero),
            voice: MockVoiceService(),
            translation: MockTranslationService(delay: .zero),
            companion: companion ?? MockCompanionService(thinkingTime: .zero),
            calendar: MockCalendarService(),
            notifications: MockNotificationService(),
            realtime: realtime
        )
        let timing = ConversationModel.Timing(afterListening: .zero, beforeFinish: .zero, realtimeLimit: limit)
        return ConversationModel(scenario: scenario, services: services, timing: timing, usesCloudVoice: allowed)
    }
}

/// An on-device companion that finds one fix in every sentence and remembers what it was asked.
private final class ReviewingCompanion: CompanionService {
    private(set) var heard: [String] = []
    private(set) var previous: [String?] = []
    var usesOnDeviceModel: Bool { true }
    func respond(to learnerText: String, in scenario: Scenario, turn: Int) async throws -> CompanionResponse {
        CompanionResponse()
    }
    func feedback(on sentence: String, in scenario: Scenario, replyingTo previous: String?) async throws -> SentenceFeedback {
        heard.append(sentence)
        self.previous.append(previous)
        return SentenceFeedback(feedback: Feedback(kind: .fix, title: "Time first", note: "Morgen komme ich.",
                                                   correction: "Morgen komme ich."), english: "I'm coming tomorrow.")
    }
    func debrief(_ input: String, about moment: Debrief) async throws -> Debrief { moment }
}

@MainActor
private final class StubRealtimeService: RealtimeConversationService {
    let session: StubConversationSession
    private(set) var starts = 0
    private(set) var context: RealtimeConversationContext?

    init(error: (any Error)? = nil) {
        session = StubConversationSession(error: error)
    }

    func makeSession(for context: RealtimeConversationContext) -> any RealtimeConversationSession {
        starts += 1
        self.context = context
        return session
    }
}

@MainActor
private final class StubConversationSession: RealtimeConversationSession {
    let error: (any Error)?
    private(set) var stops = 0
    private(set) var emit: ((RealtimeConversationEvent) -> Void)?
    private var finished: CheckedContinuation<Void, Never>?
    private var started: CheckedContinuation<Void, Never>?

    init(error: (any Error)?) {
        self.error = error
    }

    func run(emit: @escaping (RealtimeConversationEvent) -> Void) async throws {
        if let error { throw error }
        if stops > 0 { return }
        self.emit = emit
        await withCheckedContinuation { continuation in
            finished = continuation
            started?.resume()
            started = nil
        }
    }

    func waitUntilRunning() async {
        if finished != nil { return }
        await withCheckedContinuation { started = $0 }
    }

    func stop() {
        stops += 1
        finished?.resume()
        finished = nil
        emit = nil
    }
}
