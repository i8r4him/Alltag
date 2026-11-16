//
//  TownLayout.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Each level is its own town, and the town grows with the level: a village
/// at A1, a small town at A2, up to a capital at C1. The places stand
/// elsewhere, the river and the park move, and the houses grow denser.
struct TownLayout {
    /// German, shown as it is: "Das Dorf", "Die Stadt".
    let townName: String
    let spots: [TownPlace: UnitPoint]
    /// How far the grid of houses is turned, in degrees.
    let blockAngle: Double
    /// Picks which blocks are built and how they vary.
    let seed: Int
    /// The share of blocks with houses on them, from 0 to 1.
    let density: Double
    /// Where the river comes in on the left and leaves on the right, as shares of the height.
    let riverIn: CGFloat
    let riverOut: CGFloat
    /// The park, in shares of the width and height.
    let park: CGRect
    /// Turns the big streets round, left for right.
    let isMirrored: Bool

    func spot(of place: TownPlace) -> UnitPoint {
        spots[place] ?? .center
    }

    static func of(_ level: Level) -> TownLayout {
        switch level {
        case .a1: village
        case .a2: smallTown
        case .b1: town
        case .b2: city
        case .c1, .c2: capital
        }
    }

    private static let village = TownLayout(
        townName: "Das Dorf",
        spots: [.station: UnitPoint(x: 0.5, y: 0.08), .school: UnitPoint(x: 0.27, y: 0.31),
                .market: UnitPoint(x: 0.73, y: 0.49), .library: UnitPoint(x: 0.28, y: 0.66),
                .cafe: UnitPoint(x: 0.72, y: 0.87)],
        blockAngle: -8, seed: 0, density: 0.45, riverIn: 0.6, riverOut: 0.7,
        park: CGRect(x: 0.6, y: 0.22, width: 0.46, height: 0.15), isMirrored: false)

    private static let smallTown = TownLayout(
        townName: "Die Kleinstadt",
        spots: [.station: UnitPoint(x: 0.5, y: 0.08), .school: UnitPoint(x: 0.73, y: 0.3),
                .market: UnitPoint(x: 0.27, y: 0.47), .library: UnitPoint(x: 0.72, y: 0.65),
                .cafe: UnitPoint(x: 0.3, y: 0.86)],
        blockAngle: 6, seed: 11, density: 0.62, riverIn: 0.42, riverOut: 0.55,
        park: CGRect(x: -0.08, y: 0.18, width: 0.42, height: 0.16), isMirrored: true)

    private static let town = TownLayout(
        townName: "Die Stadt",
        spots: [.station: UnitPoint(x: 0.7, y: 0.08), .school: UnitPoint(x: 0.3, y: 0.26),
                .market: UnitPoint(x: 0.7, y: 0.45), .library: UnitPoint(x: 0.32, y: 0.64),
                .cafe: UnitPoint(x: 0.66, y: 0.86)],
        blockAngle: -15, seed: 23, density: 0.78, riverIn: 0.75, riverOut: 0.58,
        park: CGRect(x: 0.55, y: 0.6, width: 0.5, height: 0.14), isMirrored: false)

    private static let city = TownLayout(
        townName: "Die Großstadt",
        spots: [.station: UnitPoint(x: 0.3, y: 0.08), .school: UnitPoint(x: 0.72, y: 0.27),
                .market: UnitPoint(x: 0.3, y: 0.47), .library: UnitPoint(x: 0.7, y: 0.66),
                .cafe: UnitPoint(x: 0.34, y: 0.86)],
        blockAngle: 11, seed: 37, density: 0.9, riverIn: 0.35, riverOut: 0.42,
        park: CGRect(x: 0.58, y: 0.74, width: 0.48, height: 0.14), isMirrored: true)

    private static let capital = TownLayout(
        townName: "Die Hauptstadt",
        spots: [.station: UnitPoint(x: 0.5, y: 0.08), .school: UnitPoint(x: 0.76, y: 0.3),
                .market: UnitPoint(x: 0.25, y: 0.45), .library: UnitPoint(x: 0.72, y: 0.63),
                .cafe: UnitPoint(x: 0.5, y: 0.86)],
        blockAngle: -3, seed: 53, density: 1, riverIn: 0.52, riverOut: 0.48,
        park: CGRect(x: -0.06, y: 0.6, width: 0.4, height: 0.16), isMirrored: false)
}
