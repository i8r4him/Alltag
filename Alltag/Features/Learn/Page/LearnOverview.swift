//
//  LearnOverview.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The parts of Learn the page shows under the tools.
enum LearnPart: String, CaseIterable, Identifiable {
    case grammar, read, write, words, listen

    var id: Self { self }

    var title: LocalizedStringResource {
        switch self {
        case .grammar: "Grammar"
        case .read: "Read"
        case .write: "Write"
        case .words: "Words"
        case .listen: "Listen"
        }
    }

    var summary: LocalizedStringResource {
        switch self {
        case .grammar: "Rules you get wrong"
        case .read: "Letters, notices and forms"
        case .write: "Messages and emails"
        case .words: "Ready-made words by topic"
        case .listen: "Announcements and calls"
        }
    }

    var systemImage: String {
        switch self {
        case .grammar: "text.badge.checkmark"
        case .read: "envelope.open.fill"
        case .write: "square.and.pencil"
        case .words: "square.stack.fill"
        case .listen: "ear.fill"
        }
    }

    /// The screen with all of the part.
    var route: Route {
        switch self {
        case .grammar: .grammar
        case .read: .read
        case .write: .write
        case .words: .collections
        case .listen: .listen
        }
    }
}

/// Everything Learn's page shows about its parts, from the learner's real
/// progress: how far they are at their level, and what comes next, in order.
struct LearnOverview {
    /// One thing to do in a part: a rule, a text, a chat, a word collection.
    struct Item: Identifiable {
        let target: LessonTarget
        let title: LessonTitle
        let subtitle: LessonTitle?
        let systemImage: String
        let isDone: Bool

        var id: LessonTarget { target }
    }

    /// A part with its progress at the learner's level and its next things.
    struct Part: Identifiable {
        let kind: LearnPart
        /// Rules solved, texts read, chats and texts written, collections saved.
        let done: Int
        /// Out of how many; 0 when the part has no total (Write) or nothing yet (Listen).
        let total: Int
        /// The things to do, the ones not done first, in order.
        let items: [Item]

        var id: LearnPart { kind }
        var next: Item? { items.first { !$0.isDone } }
        var isComingSoon: Bool { kind == .listen }

        /// Done, from 0 to 1, when there is a total.
        var fraction: Double? {
            total > 0 ? Double(done) / Double(total) : nil
        }
    }

    let parts: [Part]

    func part(_ kind: LearnPart) -> Part? {
        parts.first { $0.kind == kind }
    }

    /// The parts the page shows as doors: all but the ones still coming.
    var doors: [Part] {
        parts.filter { !$0.isComingSoon }
    }

    /// How many things each part lists at most.
    static let itemLimit = 8

    static func make(at level: Level, solvedRules: [SolvedRule], sessions: [SessionRecord],
                     collectionWords: [MemoryItem]) -> LearnOverview {
        LearnOverview(parts: [
            grammar(at: level, solved: solvedRules),
            reading(at: level, sessions: sessions),
            writing(at: level, sessions: sessions),
            words(at: level, items: collectionWords),
            Part(kind: .listen, done: 0, total: 0, items: [])
        ])
    }

    /// The not-done items first, keeping the order, then the done ones.
    private static func ordered(_ items: [Item]) -> [Item] {
        Array((items.filter { !$0.isDone } + items.filter(\.isDone)).prefix(itemLimit))
    }

    private static func grammar(at level: Level, solved: [SolvedRule]) -> Part {
        let ids = Set(solved.map(\.ruleID))
        let rules = GrammarProgress.rules(at: GrammarProgress.initialLevel(for: level))
        let items = rules.map { rule in
            Item(target: .rule(rule.id), title: .german(rule.title), subtitle: .german(rule.place),
                 systemImage: rule.systemImage, isDone: ids.contains(rule.id))
        }
        return Part(kind: .grammar, done: items.filter(\.isDone).count, total: items.count, items: ordered(items))
    }

    private static func reading(at level: Level, sessions: [SessionRecord]) -> Part {
        let read = ReadingProgress.readIDs(in: sessions.filter { $0.kind == .reading })
        let texts = ReadingTexts.texts(at: level).map { text in
            Item(target: .text(text.id), title: .resource(text.title), subtitle: .resource(text.detail),
                 systemImage: text.systemImage, isDone: read.contains(text.id))
        }
        let scenes = ReadDoScenes.scenes(at: level).map { scene in
            Item(target: .scene(scene.id), title: .resource(scene.title), subtitle: .resource(scene.detail),
                 systemImage: scene.systemImage, isDone: read.contains(scene.id))
        }
        // Texts and "Read and do" by turns, so both show near the front.
        var mixed: [Item] = []
        for index in 0..<max(texts.count, scenes.count) {
            if texts.indices.contains(index) { mixed.append(texts[index]) }
            if scenes.indices.contains(index) { mixed.append(scenes[index]) }
        }
        return Part(kind: .read, done: mixed.filter(\.isDone).count, total: mixed.count, items: ordered(mixed))
    }

    private static func writing(at level: Level, sessions: [SessionRecord]) -> Part {
        let written = sessions.filter { $0.kind == .writing }
        let texted = Set(written.map(\.title))
        let items = WritingContent.chats(at: level).map { chat in
            Item(target: .chat(chat.id), title: .chat(chat.contact), subtitle: .german(chat.preview),
                 systemImage: chat.groupImage ?? "bubble.left.and.bubble.right.fill",
                 isDone: texted.contains(chat.contact))
        }
        return Part(kind: .write, done: written.count, total: 0, items: ordered(items))
    }

    private static func words(at level: Level, items: [MemoryItem]) -> Part {
        let added = CollectionMemory.addedTitles(items)
        let collections = WordCollections.ordered(for: level).filter { $0.level == level }
        let shown = collections.map { collection in
            Item(target: .collection(collection.id), title: .german(collection.title),
                 subtitle: .resource(collection.subtitle), systemImage: collection.systemImage,
                 isDone: added.contains(collection.title))
        }
        return Part(kind: .words, done: shown.filter(\.isDone).count, total: shown.count, items: ordered(shown))
    }
}
