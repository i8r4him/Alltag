//
//  MockContentTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

/// Checks that the sample content is internally consistent, so screens built
/// on it can't hit an impossible state.
@Suite("Mock content")
@MainActor
struct MockContentTests {
    @Test("Scenarios start with the companion, alternate speakers and give feedback on every learner line",
          arguments: MockScenarios.all)
    func scenarioScripts(scenario: Scenario) throws {
        let first = try #require(scenario.script.first)
        #expect(first.speaker == .companion)
        for (previous, next) in zip(scenario.script, scenario.script.dropFirst()) {
            #expect(previous.speaker != next.speaker)
        }
        for line in scenario.script where line.speaker == .learner {
            #expect(line.feedback != nil, "\(line.german)")
        }
        #expect(scenario.learnerTurns == 2)
    }

    // Situations come from the catalogue (`Situation.scenario`), not from this lookup.
    @Test("Every scenario ID has a scenario", arguments: Scenario.ID.allCases.filter { $0 != .situation })
    func scenarioLookup(id: Scenario.ID) {
        #expect(MockScenarios.scenario(id).id == id)
    }

    @Test("Activity answers point at a real option", arguments: MockActivities.all)
    func activityAnswers(activity: Activity) {
        #expect(!activity.questions.isEmpty)
        for question in activity.questions {
            #expect(question.options.indices.contains(question.correctIndex))
        }
    }

    @Test("Every grammar task can be solved with exactly its tiles", arguments: MockRules.all)
    func ruleTasksAreSolvable(rule: GrammarRule) {
        for answer in rule.taskAnswers {
            let solution = Self.permutations(of: rule.taskWords).first { $0.joined(separator: " ") == answer }
            #expect(solution != nil, "\(rule.id): \(answer)")
            if let solution { #expect(rule.isCorrect(solution)) }
        }
        #expect(!rule.isCorrect(rule.taskWords.reversed()) || rule.taskAnswers.contains(rule.taskWords.reversed().joined(separator: " ")))
    }

    @Test("Each level lists at least five topics, and rule links point at real rules", arguments: Level.selectable)
    func levelTopics(level: Level) {
        let topics = MockLevels.topics(for: level)
        #expect(topics.count >= 5)
        for ruleID in topics.compactMap(\.ruleID) {
            let rule = MockRules.rule(id: ruleID)
            #expect(rule?.level == level, "\(ruleID)")
        }
    }

    @Test("Every full rule is listed under its level", arguments: MockRules.all)
    func rulesAreListed(rule: GrammarRule) {
        #expect(MockLevels.topics(for: rule.level).contains { $0.ruleID == rule.id })
    }

    @Test("The neutral tone of a translation is the translation itself", arguments: MockTranslations.all)
    func neutralTone(translation: TranslationResult) {
        let neutral = translation.tones.first { $0.tone == .neutral }
        #expect(neutral?.german == translation.german)
        #expect(translation.tones.map(\.tone) == TranslationResult.ToneVariant.Tone.allCases)
    }

    @Test("Translations are found by English or German text, ignoring case and punctuation")
    func translationLookup() {
        #expect(MockTranslations.match("can we move the appointment to tomorrow") == MockTranslations.moveAppointment)
        #expect(MockTranslations.match("Ich mache jetzt Feierabend") == MockTranslations.callingItADay)
        #expect(MockTranslations.match("Where is the station?") == nil)
    }

    @Test("Briefing words all appear in the transcript")
    func briefingWords() {
        let briefing = MockBriefing.briefing
        for word in briefing.words {
            #expect(briefing.transcript.contains(word), "\(word)")
        }
    }

    @Test("Placement answers map to A2, B1 and B2")
    func placement() {
        #expect(MockPlacement.question.answers.map(\.level) == [.a2, .b1, .b2])
    }

    @Test("Levels are ordered A1 to C2")
    func levelOrder() {
        #expect(Level.allCases.sorted() == Level.allCases)
        #expect(Level.a2 < Level.b1)
    }

    @Test("A profile stores its enums and reads them back")
    func profileRoundTrip() throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        let profile = UserProfile(name: "Mara", nativeLanguage: .arabic, goal: .work, level: .b1,
                                  dailyTime: .twenty, nudgeTime: .morning, interests: [.travel, .housing])
        container.mainContext.insert(profile)
        try container.mainContext.save()

        let fetched = try #require(try container.mainContext.fetch(FetchDescriptor<UserProfile>()).first)
        #expect(fetched.nativeLanguage == .arabic)
        #expect(fetched.goal == .work)
        #expect(fetched.level == .b1)
        #expect(fetched.dailyTime == .twenty)
        #expect(fetched.nudgeTime == .morning)
        #expect(fetched.interests == [.travel, .housing])
        #expect(fetched.interestsRaw == ["housing", "travel"])
    }

    private static func permutations(of words: [String]) -> [[String]] {
        guard words.count > 1 else { return [words] }
        return words.indices.flatMap { index in
            var rest = words
            let word = rest.remove(at: index)
            return permutations(of: rest).map { [word] + $0 }
        }
    }
}
