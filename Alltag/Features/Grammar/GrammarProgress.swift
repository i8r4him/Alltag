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

    /// The level shown first: the learner's own if it has topics, otherwise B1.
    static func initialLevel(for profileLevel: Level?) -> Level {
        guard let profileLevel, Level.selectable.contains(profileLevel) else { return .b1 }
        return profileLevel
    }
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
