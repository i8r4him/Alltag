//
//  GrammarProgress.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// Combines the topic list with the rules the learner has solved.
struct GrammarProgress {
    let solvedRuleIDs: Set<String>

    init(solved: [SolvedRule]) {
        solvedRuleIDs = Set(solved.map(\.ruleID))
    }

    /// A solved rule is shown as solved, whatever its listed status.
    func status(of topic: GrammarTopic) -> GrammarTopic.Status {
        if let id = topic.ruleID, solvedRuleIDs.contains(id) { return .solved }
        return topic.status
    }

    func solvedCount(at level: Level) -> Int {
        MockLevels.topics(for: level).filter { status(of: $0) == .solved }.count
    }

    /// Grammar topics where the learner made a mistake, across all levels.
    static func rulesWithMistakes() -> Int {
        Level.selectable.flatMap { MockLevels.topics(for: $0) }.filter { $0.status == .mistake }.count
    }

    /// The level shown first: the learner's own if it has topics, otherwise B1.
    static func initialLevel(for profileLevel: Level?) -> Level {
        guard let profileLevel, Level.selectable.contains(profileLevel) else { return .b1 }
        return profileLevel
    }

    /// The rules with a lesson at `level`, in the order the level lists them.
    static func rules(at level: Level) -> [GrammarRule] {
        MockLevels.topics(for: level).compactMap { topic in
            guard let id = topic.ruleID else { return nil }
            return MockRules.rule(id: id)
        }
    }

    /// The rule to solve before `ruleID` opens: the first unsolved rule listed
    /// before it at its level. `nil` when the rule is open. The rules of a
    /// level open in order; a solved rule stays open.
    func blocker(of ruleID: String) -> GrammarRule? {
        guard !solvedRuleIDs.contains(ruleID), let rule = MockRules.rule(id: ruleID) else { return nil }
        return Self.rules(at: rule.level)
            .prefix { $0.id != ruleID }
            .first { !solvedRuleIDs.contains($0.id) }
    }

    func isLocked(_ ruleID: String) -> Bool {
        blocker(of: ruleID) != nil
    }

    /// Where a rule sits in its level, from 1, and how many rules the level has.
    static func place(of rule: GrammarRule) -> (number: Int, count: Int)? {
        let rules = rules(at: rule.level)
        guard let index = rules.firstIndex(where: { $0.id == rule.id }) else { return nil }
        return (index + 1, rules.count)
    }

    /// The rule that opens once `rule` is solved: the next one at its level.
    static func rule(after rule: GrammarRule) -> GrammarRule? {
        let rules = rules(at: rule.level)
        guard let index = rules.firstIndex(where: { $0.id == rule.id }), rules.indices.contains(index + 1) else { return nil }
        return rules[index + 1]
    }

    /// What "Your next rule" shows: the first unsolved rule at the learner's
    /// level, in order. Once the level is done, the first unsolved rule of the
    /// levels above it; `nil` when every rule is done.
    func nextRule(at level: Level) -> NextRule? {
        let rules = Self.rules(at: level)
        if let index = rules.firstIndex(where: { !solvedRuleIDs.contains($0.id) }) {
            return NextRule(rule: rules[index], number: index + 1, count: rules.count, isLevelDone: false)
        }
        let later = Level.selectable.drop { $0 != level }.dropFirst()
        for nextLevel in later {
            let rules = Self.rules(at: nextLevel)
            if let index = rules.firstIndex(where: { !solvedRuleIDs.contains($0.id) }) {
                return NextRule(rule: rules[index], number: index + 1, count: rules.count, isLevelDone: true)
            }
        }
        return nil
    }
}

/// The rule "Your next rule" shows, and where it sits in its level.
struct NextRule: Equatable {
    let rule: GrammarRule
    /// Its place in its level, from 1.
    let number: Int
    /// How many rules its level has.
    let count: Int
    /// The learner's own level is done, so this rule is from a level above.
    let isLevelDone: Bool
}

extension GrammarTopic.Status {
    var label: LocalizedStringResource {
        switch self {
        case .solved: "Solved"
        case .learning: "In progress"
        case .mistake: "From your mistakes"
        case .new: "Not started"
        }
    }
}
