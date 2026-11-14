//
//  WritingOptions.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import Foundation

/// How much time the learner has: the word range and the number of points follow it,
/// at every level.
enum WritingLength: String, CaseIterable, Identifiable, Sendable {
    /// A few sentences, about five minutes.
    case quick
    case standard
    /// The full length the level writes in an exam.
    case exam

    /// Where the choice is kept.
    static let key = "write.length"

    var id: String { rawValue }

    var title: LocalizedStringResource {
        switch self {
        case .quick: "Quick"
        case .standard: "Standard"
        case .exam: "Exam"
        }
    }

    var systemImage: String {
        switch self {
        case .quick: "hare"
        case .standard: "pencil.line"
        case .exam: "graduationcap"
        }
    }

    /// A quick text says two things, the others three.
    var pointCount: Int { self == .quick ? 2 : 3 }

    func wordRange(for level: Level) -> ClosedRange<Int> {
        switch (self, level) {
        case (.quick, .a1): 10...20
        case (.quick, .a2): 20...35
        case (.quick, .b1): 30...50
        case (.quick, .b2): 40...60
        case (.quick, _): 50...75
        case (.standard, .a1): 15...30
        case (.standard, .a2): 30...50
        case (.standard, .b1): 50...80
        case (.standard, .b2): 80...120
        case (.standard, _): 100...150
        case (.exam, .a1): 20...40
        case (.exam, .a2): 40...70
        case (.exam, .b1): 80...120
        case (.exam, .b2): 120...180
        case (.exam, _): 180...250
        }
    }

    /// Roughly how long it takes at `level`: about 15 words a minute, at least two minutes.
    func minutes(for level: Level) -> Int {
        max(2, Int((Double(wordRange(for: level).upperBound) / 15).rounded()))
    }
}

/// What the learner writes.
enum WritingKind: String, CaseIterable, Identifiable, Codable, Sendable {
    /// A chat message or a note to someone the learner knows.
    case message
    /// An email or letter that asks, informs or arranges.
    case email
    /// A complaint, an objection or a request to a company, a landlord or an authority.
    case complaint
    /// A personal text with no recipient: the day, the weekend, a plan, an opinion.
    case day
    /// The learner's own topic: no task, the same correction.
    case own

    /// Where the chosen kind is kept; empty for every kind.
    static let key = "write.kind"
    /// The kinds a task can have. The learner's own topic has no task.
    static let ofTasks: [WritingKind] = [.message, .email, .complaint, .day]

    var id: String { rawValue }

    var title: LocalizedStringResource {
        switch self {
        case .message: "Message"
        case .email: "Email"
        case .complaint: "Complaint"
        case .day: "My day"
        case .own: "My own topic"
        }
    }

    var systemImage: String {
        switch self {
        case .message: "bubble.left.fill"
        case .email: "envelope.fill"
        case .complaint: "exclamationmark.bubble.fill"
        case .day: "sun.max.fill"
        case .own: "pencil.and.scribble"
        }
    }
}
