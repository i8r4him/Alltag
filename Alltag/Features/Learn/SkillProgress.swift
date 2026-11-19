//
//  SkillProgress.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The progress line on a Practise card, only from what the app has really
/// recorded: no made-up numbers.
enum SkillProgress: Equatable {
    /// Grammar: rules solved out of the rules at the learner's level.
    case rules(solved: Int, total: Int, level: Level)
    /// Read: words saved to Memory from the reader. Texts read aren't recorded yet.
    case savedWords(Int)
    /// Write: chats and texts written, from Your sessions.
    case written(Int)
    /// A skill that is still a shell (Write, Listen) and records nothing.
    case comingSoon

    /// Grammar's progress at `level` (the learner's, as Grammar shows it).
    static func grammar(solvedRuleIDs: Set<String>, level: Level) -> SkillProgress {
        let rules = GrammarProgress.rules(at: level)
        return .rules(solved: rules.filter { solvedRuleIDs.contains($0.id) }.count, total: rules.count, level: level)
    }

    /// Read's progress from the learner's Memory.
    static func reading(_ items: [MemoryItem]) -> SkillProgress {
        .savedWords(items.filter { $0.source == .read }.count)
    }

    /// Write's progress: every chat and text kept in Your sessions.
    static func writing(_ sessions: [SessionRecord]) -> SkillProgress {
        .written(sessions.filter { $0.kind == .writing }.count)
    }

    /// How far along, from 0 to 1, when there is a count to show as a bar.
    var fraction: Double? {
        guard case let .rules(solved, total, _) = self, total > 0 else { return nil }
        return Double(solved) / Double(total)
    }
}
