//
//  PracticeSession.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 11.11.26.
//

import Foundation
import SwiftData

/// One time the learner practised. The streak counts the days with a
/// session, and the minutes spoken add up the sessions' seconds.
///
/// Like every model, it follows CloudKit's rules so iCloud sync can be
/// switched on later: every property has a default and nothing is unique.
@Model
final class PracticeSession {
    var date: Date = Date.now
    /// Raw value of `kind`; SwiftData predicates filter on it.
    var kindRaw: String = PracticeKind.conversation.rawValue
    /// How long the learner spoke, in seconds. Zero for practice without speaking.
    var secondsSpoken: Int = 0

    var kind: PracticeKind {
        get { PracticeKind(rawValue: kindRaw) ?? .conversation }
        set { kindRaw = newValue.rawValue }
    }

    init(kind: PracticeKind, secondsSpoken: Int = 0, date: Date = .now) {
        self.date = date
        self.kindRaw = kind.rawValue
        self.secondsSpoken = max(0, secondsSpoken)
    }
}
