//
//  MistakePracticeTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

/// A companion whose own-sentence feedback is a fixed fix.
private final class FixingCompanion: CompanionService {
    let script = MockCompanionService(thinkingTime: .zero)
    var usesOnDeviceModel: Bool { true }
    func respond(to learnerText: String, in scenario: Scenario, turn: Int) async throws -> CompanionResponse {
        try await script.respond(to: learnerText, in: scenario, turn: turn)
    }
    func feedback(on sentence: String, in scenario: Scenario, replyingTo previous: String?) async throws -> SentenceFeedback {
        SentenceFeedback(feedback: Feedback(kind: .fix, title: "Verb second", note: "Time first, then the verb.",
                                            correction: "Morgen komme ich."),
                         english: "I'm coming tomorrow.")
    }
    func debrief(_ input: String, about moment: Debrief) async throws -> Debrief { moment }
}

@Suite("Learning from mistakes")
@MainActor
struct MistakePracticeTests {
    private func container() throws -> ModelContainer { try AlltagStore.makeContainer(inMemory: true) }

    private func model(companion: (any CompanionService)? = nil) -> ConversationModel {
        let mock = AppServices.mock()
        let services = AppServices(speech: MockSpeechService(wordInterval: .zero), voice: mock.voice,
                                   translation: mock.translation, companion: companion ?? MockCompanionService(thinkingTime: .zero),
                                   notifications: mock.notifications)
        return ConversationModel(scenario: MockScenarios.dentist, services: services, timing: .instant)
    }

    @Test("Every scripted fix has a correction")
    func scriptedCorrections() {
        let fixes = MockScenarios.all.flatMap(\.script).compactMap(\.feedback).filter { $0.kind == .fix }
        #expect(!fixes.isEmpty)
        #expect(fixes.allSatisfy { $0.correction != nil })
    }

    @Test("A finished conversation saves its fixes to Memory once")
    func savesFixes() async throws {
        let store = try container()
        let context = store.mainContext
        let model = model()
        for _ in 0..<2 {
            model.orbTapped()
            await model.waitForTurn()
        }
        #expect(model.fixCount == 1)
        #expect(model.saveMistakes(in: context) == 1)
        #expect(model.saveMistakes(in: context) == 0)

        let mistake = MemoryKind.mistake.rawValue
        let saved = try context.fetch(FetchDescriptor<MemoryItem>(predicate: #Predicate { $0.kindRaw == mistake }))
        #expect(saved.first?.mistakeOriginal == "Ich komme um 15 Uhr, wenn das passt mir.")
        #expect(saved.first?.word == "Ich komme um 15 Uhr, wenn es Ihnen passt.")
        #expect(saved.first?.sourceDetail == "At the dentist")
    }

    @Test("Your own sentence's fix is saved with its correction")
    func savesOwnFix() async throws {
        let store = try container()
        let context = store.mainContext
        let model = model(companion: FixingCompanion())
        model.draft = "Ich komme morgen."
        await model.send()
        #expect(model.saveMistakes(in: context) == 1)
    }

    @Test("A round asks about your saved mistakes, most overdue first")
    func practice() throws {
        let store = try container()
        let context = store.mainContext
        let now = Date(timeIntervalSince1970: 1_800_000_000)
        let feedback = Feedback(kind: .fix, title: "Dative after „auf“", note: "Where? → dative.",
                                correction: "Ich habe es auf meinem Handy.")
        let later = try #require(MistakePractice.item(said: "Ich habe es auf mein Handy.", feedback: feedback,
                                                      scenario: MockScenarios.postOffice, at: now))
        let sooner = try #require(MistakePractice.item(said: "Wann der Zug fährt ab?",
                                                       feedback: Feedback(kind: .fix, title: "Verb second", note: "",
                                                                          correction: "Wann fährt der Zug ab?"),
                                                       scenario: MockScenarios.station, at: now.addingTimeInterval(-60)))
        MistakePractice.save([later, sooner], in: context)

        let round = MistakeRoundModel(items: MistakePractice.round(in: context, at: now))
        #expect(round.questions.map(\.said) == ["Wann der Zug fährt ab?", "Ich habe es auf mein Handy."])
        #expect(round.questions.map(\.correction) == ["Wann fährt der Zug ab?", "Ich habe es auf meinem Handy."])
        #expect(round.questions[1].explanation == "Dative after „auf“. Where? → dative.")
    }

    @Test("Without saved mistakes there's nothing to ask")
    func noPractice() throws {
        let store = try container()
        #expect(MistakePractice.round(in: store.mainContext).isEmpty)
        #expect(MistakePractice.item(said: "Hallo", feedback: Feedback(kind: .good, title: "", note: ""),
                                     scenario: MockScenarios.dentist) == nil)
    }

    @Test("The wrong words of a sentence are the ones the correction doesn't have there")
    func wrongWords() {
        // A wrong word: only that word.
        #expect(MistakePractice.wrongWords(said: "Ich komme mit mein Freund.", correction: "Ich komme mit meinem Freund.") == [3])
        // Wrong word order: the words that had to move.
        let order = MistakePractice.wrongWords(said: "Am Wochenende ich gehe in den Park.",
                                               correction: "Am Wochenende gehe ich in den Park.")
        #expect(order.count == 1)
        #expect(order.isSubset(of: [2, 3]))
        // A missing word: nothing in what was said is wrong by itself.
        #expect(MistakePractice.wrongWords(said: "Ich gehe Kino.", correction: "Ich gehe ins Kino.").isEmpty)
        // Reworded altogether: nothing is marked.
        #expect(MistakePractice.wrongWords(said: "Ich will das machen jetzt sofort.", correction: "Das mache ich gleich.").isEmpty)
        // Capitals and punctuation don't count.
        #expect(MistakePractice.wrongWords(said: "ich wohne in berlin", correction: "Ich wohne in Berlin.").isEmpty)
    }

    @Test("A written fix counts when its words are the correction's")
    func writtenFix() {
        let correction = "Morgen komme ich."
        #expect(MistakePractice.isFixed("Morgen komme ich.", correction: correction))
        // Punctuation, spaces and the first word's case don't count.
        #expect(MistakePractice.isFixed("  morgen   komme ich", correction: correction))
        // The mistake itself, a missing word or an extra one don't.
        #expect(!MistakePractice.isFixed("Morgen ich komme.", correction: correction))
        #expect(!MistakePractice.isFixed("Morgen komme.", correction: correction))
        #expect(!MistakePractice.isFixed("Morgen komme ich gern.", correction: correction))
        #expect(!MistakePractice.isFixed("", correction: correction))
        // A noun keeps its capital after the first word.
        #expect(!MistakePractice.isFixed("Ich habe einen hund.", correction: "Ich habe einen Hund."))
    }
}
