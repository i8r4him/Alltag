//
//  LevelMap.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// One thing to do in a place: a rule to solve, a situation to talk through,
/// a word collection to add to Memory.
struct MapStop: Identifiable, Hashable {
    enum Destination: Hashable {
        case rule(id: String)
        case situation(id: String)
        case collection(id: String)
    }

    let id: String
    /// A rule's or a situation's title in the learner's language, or a
    /// collection's German name ("Beim Arzt").
    let title: String
    let isDone: Bool
    let destination: Destination
}

/// How far the learner has come in one place of town.
struct PlaceProgress: Identifiable {
    let place: TownPlace
    /// `nil` while the place has no real content yet: it shows "soon" and
    /// doesn't count towards the level.
    let stops: [MapStop]?

    var id: TownPlace { place }
    var isOpen: Bool { stops != nil }
    var doneCount: Int { stops?.filter(\.isDone).count ?? 0 }
    var totalCount: Int { stops?.count ?? 0 }

    /// Done, from 0 to 1.
    var fraction: Double {
        totalCount == 0 ? 0 : Double(doneCount) / Double(totalCount)
    }

    var isFull: Bool { isOpen && totalCount > 0 && doneCount == totalCount }

    /// The first thing not done yet, in the place's order.
    var nextStop: MapStop? { stops?.first { !$0.isDone } }
}

/// The learner's way to the next level, as a town: each part of learning is a
/// place that fills up, and the level test waits at the station.
///
/// Only real progress counts. A place whose content isn't real yet (Read and
/// Write, and Words at a level without ready word collections) is "soon" and
/// left out of the percentage.
struct LevelMap {
    let level: Level
    /// The places in the order of the walk through town; the station isn't one.
    let places: [PlaceProgress]

    /// - Parameters:
    ///   - collectedTitles: the titles of the word collections with words in Memory.
    ///   - collections: the word collections to choose the level's from; the ready ones by default.
    init(level: Level, solvedRuleIDs: Set<String>, practisedTitles: Set<String>, collectedTitles: Set<String> = [],
         collections: [WordCollection] = WordCollections.ready) {
        self.level = level
        let rules = GrammarProgress.rules(at: level)
        let school = PlaceProgress(place: .school, stops: rules.isEmpty ? nil : rules.map { rule in
            MapStop(id: rule.id, title: rule.title, isDone: solvedRuleIDs.contains(rule.id),
                    destination: .rule(id: rule.id))
        })
        let cafe = PlaceProgress(place: .cafe, stops: SituationCatalogue.all.map { situation in
            let title = String(localized: situation.title)
            return MapStop(id: situation.id, title: title, isDone: practisedTitles.contains(title),
                           destination: .situation(id: situation.id))
        })
        let collections = collections.filter { $0.level == level && $0.isReady }
        let market = PlaceProgress(place: .market, stops: collections.isEmpty ? nil : collections.map { collection in
            MapStop(id: collection.id, title: collection.title, isDone: collectedTitles.contains(collection.title),
                    destination: .collection(id: collection.id))
        })
        places = [cafe, PlaceProgress(place: .library, stops: nil), market, school]
    }

    /// From what the app has saved: the solved rules, the conversations kept
    /// in the history and the words collections added to Memory.
    init(level: Level, solved: [SolvedRule], sessions: [SessionRecord], collectionWords: [MemoryItem] = []) {
        self.init(level: level,
                  solvedRuleIDs: Set(solved.map(\.ruleID)),
                  practisedTitles: Set(sessions.filter { $0.kind == .conversation }.map(\.title)),
                  collectedTitles: CollectionMemory.addedTitles(collectionWords))
    }

    /// The level after this one, or `nil` at the top.
    var nextLevel: Level? {
        Level.allCases.first { $0 > level }
    }

    /// How far to the next level, from 0 to 1: the open places, each counting the same.
    var fraction: Double {
        let open = places.filter(\.isOpen)
        guard !open.isEmpty else { return 0 }
        return open.map(\.fraction).reduce(0, +) / Double(open.count)
    }

    /// Rounded down, so 100 only when everything is done.
    var percent: Int {
        Int((fraction * 100).rounded(.down))
    }

    /// The test opens when every place is open and full.
    var isTestOpen: Bool {
        places.allSatisfy(\.isFull)
    }

    /// Where to go next: the open place furthest behind (the first of them on the walk).
    var nextPlace: PlaceProgress? {
        places.filter { $0.isOpen && !$0.isFull }.min { $0.fraction < $1.fraction }
    }

    /// Where "You are here" stands: the next place, or the station when nothing is left.
    var here: TownPlace {
        nextPlace?.place ?? .station
    }

    func progress(of place: TownPlace) -> PlaceProgress? {
        places.first { $0.place == place }
    }
}
