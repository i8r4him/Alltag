//
//  ActivityModelTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Activity model")
@MainActor
struct ActivityModelTests {
    let voice = MockVoiceService()

    func makeModel(_ activity: Activity? = nil) -> ActivityModel {
        let services = AppServices(
            speech: MockSpeechService(),
            voice: voice,
            translation: MockTranslationService(delay: .zero),
            companion: MockCompanionService(thinkingTime: .zero),
            calendar: MockCalendarService(),
            notifications: MockNotificationService()
        )
        return ActivityModel(activity: activity ?? MockActivities.mistakes, services: services)
    }

    @Test("A right answer scores; the right option turns green and the rest fade")
    func rightAnswer() {
        let model = makeModel()
        #expect(model.pick(0) == true)
        #expect(model.score == 1)
        #expect(model.state(ofOption: 0) == .right)
        #expect(model.state(ofOption: 1) == .dimmed)
        #expect(model.state(ofOption: 2) == .dimmed)
    }

    @Test("A wrong answer doesn't score; it turns coral and the right one is shown")
    func wrongAnswer() {
        let model = makeModel()
        #expect(model.pick(2) == false)
        #expect(model.score == 0)
        #expect(model.state(ofOption: 2) == .wrong)
        #expect(model.state(ofOption: 0) == .right)
        #expect(model.state(ofOption: 1) == .dimmed)
    }

    @Test("Only the first pick counts")
    func pickOnce() {
        let model = makeModel()
        model.pick(2)
        #expect(model.pick(0) == nil)
        #expect(model.score == 0)
        #expect(model.picked == 2)
    }

    @Test("Continue needs a pick, then moves on and clears it")
    func next() {
        let model = makeModel()
        model.next()
        #expect(model.index == 0)

        model.pick(0)
        model.next()
        #expect(model.index == 1)
        #expect(!model.hasPicked)
        #expect(model.state(ofOption: 0) == .open)
    }

    @Test("Segments fill as questions are answered")
    func segments() {
        let model = makeModel()
        #expect(!model.isSegmentFilled(0))
        model.pick(0)
        #expect(model.isSegmentFilled(0))
        #expect(!model.isSegmentFilled(1))
        model.next()
        #expect(model.isSegmentFilled(0))
        #expect(!model.isSegmentFilled(1))
    }

    @Test("Every activity can be finished with all right answers", arguments: MockActivities.all)
    func finish(activity: Activity) {
        let model = makeModel(activity)
        for _ in activity.questions {
            model.pick(model.question.correctIndex)
            model.next()
        }
        #expect(model.isDone)
        #expect(model.score == activity.questions.count)
        #expect((0..<model.total).allSatisfy(model.isSegmentFilled))
        #expect(String(localized: model.doneTitle) == "\(activity.questions.count) of \(activity.questions.count). Nicely done.")
    }

    @Test("The listening activity plays its announcement")
    func audio() async {
        let model = makeModel(MockActivities.listen)
        await model.toggleAudio()
        #expect(voice.spoken.map(\.text) == [MockActivities.listen.audio])
        #expect(!model.isPlaying)
    }

    @Test("Activities without audio don't play anything")
    func noAudio() async {
        let model = makeModel(MockActivities.recall)
        await model.toggleAudio()
        #expect(voice.spoken.isEmpty)
    }
}
