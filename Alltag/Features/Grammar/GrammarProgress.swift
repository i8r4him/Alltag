//
//  GrammarProgress.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The rules with a lesson, in the order the learner sees them, and which
/// they have solved. Solved comes only from `SolvedRule`; nothing else is
/// assumed about the learner.
struct GrammarProgress {
    let rules: [GrammarRule]
    let solvedRuleIDs: Set<String>

    init(solved: [SolvedRule], rules: [GrammarRule] = MockRules.all) {
        self.rules = rules
        solvedRuleIDs = Set(solved.map(\.ruleID))
    }

    func isSolved(_ rule: GrammarRule) -> Bool {
        solvedRuleIDs.contains(rule.id)
    }

    var solvedCount: Int {
        rules.filter(isSolved).count
    }

    /// The learner's level first, then the levels above it from the nearest,
    /// then the ones below from the nearest. Within a level, the listed order.
    func ordered(from level: Level) -> [GrammarRule] {
        let index = { (rule: GrammarRule) -> Int in
            let distance = Level.allCases.distance(of: rule.level, from: level)
            // Above (0, 1, 2 …) before below (−1, −2 …).
            return distance >= 0 ? distance : Level.allCases.count - distance
        }
        return rules.enumerated()
            .sorted { (index($0.element), $0.offset) < (index($1.element), $1.offset) }
            .map(\.element)
    }

    /// The first rule in the learner's order they haven't solved yet.
    func nextRule(from level: Level) -> GrammarRule? {
        ordered(from: level).first { !isSolved($0) }
    }

    /// The level Grammar starts from: the learner's own, C1 for C2, A1 without a profile.
    static func startLevel(for profileLevel: Level?) -> Level {
        guard let profileLevel else { return .a1 }
        return Level.selectable.contains(profileLevel) ? profileLevel : (Level.selectable.last ?? .c1)
    }
}

private extension Array where Element == Level {
    /// How many levels `level` is above `start` (negative when below).
    func distance(of level: Level, from start: Level) -> Int {
        (firstIndex(of: level) ?? 0) - (firstIndex(of: start) ?? 0)
    }
}
