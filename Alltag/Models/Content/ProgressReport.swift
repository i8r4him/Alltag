//
//  ProgressReport.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// What the learner can do and how they're improving, for the Progress screen.
/// Sample data for now; later computed from conversations, reviews and activity.
struct ProgressReport: Sendable {
    /// Confidence in a real-life situation.
    enum Confidence: Int, Sendable {
        case shaky = 1
        case gettingThere = 2
        case confident = 3
    }

    struct Situation: Sendable {
        let name: String
        let confidence: Confidence
    }

    struct Skill: Sendable {
        let name: String
        /// 0…1
        let value: Double
        /// Change over the last 30 days, in points.
        let change: Int
    }

    struct Attention: Sendable {
        let title: String
        let reason: String
    }

    /// Share of the way from the current level to the next, 0…1.
    let progressToNextLevel: Double
    /// What the learner can do now, and what's next.
    let summary: String
    /// When the next level should be reached, e.g. "by summer 2027".
    let nextLevelTarget: String
    let situations: [Situation]
    let skills: [Skill]
    /// Share of words still remembered 30 days later, 0…1.
    let wordsStuck: Double
    /// Words-that-stuck history, oldest first, 0…1.
    let wordsStuckHistory: [Double]
    let minutesSpoken: Int
    let spokenNote: String
    let conversations: Int
    let attention: [Attention]
    /// Insights, with **bold** parts in Markdown.
    let howYouLearn: [String]

    /// "2 confident · 2 getting there · 2 shaky" as counts.
    func count(_ confidence: Confidence) -> Int {
        situations.filter { $0.confidence == confidence }.count
    }

    /// The first shaky situation, to work on next.
    var nextToWorkOn: Situation? {
        situations.first { $0.confidence == .shaky }
    }

    /// How far along the A1–C2 track the learner is, 0…1.
    static func trackFraction(level: Level, progressToNext: Double) -> Double {
        let levels = Level.allCases
        let index = Double(levels.firstIndex(of: level) ?? 0)
        let fraction = (index + min(max(progressToNext, 0), 1)) / Double(levels.count - 1)
        return min(fraction, 1)
    }
}
