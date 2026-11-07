//
//  RealtimeConversationTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
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

    private func makeModel(realtime: StubRealtimeService, allowed: Bool = true, limit: Duration = .seconds(600)) -> ConversationModel {
        let services = AppServices(
            speech: MockSpeechService(wordInterval: .zero),
            voice: MockVoiceService(),
            translation: MockTranslationService(delay: .zero),
            companion: MockCompanionService(thinkingTime: .zero),
            calendar: MockCalendarService(),
            notifications: MockNotificationService(),
            realtime: realtime
        )
        let timing = ConversationModel.Timing(afterListening: .zero, beforeFinish: .zero, realtimeLimit: limit)
        return ConversationModel(scenario: MockScenarios.dentist, services: services, timing: timing, usesCloudVoice: allowed)
    }
}

@MainActor
private final class StubRealtimeService: RealtimeConversationService {
    let session: StubConversationSession
    private(set) var starts = 0

    init(error: RealtimeServiceError? = nil) {
        session = StubConversationSession(error: error)
    }

    func makeSession(for context: RealtimeConversationContext) -> any RealtimeConversationSession {
        starts += 1
        return session
    }
}

@MainActor
private final class StubConversationSession: RealtimeConversationSession {
    let error: RealtimeServiceError?
    private(set) var stops = 0
    private(set) var emit: ((RealtimeConversationEvent) -> Void)?
    private var finished: CheckedContinuation<Void, Never>?
    private var started: CheckedContinuation<Void, Never>?

    init(error: RealtimeServiceError?) {
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
