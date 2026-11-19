//
//  WritingBrief.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// What the learner writes: a formal email, a text about a topic or a form,
/// with everything the writing screen shows and the teacher needs to mark it.
struct WritingBrief: Hashable, Sendable {
    enum Kind: Hashable, Sendable {
        case formalEmail, topic, form
    }

    let kind: Kind
    let level: Level
    /// What the text is, in German: the screen's title and the session's.
    let title: String
    /// The situation or the form's question, in German.
    let situation: String
    /// The email to answer, if the task is a reply.
    var email: FormalEmail?
    /// What the text must say, in German.
    var points: [String] = []
    /// The form's short fields (name, course), filled in but not checked.
    var fields: [String] = []
    /// About how many words to write.
    let words: Int

    /// Enough words to count as the length asked for: four fifths of it.
    var enoughWords: Int { max(3, words * 4 / 5) }

    /// The task as the teacher reads it (the `write` function's `task`).
    var task: String {
        var lines: [String]
        switch kind {
        case .formalEmail:
            lines = ["A formal email or letter in German (Sie), with a greeting (Anrede) and a closing (Gruß), "
                + "about \(words) words, as a language course sets it.", "Situation: \(situation)"]
            if let email {
                lines.append("The email to answer, from \(email.sender), subject „\(email.subject)“:\n\(email.body)")
            }
        case .topic:
            lines = ["A short text on the topic „\(title)“, about \(words) words. No recipient: the learner writes "
                + "about their own life or opinion."]
        case .form:
            lines = ["A form „\(title)“. The learner answers the question „\(situation)“ in full sentences, "
                + "about \(words) words."]
        }
        if points.isEmpty {
            lines.append("No numbered points.")
        } else {
            lines.append("Points:\n" + points.enumerated().map { "\($0.offset + 1). \($0.element)" }.joined(separator: "\n"))
        }
        return lines.joined(separator: "\n")
    }
}

extension WritingBrief {
    /// `level` is the learner's: C2 writes C1's tasks, at C2's length.
    init(_ task: FormalTask, level: Level) {
        self.init(kind: .formalEmail, level: level, title: task.title, situation: task.situation,
                  email: task.email, points: task.points, words: WritingLength.formalWords(for: level))
    }

    init(_ topic: WritingTopic, level: Level) {
        self.init(kind: .topic, level: level, title: topic.title, situation: "",
                  words: WritingLength.words(for: level))
    }

    init(_ form: WritingForm, level: Level) {
        self.init(kind: .form, level: level, title: form.title, situation: form.question, fields: form.fields,
                  words: WritingLength.formWords(for: level))
    }
}
