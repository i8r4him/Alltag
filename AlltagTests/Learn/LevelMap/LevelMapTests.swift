//
//  LevelMapTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftUI
import Testing
import UIKit
@testable import Alltag

@Suite("Level map")
@MainActor
struct LevelMapTests {
    private func map(_ level: Level = .a2, solved: Set<String> = [], practised: Set<String> = [],
                     collected: Set<String> = []) -> LevelMap {
        LevelMap(level: level, solvedRuleIDs: solved, practisedTitles: practised, collectedTitles: collected)
    }

    /// The titles of every ready word collection at `level`.
    private func allCollections(at level: Level = .a2) -> Set<String> {
        Set(WordCollections.ready.filter { $0.level == level }.map(\.title))
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

    @Test("The library, and the market at a level without collections, are soon: no ring, and they don't count")
    func soonPlaces() throws {
        #expect(allCollections(at: .a1).isEmpty)
        let fresh = map(.a1)
        #expect(fresh.progress(of: .library)?.isOpen == false)
        #expect(fresh.progress(of: .market)?.isOpen == false)
        #expect(fresh.progress(of: .station) == nil)
        let rules = GrammarProgress.rules(at: .a1).map(\.id)
        // All rules solved, no situation: the open places are half done.
        #expect(map(.a1, solved: Set(rules)).fraction == 0.5)
        #expect(map(.a1, solved: Set(rules)).percent == 50)
    }

    @Test("The market holds the level's ready word collections, and counts the ones added to Memory")
    func market() throws {
        let collections = WordCollections.ready.filter { $0.level == .a2 }
        let first = try #require(collections.first)
        let market = try #require(map(collected: [first.title]).progress(of: .market))
        #expect(market.isOpen)
        #expect(market.stops?.map(\.id) == collections.map(\.id))
        #expect(market.doneCount == 1)
        #expect(market.nextStop?.destination == .collection(id: collections[1].id))
        // A collection of another level doesn't count here.
        let other = try #require(WordCollections.ready.first { $0.level == .b1 })
        #expect(map(collected: [other.title]).progress(of: .market)?.doneCount == 0)
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
        let behindOnGrammar = map(practised: [String(localized: try #require(SituationCatalogue.all.first).title)],
                                  collected: allCollections())
        #expect(behindOnGrammar.nextPlace?.place == .school)
        #expect(behindOnGrammar.here == .school)
        let behindOnTalking = map(solved: Set(rules.prefix(10)), collected: allCollections())
        #expect(behindOnTalking.nextPlace?.place == .cafe)
    }

    @Test("With every open place full, you stand at the station, but the test stays shut while places are soon")
    func everythingDone() {
        let all = map(solved: Set(GrammarProgress.rules(at: .a2).map(\.id)),
                      practised: Set(SituationCatalogue.all.map { String(localized: $0.title) }),
                      collected: allCollections())
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

    @Test("Part of the route lies exactly on the whole route")
    func partialRoute() {
        let layout = TownLayout.of(.a2)
        let points = TownPlace.route.map { CGPoint(x: layout.spot(of: $0).x * 400, y: layout.spot(of: $0).y * 800) }
        let whole = TownRoute.path(through: points)
        let part = TownRoute.path(through: points, segments: 2)
        #expect(part.currentPoint == points[2])
        #expect(whole.currentPoint == points.last)
        #expect(TownRoute.path(through: points, segments: 0).currentPoint == points[0])
    }

    @Test("Every level has its own town, with all the places on it and the station at the top")
    func towns() {
        let towns = Level.allCases.map(TownLayout.of)
        for town in towns {
            #expect(Set(town.spots.keys) == Set(TownPlace.allCases))
            let station = town.spot(of: .station)
            for place in TownPlace.allCases where place != .station {
                #expect(town.spot(of: place).y > station.y)
                #expect((0...1).contains(town.spot(of: place).x))
            }
        }
        let selectable = Level.selectable.map(TownLayout.of)
        #expect(Set(selectable.map(\.townName)).count == selectable.count)
        #expect(Set(selectable.map(\.seed)).count == selectable.count)
    }

    @Test("Every town has its own places, each with a German name and a real symbol")
    func placesPerTown() {
        for place in TownPlace.allCases {
            let names = Level.selectable.map { place.germanName(at: $0) }
            #expect(Set(names).count == names.count, "\(place) has the same name in two towns")
            #expect(names.allSatisfy { $0.hasPrefix("Der ") || $0.hasPrefix("Die ") || $0.hasPrefix("Das ") })
        }
        for level in Level.allCases {
            let symbols = TownPlace.allCases.map { $0.systemImage(at: level) }
            #expect(Set(symbols).count == symbols.count, "Two places share a symbol at \(level)")
            for symbol in symbols {
                #expect(UIImage(systemName: symbol) != nil, "No SF Symbol named \(symbol)")
            }
        }
        // C2 has no town of its own: it shares the capital's places.
        #expect(TownPlace.school.germanName(at: .c2) == TownPlace.school.germanName(at: .c1))
    }

    @Test("A sign's bulbs light up with what's done, the last one only when everything is")
    func bulbs() {
        let none = NeonSign.Bulbs(done: 0, total: 5)
        #expect(none.number == 5 && none.lit == 0)
        let some = NeonSign.Bulbs(done: 2, total: 5)
        #expect(some.number == 5 && some.lit == 2)
        // Many things to do share the most bulbs a sign has.
        let many = NeonSign.Bulbs(done: 10, total: 20)
        #expect(many.number == NeonSign.Bulbs.maximum && many.lit == 4)
        // A first step always shows; almost done isn't full.
        #expect(NeonSign.Bulbs(done: 1, total: 30).lit == 1)
        #expect(NeonSign.Bulbs(done: 29, total: 30).lit == NeonSign.Bulbs.maximum - 1)
        let full = NeonSign.Bulbs(done: 30, total: 30)
        #expect(full.lit == full.number)
    }
}
