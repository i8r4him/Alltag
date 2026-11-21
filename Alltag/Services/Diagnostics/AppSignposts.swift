//
//  AppSignposts.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import OSLog

/// Named intervals for Instruments (#443): the work the app does at launch and when it goes to
/// the background shows up by name in the "Points of Interest" lane, so a slow step is easy to see.
/// Signposts cost next to nothing when Instruments isn't recording.
enum AppSignposts {
    static let signposter = OSSignposter(subsystem: "i8r4him.Alltag", category: .pointsOfInterest)

    /// Runs `work` inside an interval named `name`.
    static func measure<T>(_ name: StaticString, _ work: () throws -> T) rethrows -> T {
        let state = signposter.beginInterval(name)
        defer { signposter.endInterval(name, state) }
        return try work()
    }

    /// Runs `work` inside an interval named `name`, across its suspension points.
    static func measure<T>(_ name: StaticString, _ work: () async throws -> T) async rethrows -> T {
        let state = signposter.beginInterval(name)
        defer { signposter.endInterval(name, state) }
        return try await work()
    }
}
