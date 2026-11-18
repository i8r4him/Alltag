//
//  TownPlace.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A place in the level map's town. Each part of learning is a place from
/// everyday life, and the station at the top is the level test. Each level's
/// town has its own version of the place, with its own German name and symbol.
enum TownPlace: String, CaseIterable, Identifiable {
    case cafe, library, market, school, station

    var id: String { rawValue }

    var name: LocalizedStringResource {
        switch self {
        case .cafe: "Café"
        case .library: "Library"
        case .market: "Market"
        case .school: "School"
        case .station: "Station"
        }
    }

    /// What the learner does there.
    var subject: LocalizedStringResource {
        switch self {
        case .cafe: "Speaking"
        case .library: "Read and Write"
        case .market: "Words"
        case .school: "Grammar"
        case .station: "Level test"
        }
    }

    /// What the place is called at a level, in German: the places grow with
    /// the town, from the village's kiosk to the capital's theatre.
    func germanName(at level: Level) -> String {
        Self.signs[self]?[Self.townIndex(of: level)].name ?? ""
    }

    /// The place's symbol at a level, drawn as the tube of its neon sign.
    func systemImage(at level: Level) -> String {
        Self.signs[self]?[Self.townIndex(of: level)].symbol ?? "questionmark"
    }

    /// How far the place's sign hangs askew, in degrees, like a real shop sign.
    var tilt: Double {
        switch self {
        case .cafe: 3
        case .library: -2
        case .market: 2
        case .school: -3
        case .station: 0
        }
    }

    /// The towns from the village (A1) to the capital (C1); C2 shares the capital.
    private static func townIndex(of level: Level) -> Int {
        min(Level.selectable.firstIndex(of: level) ?? Level.selectable.count - 1, Level.selectable.count - 1)
    }

    /// Each place's German name and symbol in each town, A1 to C1.
    private static let signs: [TownPlace: [(name: String, symbol: String)]] = [
        .cafe: [("Der Kiosk", "takeoutbag.and.cup.and.straw"), ("Das Café", "cup.and.saucer"),
                ("Das Restaurant", "fork.knife"), ("Die Weinbar", "wineglass"), ("Das Theater", "theatermasks")],
        .library: [("Der Bücherschrank", "book.closed"), ("Die Post", "envelope"),
                   ("Die Bibliothek", "books.vertical"), ("Der Zeitungskiosk", "newspaper"), ("Der Verlag", "book.pages")],
        .market: [("Der Wochenmarkt", "basket"), ("Der Supermarkt", "cart"),
                  ("Die Markthalle", "storefront"), ("Der Flohmarkt", "tag"), ("Die Messe", "building.2")],
        .school: [("Die Grundschule", "pencil.and.ruler"), ("Die Sprachschule", "backpack"),
                  ("Das Gymnasium", "graduationcap"), ("Die Volkshochschule", "studentdesk"), ("Die Universität", "building.columns")],
        .station: [("Die Bushaltestelle", "bus"), ("Die Straßenbahn", "tram"),
                   ("Der Bahnhof", "train.side.front.car"), ("Der Hafen", "ferry"), ("Der Flughafen", "airplane")]
    ]

    /// The walk through town, from the first place to the station.
    static let route: [TownPlace] = [.cafe, .library, .market, .school, .station]
}
