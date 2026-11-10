//
//  PracticeKind.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 11.11.26.
//

import Foundation

/// What the learner did in a practice session.
enum PracticeKind: String, Codable, CaseIterable, Sendable {
    /// A spoken conversation with the companion, including situations.
    case conversation
    /// Talking about a random topic for 60 seconds.
    case sixtySeconds
    /// Reviewing words or fixing mistakes.
    case review
}
