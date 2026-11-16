//
//  LevelMapTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftUI
import Testing
@testable import Alltag

@Suite("Level map")
@MainActor
struct LevelMapTests {
    private func map(_ level: Level = .a2, solved: Set<String> = [], practised: Set<String> = []) -> LevelMap {
        LevelMap(level: level, solvedRuleIDs: solved, practisedTitles: practised)
    }

    @Test("School holds the level's rules in order, and counts the solved ones")
    func school() throws {
        let rules = GrammarProgress.rules(at: .a2)
        let first = try #require(rules.first)
        let school = try #require(map(solved: [first.id]).progress(of: .school))
        #expect(school.isOpen)
        #expect(school.stops?.map(\.id) == rules.map(\.id))
        #expect(school.doneCount == 1)
        #expect(school.totalCount == rules.count)
        #expect(school.nextStop?.id == rules.dropFirst().first?.id)
        #expect(school.nextStop?.destination == .rule(id: rules[1].id))
    }

    @Test("Café counts the situations talked through, by their title in the history")
    func cafe() throws {
        let situation = try #require(SituationCatalogue.all.first)
        let cafe = try #require(map(practised: [String(localized: situation.title)]).progress(of: .cafe))
        #expect(cafe.totalCount == SituationCatalogue.all.count)
        #expect(cafe.doneCount == 1)
        #expect(cafe.stops?.first?.isDone == true)
        #expect(cafe.nextStop?.destination == .situation(id: SituationCatalogue.all[1].id))
    }

    @Test("Only conversations count for the café, not 60 seconds")
    func onlyConversations() throws {
        let title = String(localized: try #require(SituationCatalogue.all.first).title)
        let talk = SessionRecord(kind: .conversation, title: title, secondsSpoken: 60, lines: [])
        let minute = SessionRecord(kind: .sixtySeconds, title: title, secondsSpoken: 60, lines: [])
        #expect(LevelMap(level: .a2, solved: [], sessions: [talk]).progress(of: .cafe)?.doneCount == 1)
        #expect(LevelMap(level: .a2, solved: [], sessions: [minute]).progress(of: .cafe)?.doneCount == 0)
    }

    @Test("Library and market are soon: they show no ring and don't count")
    func soonPlaces() throws {
        let fresh = map()
        #expect(fresh.progress(of: .library)?.isOpen == false)
        #expect(fresh.progress(of: .market)?.isOpen == false)
        #expect(fresh.progress(of: .station) == nil)
        let rules = GrammarProgress.rules(at: .a2).map(\.id)
        // All rules solved, no situation: the open places are half done.
        #expect(map(solved: Set(rules)).fraction == 0.5)
        #expect(map(solved: Set(rules)).percent == 50)
    }

    @Test("The percentage rounds down, so 100 means done")
    func roundsDown() {
        let titles = SituationCatalogue.all.dropLast().map { String(localized: $0.title) }
        let rules = Set(GrammarProgress.rules(at: .a2).map(\.id))
        let almost = map(solved: rules, practised: Set(titles))
        #expect(almost.fraction < 1)
        #expect(almost.percent < 100)
    }

    @Test("The next place is the open one furthest behind, and you are there")
    func nextPlace() throws {
        let rules = GrammarProgress.rules(at: .a2).map(\.id)
        let behindOnGrammar = map(practised: [String(localized: try #require(SituationCatalogue.all.first).title)])
        #expect(behindOnGrammar.nextPlace?.place == .school)
        #expect(behindOnGrammar.here == .school)
        let behindOnTalking = map(solved: Set(rules.prefix(10)))
        #expect(behindOnTalking.nextPlace?.place == .cafe)
    }

    @Test("With every open place full, you stand at the station, but the test stays shut while places are soon")
    func everythingDone() {
        let all = map(solved: Set(GrammarProgress.rules(at: .a2).map(\.id)),
                      practised: Set(SituationCatalogue.all.map { String(localized: $0.title) }))
        #expect(all.percent == 100)
        #expect(all.nextPlace == nil)
        #expect(all.here == .station)
        #expect(!all.isTestOpen)
    }

    @Test("The next level is the one above; C2 is the top")
    func nextLevel() {
        #expect(map(.a2).nextLevel == .b1)
        #expect(map(.c1).nextLevel == .c2)
        #expect(map(.c2).nextLevel == nil)
        // C2 has no rules: its school is soon, not empty.
        #expect(map(.c2).progress(of: .school)?.isOpen == false)
    }

    @Test("Another level's map holds that level's rules")
    func otherLevel() {
        let b1 = map(.b1)
        #expect(b1.progress(of: .school)?.totalCount == GrammarProgress.rules(at: .b1).count)
        #expect(b1.nextLevel == .b2)
    }

    @Test("Every look of the café and the library has its own symbols, and leaves the other places alone")
    func looks() {
        for look in PlaceLook.allCases where look != .cup {
            #expect(look.systemImage(of: .cafe) != nil)
            #expect(look.systemImage(of: .library) != nil)
            #expect(look.systemImage(of: .cafe) != look.systemImage(of: .library))
            #expect(look.systemImage(of: .school) == nil)
            #expect(look.name(of: .cafe) == nil)
        }
        #expect(PlaceLook.cup.systemImage(of: .cafe) == nil)
    }

    @Test("Part of the route lies exactly on the whole route")
    func partialRoute() {
        let points = TownPlace.route.map { CGPoint(x: $0.spot.x * 400, y: $0.spot.y * 800) }
        let whole = TownRoute.path(through: points)
        let part = TownRoute.path(through: points, segments: 2)
        #expect(part.currentPoint == points[2])
        #expect(whole.currentPoint == points.last)
        #expect(TownRoute.path(through: points, segments: 0).currentPoint == points[0])
    }
}
