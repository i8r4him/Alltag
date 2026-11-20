//
//  SixtySecondsTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 12.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

@MainActor
struct SixtySecondsTests {
    @Test("Every level from A1 to C1 has its own 50 topics", arguments: [Level.a1, .a2, .b1, .b2, .c1])
    func topicsByLevel(level: Level) {
        let topics = TalkTopics.topics(for: level)
        #expect(topics.count == 50)
        #expect(topics.allSatisfy { $0.level == level })
        #expect(Set(topics.map(\.title)).count == 50)
        #expect(topics.allSatisfy { !$0.title.isEmpty && $0.question.hasSuffix("?") })
    }

    @Test("No topic appears at two levels, and C2 talks about C1's topics")
    func topicsAreDistinct() {
        #expect(TalkTopics.all.count == 250)
        #expect(Set(TalkTopics.all.map(\.id)).count == 250)
        #expect(Set(TalkTopics.all.map(\.title)).count == 250)
        #expect(TalkTopics.topics(for: .c2) == TalkTopics.topics(for: .c1))
    }

    @Test("Another topic is never the same one again")
    func anotherTopic() {
        var generator = SystemRandomNumberGenerator()
        let first = TalkTopics.a1[0]
        for _ in 0..<20 {
            #expect(TalkTopics.random(for: .a1, not: first, using: &generator) != first)
        }
    }

    @Test("The transcript is cut into sentences")
    func sentences() {
        let text = "Ich wohne in Berlin. Am Wochenende ich gehe oft in den Park! Und du?"
        #expect(SixtySecondsModel.sentences(in: text) == [
            "Ich wohne in Berlin.", "Am Wochenende ich gehe oft in den Park!", "Und du?"
        ])
        #expect(SixtySecondsModel.sentences(in: "  ").isEmpty)
    }

    @Test("A minute of talking ends with every sentence checked, and the fixes saved once")
    func talking() async throws {
        let companion = FixingCompanion()
        let model = makeModel(companion: companion)
        #expect(model.phase == .picking)
        model.start()
        #expect(model.phase == .picking)

        model.topicChosen()
        model.start()
        #expect(model.phase == .talking)
        await model.waitUntilDone()

        #expect(model.phase == .done)
        #expect(model.lines.count == 4)
        #expect(model.fixCount == 4)
        // Each sentence is asked about once, although most were queued while talking.
        #expect(companion.heard.sorted() == model.lines.map(\.german).sorted())

        let container = try AlltagStore.makeContainer(inMemory: true)
        model.save(in: container.mainContext)
        model.save(in: container.mainContext)
        let sessions = try container.mainContext.fetch(FetchDescriptor<PracticeSession>())
        #expect(sessions.map(\.kind) == [.sixtySeconds])
        let mistakes = try container.mainContext.fetch(FetchDescriptor<MemoryItem>()).filter { $0.kind == .mistake }
        #expect(mistakes.count == 4)
        #expect(mistakes.allSatisfy { $0.sourceDetail.contains(model.topic.title) })
        // One copy to reread, with every sentence and its fix. The simulated speech records nothing.
        let records = try container.mainContext.fetch(FetchDescriptor<SessionRecord>())
        #expect(records.count == 1)
        #expect(records.first?.kind == .sixtySeconds)
        #expect(records.first?.title.contains(model.topic.title) == true)
        #expect(records.first?.lines.map(\.german) == model.lines.map(\.german))
        #expect(records.first?.fixCount == 4)
        #expect(records.first?.audioFileName.isEmpty == true)
    }

    @Test("While the recogniser rewords what it heard, only settled sentences are checked")
    func rewording() async {
        let companion = FixingCompanion()
        // The first sentence changes three times before it settles; the last is only complete at the end.
        let speech = ScriptedSpeech(updates: [
            "Ich wohne",
            "Ich wohne seit zwei. Am",
            "Ich wohne seit zwei Jahren. Am Wochenende",
            "Ich wohne seit zwei Jahren in Berlin. Am Wochenende ich",
            "Ich wohne seit zwei Jahren in Berlin. Am Wochenende ich gehe",
            "Ich wohne seit zwei Jahren in Berlin. Am Wochenende ich gehe in den Park."
        ])
        let model = makeModel(companion: companion, speech: speech)
        model.topicChosen()
        model.start()
        await model.waitUntilDone()

        #expect(model.phase == .done)
        #expect(!model.isChecking)
        #expect(model.lines.map(\.german) == ["Ich wohne seit zwei Jahren in Berlin.", "Am Wochenende ich gehe in den Park."])
        #expect(companion.heard.sorted() == model.lines.map(\.german).sorted())
        #expect(model.fixCount == 2)
    }

    @Test("Checking that takes too long is given up, and the sentences stay")
    func checkingIsCapped() async {
        let model = makeModel(companion: SlowCompanion(), checkLimit: .milliseconds(50))
        model.topicChosen()
        model.start()
        await model.waitUntilDone()

        #expect(model.phase == .done)
        #expect(!model.isChecking)
        #expect(model.lines.count == 4)
    }

    @Test("Without Apple Intelligence the sentences are shown without fixes")
    func withoutChecking() async {
        let model = makeModel(companion: MockCompanionService(thinkingTime: .zero))
        model.topicChosen()
        model.start()
        await model.waitUntilDone()

        #expect(model.phase == .done)
        #expect(!model.canCheck)
        #expect(model.lines.count == 4)
        #expect(model.fixCount == 0)
    }

    @Test("Another topic runs the reel again with a different topic")
    func pickAnother() {
        let model = makeModel(companion: MockCompanionService(thinkingTime: .zero))
        let first = model.topic
        model.pickAnother()
        #expect(model.topic == first)

        model.topicChosen()
        model.pickAnother()
        #expect(model.phase == .picking)
        #expect(model.topic != first)
        #expect(model.reelTitles.last == model.topic.title)
    }

    private func makeModel(companion: any CompanionService, speech: (any SpeechService)? = nil,
                           checkLimit: Duration = .seconds(45)) -> SixtySecondsModel {
        let services = AppServices(
            speech: speech ?? MockSpeechService(wordInterval: .zero),
            voice: MockVoiceService(),
            translation: MockTranslationService(delay: .zero),
            companion: companion,
            notifications: MockNotificationService(),
            realtime: MockRealtimeConversationService()
        )
        let timing = SixtySecondsModel.Timing(seconds: 60, tick: .seconds(60), checkLimit: checkLimit)
        return SixtySecondsModel(services: services, level: .a2, timing: timing)
    }
}

