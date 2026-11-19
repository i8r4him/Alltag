//
//  DailyLesson.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftUI

/// The parts of today's lesson, in the order they are played.
enum LessonPart: String, CaseIterable, Identifiable {
    case words, grammar, read, write, mistakes

    var id: Self { self }

    var name: LocalizedStringResource {
        switch self {
        case .words: "Words"
        case .grammar: "Grammar"
        case .read: "Read"
        case .write: "Write"
        case .mistakes: "Your mistakes"
        }
    }

    var systemImage: String {
        switch self {
        case .words: "square.stack.fill"
        case .grammar: "text.badge.checkmark"
        case .read: "envelope.open.fill"
        case .write: "square.and.pencil"
        case .mistakes: "arrow.counterclockwise"
        }
    }
}

/// What a step of the lesson opens: one of the exercises Learn already has.
enum LessonTarget: Hashable {
    /// A word collection, by id.
    case collection(String)
    /// A grammar rule, by id.
    case rule(String)
    /// A text to read, by id.
    case text(String)
    /// A "Read and do" scene, by id.
    case scene(String)
    /// A chat with a friend in Write, by id.
    case chat(String)
    /// The learner's due mistakes.
    case mistakes
}

/// What a step is called on the card.
enum LessonTitle {
    /// Content in German, such as a rule's or a collection's name.
    case german(String)
    /// Content with an English title, such as a text from daily life.
    case resource(LocalizedStringResource)
    /// "Text Lena".
    case chat(String)
    /// "Fix 3 mistakes".
    case mistakes(Int)
    /// The mistakes were practised today.
    case mistakesPractised

    var text: Text {
        switch self {
        case .german(let title): Text(verbatim: title)
        case .resource(let title): Text(title)
        case .chat(let contact): Text("Text \(contact)")
        case .mistakes(let count): Text("Fix ^[\(count) mistake](inflect: true)")
        case .mistakesPractised: Text("Mistakes practised")
        }
    }
}

/// One step of today's lesson: a real exercise from one part of Learn.
struct LessonStep: Identifiable {
    let part: LessonPart
    let target: LessonTarget
    let title: LessonTitle
    /// A taste of it, as written (German or the rule's line), for the cards that show one.
    let preview: String?
    let systemImage: String
    /// About how long it takes.
    let minutes: Int
    /// Done today.
    let isDone: Bool

    var id: LessonPart { part }
}

/// Today's lesson: one thing from each part of Learn, played one after
/// another, about fifteen minutes in all. Every step is an exercise Learn
/// already has, chosen from the learner's real progress: the next word
/// collection, the next rule, the next text, a chat, and the mistakes due.
/// A step is done once its exercise was finished today (a rule solved, a text
/// read, a chat written, words saved), so the lesson moves on by itself.
enum DailyLesson {
    /// What the learner has done, read from SwiftData by the view.
    struct Records {
        var solvedRules: [SolvedRule] = []
        /// Reading and writing sessions.
        var sessions: [SessionRecord] = []
        /// Words saved from collections.
        var collectionWords: [MemoryItem] = []
        var dueMistakes = 0
        /// The learner practised their mistakes from the lesson today.
        var fixedMistakesToday = false
    }

    static func steps(at level: Level, records: Records, on date: Date = .now,
                      calendar: Calendar = .current) -> [LessonStep] {
        let isToday = { (other: Date) in calendar.isDate(other, inSameDayAs: date) }
        let day = calendar.ordinality(of: .day, in: .era, for: date) ?? 0
        return [
            words(at: level, items: records.collectionWords, isToday: isToday),
            grammar(at: level, solved: records.solvedRules, isToday: isToday),
            reading(at: level, sessions: records.sessions, isToday: isToday, day: day),
            writing(at: level, sessions: records.sessions, isToday: isToday),
            mistakes(due: records.dueMistakes, fixedToday: records.fixedMistakesToday)
        ].compactMap(\.self)
    }

    /// The first step not done yet, or `nil` when the lesson is done.
    static func current(in steps: [LessonStep]) -> LessonStep? {
        steps.first { !$0.isDone }
    }

    /// The minutes still to go.
    static func minutesLeft(in steps: [LessonStep]) -> Int {
        steps.filter { !$0.isDone }.map(\.minutes).reduce(0, +)
    }

    /// A key for the day, for remembering the mistakes were fixed today.
    static func dayKey(for date: Date = .now, calendar: Calendar = .current) -> String {
        let parts = calendar.dateComponents([.year, .month, .day], from: date)
        return "\(parts.year ?? 0)-\(parts.month ?? 0)-\(parts.day ?? 0)"
    }

    // MARK: - The parts

