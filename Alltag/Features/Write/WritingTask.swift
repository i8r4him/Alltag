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
    /// A message, an email, a complaint, about the learner's day, or their own topic.
    var kind = WritingKind.message
    /// Which two of the points a quick text keeps (their places, from 0).
    var quickPoints = [0, 2]

    /// Roughly how long it takes: about 15 words a minute, at least two minutes.
    var minutes: Int { max(2, Int((Double(maxWords) / 15).rounded())) }

    /// The task as the server's check reads it. Empty for the learner's own topic,
    /// which has no task to check against.
    var brief: String {
        guard kind != .own else { return "" }
        let numbered = points.enumerated().map { "\($0.offset + 1). \($0.element)" }.joined(separator: "\n")
        let recipientLine = recipient.isEmpty
            ? "A personal text with no recipient."
            : "To: \(recipient). Register: \(register == .formal ? "formal (Sie)" : "informal (du)")."
        return """
        \(title). \(situation)
        \(recipientLine)
        Points:
        \(numbered)
        Length: \(minWords) to \(maxWords) words.
        """
    }

    /// The length a full text at `level` should have, as in an exam.
    static func wordRange(for level: Level) -> ClosedRange<Int> {
        WritingLength.exam.wordRange(for: level)
    }

    /// The task at the length the learner has time for: the word range follows the
    /// length, and a quick text keeps two of the three points.
    func sized(_ length: WritingLength) -> WritingTask {
        var task = self
        let range = length.wordRange(for: level)
        task.minWords = range.lowerBound
        task.maxWords = range.upperBound
        if points.count > length.pointCount {
            let kept = quickPoints.filter(points.indices.contains).prefix(length.pointCount).map { points[$0] }
            task.points = kept.count == length.pointCount ? kept : Array(points.prefix(length.pointCount))
        }
        return task
    }

    /// "My own topic": no task, the learner writes what they like and gets the same correction.
    static func own(level: Level, length: WritingLength) -> WritingTask {
        let range = length.wordRange(for: level)
        return WritingTask(id: "own", level: level, title: String(localized: "My own topic"),
                           situation: String(localized:
                               "Write about anything you like: your day, a plan, an opinion, a story. You get the same correction."),
                           recipient: "", register: .informal, points: [], minWords: range.lowerBound,
                           maxWords: range.upperBound, systemImage: WritingKind.own.systemImage, phrases: [], kind: .own)
    }
}

extension WritingTask {
    /// Short, so the written set stays readable.
    init(_ level: Level, _ number: Int, _ systemImage: String, _ register: Register, _ kind: WritingKind = .message,
         title: String, situation: String, recipient: String = "", points: [String], quick: [Int] = [0, 2],
         phrases: [Phrase]) {
        let range = Self.wordRange(for: level)
        self.init(id: "\(level.rawValue)-\(number)", level: level, title: title, situation: situation,
                  recipient: recipient, register: register, points: points, minWords: range.lowerBound,
                  maxWords: range.upperBound, systemImage: systemImage, phrases: phrases, kind: kind, quickPoints: quick)
    }
}

/// The written set for each level from A1 to C1, in `WritingTasks+A.swift` and so on: messages,
/// emails, complaints and texts about the learner's day.
/// Each level writes what that level can: A1 short notes in the present, A2 messages with reasons,
/// B1 letters that explain and ask, B2 formal emails that argue, C1 nuanced formal correspondence.
enum WritingTasks {
    static func tasks(for level: Level, kind: WritingKind? = nil) -> [WritingTask] {
        let written = switch level {
        case .a1: a1
        case .a2: a2
        case .b1: b1
        case .b2: b2
        case .c1, .c2: c1
        }
        let all = written + more.filter { $0.level == written[0].level }
        guard let kind else { return all }
        return all.filter { $0.kind == kind }
    }

    /// The task of the day for `level` (and `kind`, when one is chosen): the same all day, another one tomorrow.
    static func picked(for level: Level, kind: WritingKind? = nil, on date: Date = .now,
                       calendar: Calendar = .current) -> WritingTask {
        let tasks = tasks(for: level, kind: kind)
        let day = calendar.ordinality(of: .day, in: .era, for: date) ?? 0
        return tasks[day % tasks.count]
    }
}
