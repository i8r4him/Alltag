//
//  SolvedRule.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData

/// A grammar rule the learner marked as solved.
@Model
final class SolvedRule {
    /// Identifier of the `GrammarRule`, e.g. "weil".
    var ruleID: String = ""
    var solvedAt: Date = Date.now

    init(ruleID: String, solvedAt: Date = .now) {
        self.ruleID = ruleID
        self.solvedAt = solvedAt
    }
}
