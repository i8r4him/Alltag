//
//  EmojiCatalog.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 21.11.26.
//

import Foundation

/// A group of emoji, as the emoji panel shows them.
struct EmojiSection: Identifiable, Equatable {
    enum Kind: String, CaseIterable {
        case recent, people, nature, food, activity, travel, objects, symbols, flags

        /// The SF Symbol on the group's button.
        var symbol: String {
            switch self {
            case .recent: "clock"
            case .people: "face.smiling"
            case .nature: "pawprint"
            case .food: "fork.knife"
            case .activity: "soccerball"
            case .travel: "car"
            case .objects: "lightbulb"
            case .symbols: "heart"
            case .flags: "flag"
            }
        }
    }

    let kind: Kind
    let emoji: [String]

    var id: Kind { kind }
}

/// The emoji of Unicode 16 in the order people know, without the skin tones.
/// They are read once from `KeyboardEmoji.txt`: a line `@group`, then its emoji.
enum EmojiCatalog {
    static let sections: [EmojiSection] = {
        guard let url = Bundle(for: KeyboardModel.self).url(forResource: "KeyboardEmoji", withExtension: "txt"),
              let text = try? String(contentsOf: url, encoding: .utf8) else { return [] }
        return parse(text)
    }()

    static func parse(_ text: String) -> [EmojiSection] {
        var sections: [EmojiSection] = []
        var kind: EmojiSection.Kind?
        var emoji: [String] = []
        for line in text.split(whereSeparator: \.isNewline) {
            if line.hasPrefix("@") {
                if let kind, !emoji.isEmpty { sections.append(EmojiSection(kind: kind, emoji: emoji)) }
                kind = EmojiSection.Kind(rawValue: String(line.dropFirst()))
                emoji = []
            } else {
                emoji += line.split(separator: " ").map(String.init)
            }
        }
        if let kind, !emoji.isEmpty { sections.append(EmojiSection(kind: kind, emoji: emoji)) }
        return sections
    }
}

/// The emoji used last, the newest first. They are kept in the keyboard's own
/// settings, which need no Full Access.
struct EmojiRecents {
    static let key = "keyboard.recentEmoji"
    static let limit = 30

    var defaults: UserDefaults = .standard

    var list: [String] {
        defaults.stringArray(forKey: Self.key) ?? []
    }

    func add(_ emoji: String) {
        defaults.set(Self.adding(emoji, to: list), forKey: Self.key)
    }

    static func adding(_ emoji: String, to list: [String]) -> [String] {
        Array(([emoji] + list.filter { $0 != emoji }).prefix(limit))
    }
}