/// An on-device companion that finds a fix in every sentence.
private final class FixingCompanion: CompanionService {
    private(set) var heard: [String] = []
    var usesOnDeviceModel: Bool { true }

    func respond(to learnerText: String, in scenario: Scenario, turn: Int) async throws -> CompanionResponse {
        CompanionResponse()
    }

    func feedback(on sentence: String, in scenario: Scenario, replyingTo previous: String?) async throws -> SentenceFeedback {
        heard.append(sentence)
        return SentenceFeedback(feedback: Feedback(kind: .fix, title: "Verb second", note: "Better: \(sentence)",
                                                   correction: "Besser: \(sentence)"), english: "")
    }

    func debrief(_ input: String, about moment: Debrief) async throws -> Debrief { moment }
}

/// A companion that never answers in time; it stops when the check is cancelled.
private final class SlowCompanion: CompanionService {
    var usesOnDeviceModel: Bool { true }

    func respond(to learnerText: String, in scenario: Scenario, turn: Int) async throws -> CompanionResponse {
        CompanionResponse()
    }

    func feedback(on sentence: String, in scenario: Scenario, replyingTo previous: String?) async throws -> SentenceFeedback {
        try await Task.sleep(for: .seconds(30))
        return SentenceFeedback(feedback: MockCompanionService.ownSentenceNote, english: "")
    }

    func debrief(_ input: String, about moment: Debrief) async throws -> Debrief { moment }
}

/// Speech that yields a fixed series of transcripts, like a recogniser revising itself.
private final class ScriptedSpeech: SpeechService {
    let updates: [String]
    var authorizationStatus: PermissionStatus { .granted }

    init(updates: [String]) {
        self.updates = updates
    }

    func requestAuthorization() async -> PermissionStatus { .granted }

    func listen(expected: String, recordingTo recording: URL?) -> AsyncThrowingStream<String, any Error> {
        AsyncThrowingStream { continuation in
            for update in updates { continuation.yield(update) }
            continuation.finish()
        }
    }

    func stopListening() {}
}