    /// Words: the collection saved today, or the next one not in Memory, the learner's level first.
    private static func words(at level: Level, items: [MemoryItem], isToday: (Date) -> Bool) -> LessonStep? {
        let savedToday = items.filter { $0.source == .collection && isToday($0.createdAt) }
            .max { $0.createdAt < $1.createdAt }
        let added = CollectionMemory.addedTitles(items)
        let ordered = WordCollections.ordered(for: level)
        let done = savedToday.flatMap { item in ordered.first { $0.title == item.sourceDetail } }
        guard let collection = done ?? ordered.first(where: { !added.contains($0.title) }) else { return nil }
        let preview = collection.words.prefix(3).map(\.displayWord).joined(separator: " · ")
        return LessonStep(part: .words, target: .collection(collection.id), title: .german(collection.title),
                          preview: preview, systemImage: collection.systemImage, minutes: 2, isDone: done != nil)
    }

    /// Grammar: the rule solved today, or the next rule, as Grammar's "Your next rule" chooses it.
    private static func grammar(at level: Level, solved: [SolvedRule], isToday: (Date) -> Bool) -> LessonStep? {
        let solvedToday = solved.filter { isToday($0.solvedAt) }.max { $0.solvedAt < $1.solvedAt }
        let done = solvedToday.flatMap { MockRules.rule(id: $0.ruleID) }
        let next = GrammarProgress(solved: solved).nextRule(at: GrammarProgress.initialLevel(for: level))?.rule
        guard let rule = done ?? next else { return nil }
        return LessonStep(part: .grammar, target: .rule(rule.id), title: .german(rule.title), preview: rule.rule,
                          systemImage: rule.systemImage, minutes: 4, isDone: done != nil)
    }

    /// Read: what was read today, or the next text on one day and the next "Read and do" on the next.
    private static func reading(at level: Level, sessions: [SessionRecord], isToday: (Date) -> Bool,
                                day: Int) -> LessonStep? {
        let records = sessions.filter { $0.kind == .reading }
        let readToday = records.filter { isToday($0.date) }.sorted { $0.date > $1.date }
            .lazy.compactMap { ReadingProgress.readIDs(in: [$0]).first }.first
        if let readToday {
            if let text = ReadingTexts.text(id: readToday) { return step(for: text, isDone: true) }
            if let scene = ReadDoScenes.scene(id: readToday) { return step(for: scene, isDone: true) }
        }
        let read = ReadingProgress.readIDs(in: records)
        let texts = ReadingTexts.texts(at: level)
        let scenes = ReadDoScenes.scenes(at: level)
        let text = ReadingProgress.next(at: level, read: read) ?? texts.first
        let scene = scenes.first { !read.contains($0.id) } ?? scenes.first
        if day.isMultiple(of: 2), let text { return step(for: text, isDone: false) }
        if let scene { return step(for: scene, isDone: false) }
        return text.map { step(for: $0, isDone: false) }
    }

    private static func step(for text: ReadingText, isDone: Bool) -> LessonStep {
        let firstLine = text.german.split(separator: "\n").first.map(String.init)
        return LessonStep(part: .read, target: .text(text.id), title: .resource(text.title), preview: firstLine,
                          systemImage: text.systemImage, minutes: text.minutes + 2, isDone: isDone)
    }

    private static func step(for scene: ReadDoScene, isDone: Bool) -> LessonStep {
        LessonStep(part: .read, target: .scene(scene.id), title: .resource(scene.title), preview: nil,
                   systemImage: scene.systemImage, minutes: 3, isDone: isDone)
    }

    /// Write: a chat with a friend not texted yet (Lena once all have been); done once anything was written today.
    private static func writing(at level: Level, sessions: [SessionRecord], isToday: (Date) -> Bool) -> LessonStep? {
        let records = sessions.filter { $0.kind == .writing }
        let chats = WritingContent.chats(at: level)
        let writtenToday = records.filter { isToday($0.date) }.max { $0.date < $1.date }
        let texted = Set(records.map(\.title))
        let doneChat = writtenToday.flatMap { record in chats.first { $0.contact == record.title } }
        guard let chat = doneChat ?? chats.first(where: { !texted.contains($0.contact) }) ?? chats.first else { return nil }
        // Written today, but not a chat (an email, a topic): it counts, under its own title.
        let title: LessonTitle = if let writtenToday, doneChat == nil { .german(writtenToday.title) } else { .chat(chat.contact) }
        return LessonStep(part: .write, target: .chat(chat.id), title: title, preview: chat.preview,
                          systemImage: chat.groupImage ?? "bubble.left.and.bubble.right.fill", minutes: 4,
                          isDone: writtenToday != nil)
    }

    /// Your mistakes: only when some are due, or were practised from the lesson today. A wrong
    /// answer is due again at once, so practising them is what counts, not none being left.
    private static func mistakes(due: Int, fixedToday: Bool) -> LessonStep? {
        if fixedToday {
            return LessonStep(part: .mistakes, target: .mistakes, title: .mistakesPractised, preview: nil,
                              systemImage: "checkmark.seal.fill", minutes: 2, isDone: true)
        }
        guard due > 0 else { return nil }
        return LessonStep(part: .mistakes, target: .mistakes, title: .mistakes(due), preview: nil,
                          systemImage: LessonPart.mistakes.systemImage, minutes: 2, isDone: false)
    }
}
