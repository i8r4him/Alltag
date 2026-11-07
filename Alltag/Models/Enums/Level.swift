//
//  Level.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// CEFR level, A1–C2.
enum Level: String, Codable, CaseIterable, Comparable, Identifiable, Sendable {
    case a1 = "A1"
    case a2 = "A2"
    case b1 = "B1"
    case b2 = "B2"
    case c1 = "C1"
    case c2 = "C2"

    var id: String { rawValue }
    /// "A1" … "C2"; the same in every language.
    var title: String { rawValue }

    /// Levels offered in onboarding and Grammar (C2 is only on the progress track).
    static let selectable: [Level] = [.a1, .a2, .b1, .b2, .c1]

    /// How the learner describes themselves at this level (onboarding).
    var selfDescription: LocalizedStringResource {
        switch self {
        case .a1: "Just starting out"
        case .a2: "Simple everyday conversations"
        case .b1: "I get by in most situations"
        case .b2: "Comfortable, but not always precise"
        case .c1: "Fluent — I want polish"
        case .c2: "Near-native"
        }
    }

    /// What the level is about (Grammar).
    var summary: LocalizedStringResource {
        switch self {
        case .a1: "First steps"
        case .a2: "Everyday situations"
        case .b1: "Getting by independently"
        case .b2: "Nuance and opinion"
        case .c1: "Precision and style"
        case .c2: "Mastery"
        }
    }

    static func < (lhs: Level, rhs: Level) -> Bool {
        allCases.firstIndex(of: lhs) ?? 0 < allCases.firstIndex(of: rhs) ?? 0
    }
}
