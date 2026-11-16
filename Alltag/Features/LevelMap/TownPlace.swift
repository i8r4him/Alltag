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

    var systemImage: String {
        switch self {
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
