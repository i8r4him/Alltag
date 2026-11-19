//
//  ReadingText.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// Where a text to read comes from in daily life.
enum ReadingKind: String, CaseIterable, Hashable, Sendable {
    case letter
    case notice
    case chat
    case message
    case email
    case menu
    case advert
    case announcement
    case article

    /// "Notice", for the line above a text's title.
    var title: LocalizedStringResource {
        switch self {
        case .letter: "Letter"
        case .notice: "Notice"
        case .chat: "Group chat"
        case .message: "Message"
        case .email: "Email"
        case .menu: "Menu"
        case .advert: "Small ad"
        case .announcement: "Announcement"
        case .article: "Article"
        }
    }
}

/// One of the three questions after a text: pick one of three answers.
struct ReadingQuestion: Hashable, Sendable {
    /// In English, e.g. "When is there no water?"
    let prompt: String
    let options: [String]
    /// The index of the right option.
    let answer: Int
    /// The sentence of the text that holds the answer, word for word, so a
    /// wrong answer can light it up.
    let evidence: String
}

/// A text from daily life to read at a level: a letter, a notice, a chat, a
/// menu. Written for the app, like the Grammar rules, so it works offline.
struct ReadingText: Identifiable, Hashable {
    /// Stable, so progress and the reader can find it: "a1-parcel".
    let id: String
    let level: Level
    let kind: ReadingKind
    /// What the text is, in English: "A card from the parcel service".
    let title: LocalizedStringResource
    /// What it is about: "Your parcel is waiting".
    let detail: LocalizedStringResource
    let systemImage: String
    /// The text itself, in German. One line per paragraph; an empty line starts a new block.
    let german: String
    let questions: [ReadingQuestion]

    /// About how long it takes to read, at a learner's pace.
    var minutes: Int {
        let words = german.split(whereSeparator: \.isWhitespace).count
        return max(1, Int((Double(words) / 60).rounded(.up)))
    }

    static func == (lhs: ReadingText, rhs: ReadingText) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

/// Every text to read, by level. C2 reads C1's texts.
enum ReadingTexts {
    static let all: [ReadingText] = a1 + a2 + b1 + b2 + c1

    /// The level's texts in order. C2 has none of its own and reads C1's.
    static func texts(at level: Level) -> [ReadingText] {
        let level = level == .c2 ? .c1 : level
        return all.filter { $0.level == level }
    }

    static func text(id: String) -> ReadingText? {
        all.first { $0.id == id }
    }
}
