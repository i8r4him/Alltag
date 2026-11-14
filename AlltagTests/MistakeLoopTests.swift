//
//  MistakeLoopTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

@Suite("Fix your mistakes: the loop")
@MainActor
struct MistakeLoopTests {
    /// 14 Nov 2026, 15:00 in Berlin.
    let now = Date(timeIntervalSince1970: 1_794_664_800)
    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Europe/Berlin") ?? .gmt
        return calendar
    }

    func mistake(_ said: String, _ correction: String, strength: Int = 0, due: Date? = nil) -> MemoryItem {
        MemoryItem(word: correction, meaning: "Fix", context: correction, contextNote: "Why.", kind: .mistake,
                   source: .conversation, sourceDetail: "At the post office", mistakeOriginal: said,
                   strength: strength, nextReview: due ?? now, createdAt: now)
    }

    @Test("A right answer makes it stronger and sends it further away each time: 1, 3, 7, 14 days")
    func rightMovesFurther() {
        var strength = 0
        var days: [Int] = []
        for _ in 0..<MemoryItem.maxStrength {
            let step = ReviewSchedule.step(from: strength, wasRight: true, at: now, calendar: calendar)
            #expect(step.strength == strength + 1)
            days.append(ReviewSchedule.days(until: step.nextReview, from: now, calendar: calendar))
            strength = step.strength
        }
        #expect(days == [1, 3, 7, 14])
        #expect(strength == MemoryItem.maxStrength)
        // Already learned: it stays there.
        #expect(ReviewSchedule.step(from: strength, wasRight: true, at: now, calendar: calendar).strength == MemoryItem.maxStrength)
    }

    @Test("\"Tomorrow\" starts with the day, not 24 hours on")
    func nextDayStartsAtMidnight() {
        let step = ReviewSchedule.step(from: 0, wasRight: true, at: now, calendar: calendar)
        #expect(step.nextReview == calendar.startOfDay(for: now.addingTimeInterval(86_400)))
        #expect(!step.isLearned)
    }

    @Test("A wrong answer takes it a step back and brings it back at once")
    func wrongBringsBack() {
        let step = ReviewSchedule.step(from: 3, wasRight: false, at: now, calendar: calendar)
        #expect(step.strength == 2)
        #expect(step.nextReview == now)
        #expect(ReviewSchedule.step(from: 0, wasRight: false, at: now, calendar: calendar).strength == 0)
        #expect(ReviewSchedule.days(until: step.nextReview, from: now, calendar: calendar) == 0)
    }

    @Test("Only due mistakes that aren't learned are in the stack, and the count follows the answers")
    func stackFollows() throws {
        // Kept in a constant: the context doesn't keep its container alive.
        let store = try AlltagStore.makeContainer(inMemory: true)
        let context = store.mainContext
        let items = [
            mistake("Ich komme mit mein Freund.", "Ich komme mit meinem Freund."),
            mistake("der Wohnung", "die Wohnung", strength: MemoryItem.maxStrength - 1),
            mistake("Ich gehe Kino.", "Ich gehe ins Kino.", due: now.addingTimeInterval(3 * 86_400)),
            mistake("Wann der Zug fährt ab?", "Wann fährt der Zug ab?", strength: MemoryItem.maxStrength,
                    due: now.addingTimeInterval(-86_400))
        ]
        items.forEach(context.insert)
        let all = try context.fetch(MistakePractice.practisable)
        #expect(MistakePractice.due(all, at: now).count == 2)
        #expect(MistakePractice.nextReturn(all, at: now) == now.addingTimeInterval(3 * 86_400))

        let current = now
        let round = MistakeRoundModel(items: MistakePractice.round(in: context, at: now), now: { current })
        #expect(round.total == 2)

        // Wrong: still in the stack. Right on the last step: learned, and gone from it.
        let wrongFirst = round.question.said == "Ich komme mit mein Freund."
        round.answer(!wrongFirst, in: context)
        round.answer(true, in: context) // a second answer to the same mistake doesn't count
        round.next()
        round.answer(wrongFirst, in: context)
        round.next()
        #expect(round.isDone)
        #expect(round.fixed.count == 1)
        #expect(round.comingBack.count == 1)

        let after = try context.fetch(MistakePractice.practisable)
        #expect(MistakePractice.due(after, at: now).count == 1)
        #expect(after.filter(\.isLearned).count == 2)
        // Learned mistakes stay in Memory.
        #expect(after.count == 4)
    }

    @Test("A mistake answered right every time is learned after four rounds and leaves the stack")
    func learnedLeaves() throws {
        // Kept in a constant: the context doesn't keep its container alive.
        let store = try AlltagStore.makeContainer(inMemory: true)
        let context = store.mainContext
        let item = mistake("Ich habe es auf mein Handy.", "Ich habe es auf meinem Handy.")
        context.insert(item)
        var date = now
        for _ in 0..<MemoryItem.maxStrength {
            let today = date
            let round = MistakeRoundModel(items: MistakePractice.round(in: context, at: today), now: { today })
            #expect(round.total == 1)
            round.answer(true, in: context)
            // Not due again the same day.
            #expect(MistakePractice.round(in: context, at: today.addingTimeInterval(3600)).isEmpty)
            date = item.nextReview
        }
        #expect(item.isLearned)
        #expect(MistakePractice.round(in: context, at: date.addingTimeInterval(365 * 86_400)).isEmpty)
        #expect(MistakePractice.nextReturn([item], at: now) == nil)
    }

    @Test("A wrong word can be spotted and its fix picked; a missing word can't")
    func spotting() {
        let dative = MistakeQuestion(item: mistake("Ich komme mit mein Freund.", "Ich komme mit meinem Freund.")) { $0 }
        #expect(dative.canSpot)
        #expect(dative.wrongWords == [3])
        #expect(dative.fixOptions == ["meinem", "mein"])
        #expect(dative.fixIndex == 0)

        let article = MistakeQuestion(item: mistake("der Wohnung", "die Wohnung")) { $0 }
        #expect(article.wrongWords == [0])
        #expect(Set(article.fixOptions) == ["der", "die", "das"])
        #expect(article.fixOptions[article.fixIndex] == "die")

        let missing = MistakeQuestion(item: mistake("Ich gehe Kino.", "Ich gehe ins Kino.")) { $0 }
        #expect(!missing.canSpot)

        // A word in the wrong place: it can be spotted, and there is nothing to pick.
        let order = MistakeQuestion(item: mistake("Am Wochenende ich gehe in den Park.", "Am Wochenende gehe ich in den Park.")) { $0 }
        #expect(order.canSpot)
        #expect(order.fixOptions.isEmpty)
    }

    @Test("The tiles hold the correction's words and the wrong one, never already in order")
    func tiles() {
        let question = MistakeQuestion(item: mistake("Ich komme mit mein Freund.", "Ich komme mit meinem Freund.")) { $0 }
        #expect(question.canBuild)
        #expect(question.correctionWords == ["Ich", "komme", "mit", "meinem", "Freund"])
        #expect(question.tiles.sorted() == ["Freund", "Ich", "komme", "mein", "meinem", "mit"])
        #expect(Array(question.tiles.prefix(5)) != question.correctionWords)
        #expect(question.isBuilt(["ich", "komme", "mit", "meinem", "Freund"]))
        #expect(!question.isBuilt(["Ich", "komme", "mit", "mein", "Freund"]))

        let long = MistakeQuestion(item: mistake("a b c d e f g h i j x", "a b c d e f g h i j k"))
        #expect(!long.canBuild)
    }

    @Test("The gap is where the fix belongs: it can be filled from choices or typed")
    func gaps() {
        let dative = MistakeQuestion(item: mistake("Ich komme mit mein Freund.", "Ich komme mit meinem Freund.")) { $0 }
        #expect(dative.fixWords == [3])
        #expect(dative.fix == "meinem")
        #expect(dative.canFill)
        #expect(dative.canType)
        #expect(dative.isFix(" Meinem "))
        #expect(!dative.isFix("mein"))

        // A missing word has nothing to choose against, and can still be typed.
        let missing = MistakeQuestion(item: mistake("Ich gehe Kino.", "Ich gehe ins Kino.")) { $0 }
        #expect(missing.fixWords == [2])
        #expect(!missing.canFill)
        #expect(missing.canType)
        #expect(missing.isFix("ins"))

        // Reworded altogether: no gap to fill or type.
        let reworded = MistakeQuestion(item: mistake("Ich will das machen jetzt sofort.", "Das mache ich gleich.")) { $0 }
        #expect(!reworded.canFill)
        #expect(!reworded.canType)
    }
}
