//
//  WritingTask.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// Something to write, as in a German exam's "Schreiben" part: a real
/// situation, who it is to, and three things the text must say.
/// The written set (`WritingTasks`) works offline; the server writes new ones.
struct WritingTask: Codable, Hashable, Identifiable, Sendable {
    /// Sie or du.
    enum Register: String, Codable, Sendable { case formal, informal }

    /// A German phrase that helps with this text, and what it means.
    struct Phrase: Codable, Hashable, Sendable {
        var german: String
        var english: String

        init(_ german: String, _ english: String) {
            self.german = german
            self.english = english
        }
    }

    var id: String
    var level: Level
    /// An instruction in English: "Tell your landlord the light is broken".
    var title: String
    /// One or two sentences that set the scene.
    var situation: String
    /// "Your landlord, Herr Becker".
    var recipient: String
    var register: Register
    /// The three things the text must say.
    var points: [String]
    var minWords: Int
    var maxWords: Int
    var systemImage: String
    var phrases: [Phrase]
    /// Written by the server for this learner, not part of the written set.
    var isGenerated = false

    /// Roughly how long it takes: about 15 words a minute, at least two minutes.
    var minutes: Int { max(2, Int((Double(maxWords) / 15).rounded())) }

    /// The task as the server's check reads it.
    var brief: String {
        let numbered = points.enumerated().map { "\($0.offset + 1). \($0.element)" }.joined(separator: "\n")
        return """
        \(title). \(situation)
        To: \(recipient). Register: \(register == .formal ? "formal (Sie)" : "informal (du)").
        Points:
        \(numbered)
        Length: \(minWords) to \(maxWords) words.
        """
    }

    /// The length a text at `level` should have.
    static func wordRange(for level: Level) -> ClosedRange<Int> {
        switch level {
        case .a1: 20...40
        case .a2: 40...70
        case .b1: 80...120
        case .b2: 120...180
        case .c1, .c2: 180...250
        }
    }
}

extension WritingTask {
    /// Short, so the written set stays readable.
    init(_ level: Level, _ number: Int, _ systemImage: String, _ register: Register, title: String,
         situation: String, recipient: String, points: [String], phrases: [Phrase]) {
        let range = Self.wordRange(for: level)
        self.init(id: "\(level.rawValue)-\(number)", level: level, title: title, situation: situation,
                  recipient: recipient, register: register, points: points, minWords: range.lowerBound,
                  maxWords: range.upperBound, systemImage: systemImage, phrases: phrases)
    }
}

/// The written set: six tasks for each level from A1 to C1, in `WritingTasks+A1.swift` and so on.
/// Each level writes what that level can: A1 short notes in the present, A2 messages with reasons,
/// B1 letters that explain and ask, B2 formal emails that argue, C1 nuanced formal correspondence.
enum WritingTasks {
    static func tasks(for level: Level) -> [WritingTask] {
        switch level {
        case .a1: a1
        case .a2: a2
        case .b1: b1
        case .b2: b2
        case .c1, .c2: c1
        }
    }

    /// The task of the day for `level`: the same all day, another one tomorrow.
    static func picked(for level: Level, on date: Date = .now, calendar: Calendar = .current) -> WritingTask {
        let tasks = tasks(for: level)
        let day = calendar.ordinality(of: .day, in: .era, for: date) ?? 0
        return tasks[day % tasks.count]
    }
}
