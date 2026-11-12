//
//  TalkTopic.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 12.11.26.
//

import Foundation

/// Something to talk about for 60 seconds, written for one level.
struct TalkTopic: Identifiable, Hashable, Sendable {
    let id: String
    let level: Level
    /// In German, as the learner will talk: "Meine Familie".
    let title: String
    /// A question to get going: "Wer gehört zu deiner Familie?".
    let question: String
    /// What the topic means, for the learner who doesn't know the words yet.
    let english: LocalizedStringResource

    /// Short, so the lists stay readable: level, number in the list, title, question, English.
    init(_ level: Level, _ number: Int, _ title: String, _ question: String, _ english: LocalizedStringResource) {
        self.id = "\(level.rawValue)-\(number)"
        self.level = level
        self.title = title
        self.question = question
        self.english = english
    }

    static func == (lhs: TalkTopic, rhs: TalkTopic) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

/// The topics: 50 for each level from A1 to C1, in `TalkTopics+A1.swift` and so on.
///
/// A learner only gets topics written for their level, so nothing is too hard
/// for A1 or too easy for C1:
/// - **A1** names things in their own life, in the present.
/// - **A2** tells what happened and what is planned.
/// - **B1** tells experiences and gives an opinion with a reason.
/// - **B2** argues about questions of work and society.
/// - **C1** weighs abstract ideas.
enum TalkTopics {
    /// The topics for `level`. C2 has no list of its own and uses C1's.
    static func topics(for level: Level) -> [TalkTopic] {
        switch level {
        case .a1: a1
        case .a2: a2
        case .b1: b1
        case .b2: b2
        case .c1, .c2: c1
        }
    }

    static var all: [TalkTopic] { a1 + a2 + b1 + b2 + c1 }

    /// A random topic for `level`, never `current` again.
    static func random(for level: Level, not current: TalkTopic? = nil,
                       using generator: inout some RandomNumberGenerator) -> TalkTopic {
        let topics = topics(for: level)
        let others = topics.filter { $0 != current }
        return (others.isEmpty ? topics : others).randomElement(using: &generator) ?? a1[0]
    }
}
