//
//  ReadDoScene.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// What a "Read and do" task is read from: things you read to get something
/// done, not to answer questions about them.
enum ReadDoKind: String, CaseIterable, Hashable, Sendable {
    case departures
    case sign
    case packaging
    case form
    case receipt
    case binCalendar
    case bill
    case payslip

    var title: LocalizedStringResource {
        switch self {
        case .departures: "Departure board"
        case .sign: "Sign"
        case .packaging: "Packaging"
        case .form: "Form"
        case .receipt: "Receipt"
        case .binCalendar: "Bin calendar"
        case .bill: "Bill"
        case .payslip: "Pay slip"
        }
    }
}

/// One line of the thing: a heading, a row of a table, a field of a form.
struct ReadDoLine: Identifiable, Hashable, Sendable {
    enum Style: Hashable, Sendable {
        /// "# Abfahrt": the big title.
        case heading
        /// "## Zutaten": a small label over a part.
        case label
        /// "09:42 | RE 5 | Koblenz | 3": cells side by side.
        case row
        /// "Geburtsdatum: ___": a field to write in.
        case field
        /// "---": a line across, not something to tap.
        case rule
        /// Anything else.
        case text
    }

    let id: Int
    let style: Style
    let cells: [String]

    /// The line as written, for finding an answer in it: the cells joined by " | ".
    var plain: String { cells.joined(separator: " | ") }
    var isTappable: Bool { style != .rule }

    /// Reads one line of a scene's content.
    init(id: Int, source: String) {
        self.id = id
        let line = source.trimmingCharacters(in: .whitespaces)
        if line == "---" {
            style = .rule
            cells = []
        } else if line.hasPrefix("## ") {
            style = .label
            cells = [String(line.dropFirst(3))]
        } else if line.hasPrefix("# ") {
            style = .heading
            cells = [String(line.dropFirst(2))]
        } else if line.contains(" | ") {
            style = .row
            cells = line.components(separatedBy: " | ").map { $0.trimmingCharacters(in: .whitespaces) }
        } else if line.hasSuffix("___") {
            style = .field
            cells = [line.replacingOccurrences(of: "_", with: "").trimmingCharacters(in: .whitespaces)]
        } else {
            style = .text
            cells = [line]
        }
    }
}

/// One task: find the line that answers it, and tap it.
struct ReadDoTask: Hashable, Sendable {
    /// In English, e.g. "Which train gets you to Koblenz?"
    let prompt: String
    /// Words of the line to tap, as they stand in it; they are on that line only.
    let answer: String
}

/// A thing from daily life drawn as it looks, with three tasks to do by
/// tapping the right line in it: a departure board, a sign, a receipt.
/// Written for the app, like the texts to read.
struct ReadDoScene: Identifiable, Hashable {
    /// Stable, so progress can find it: "a1-do-bakery".
    let id: String
    let level: Level
    let kind: ReadDoKind
    let title: LocalizedStringResource
    let detail: LocalizedStringResource
    let systemImage: String
    let lines: [ReadDoLine]
    let tasks: [ReadDoTask]

    /// `content` has one line of the thing per line: "# " a heading, "## " a
    /// label, " | " between cells, "___" at the end of a field, "---" a rule.
    init(id: String, level: Level, kind: ReadDoKind, title: LocalizedStringResource,
         detail: LocalizedStringResource, systemImage: String, content: String, tasks: [ReadDoTask]) {
        self.id = id
        self.level = level
        self.kind = kind
        self.title = title
        self.detail = detail
        self.systemImage = systemImage
        self.lines = content.split(separator: "\n", omittingEmptySubsequences: true)
            .enumerated().map { ReadDoLine(id: $0.offset, source: String($0.element)) }
        self.tasks = tasks
    }

    /// The lines that hold a task's answer; exactly one in written content.
    func lines(answering task: ReadDoTask) -> [ReadDoLine] {
        lines.filter { $0.isTappable && $0.plain.contains(task.answer) }
    }

    static func == (lhs: ReadDoScene, rhs: ReadDoScene) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

/// Every "Read and do" scene, by level. C2 does C1's.
enum ReadDoScenes {
    static let all: [ReadDoScene] = a1 + a2 + b1 + b2 + c1

    static func scenes(at level: Level) -> [ReadDoScene] {
        let level = level == .c2 ? .c1 : level
        return all.filter { $0.level == level }
    }

    static func scene(id: String) -> ReadDoScene? {
        all.first { $0.id == id }
    }
}
