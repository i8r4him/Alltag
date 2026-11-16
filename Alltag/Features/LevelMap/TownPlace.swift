//
//  TownPlace.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A place in the level map's town. Each part of learning is a place from
/// everyday life, and the station at the top is the level test.
enum TownPlace: String, CaseIterable, Identifiable {
    case cafe, library, market, school, station

    var id: String { rawValue }

    var name: LocalizedStringResource {
        if let name = PlaceLook.current.name(of: self) { return name }
        return switch self {
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

    var systemImage: String {
        if let symbol = PlaceLook.current.systemImage(of: self) { return symbol }
        return switch self {
        case .cafe: "cup.and.saucer.fill"
        case .library: "books.vertical.fill"
        case .market: "basket.fill"
        case .school: "graduationcap.fill"
        case .station: "tram.fill"
        }
    }

    /// The walk through town, from the first place to the station.
    static let route: [TownPlace] = [.cafe, .library, .market, .school, .station]
}

/// The looks of the café and the library to choose from (#389). Temporary:
/// the maintainer picks one, then the others and the switcher go.
enum PlaceLook: Int, CaseIterable {
    /// A cup and a shelf of books.
    case cup
    /// A shopfront and a building with columns.
    case buildings
    /// Two speech bubbles and a post office for letters.
    case postOffice
    /// A mug and a newsagent's.
    case newsagent

    static let storageKey = "levelMap.placeLook"

    static var current: PlaceLook {
        PlaceLook(rawValue: UserDefaults.standard.integer(forKey: storageKey)) ?? .cup
    }

    /// `nil` keeps the place's own symbol.
    func systemImage(of place: TownPlace) -> String? {
        switch (self, place) {
        case (.buildings, .cafe): "storefront.fill"
        case (.buildings, .library): "building.columns.fill"
        case (.postOffice, .cafe): "bubble.left.and.bubble.right.fill"
        case (.postOffice, .library): "envelope.open.fill"
        case (.newsagent, .cafe): "mug.fill"
        case (.newsagent, .library): "newspaper.fill"
        default: nil
        }
    }

    /// `nil` keeps the place's own name.
    func name(of place: TownPlace) -> LocalizedStringResource? {
        guard place == .library else { return nil }
        switch self {
        case .postOffice: return "Post office"
        case .newsagent: return "Newsagent"
        case .cup, .buildings: return nil
        }
    }
}
