//
//  TalkTopic.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 12.11.26.
//

import Foundation

/// Something to talk about for 60 seconds.
struct TalkTopic: Identifiable, Hashable, Sendable {
    /// Easier topics about the learner's own life, or ones that need opinions and stories.
    enum Band: Sendable {
        case beginner, independent
    }

    let id: String
    let band: Band
    /// In German, as the learner will talk: "Meine Familie".
    let title: String
    /// A question to get going: "Wer gehört zu deiner Familie?".
    let question: String
    /// What the topic means, for the learner who doesn't know the words yet.
    let english: LocalizedStringResource

    static func == (lhs: TalkTopic, rhs: TalkTopic) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

/// The topics, chosen by the learner's level.
enum TalkTopics {
    /// A1 and A2 talk about their own life; from B1 the harder topics join in.
    static func topics(for level: Level) -> [TalkTopic] {
        level <= .a2 ? all.filter { $0.band == .beginner } : all
    }

    /// A random topic for `level`, never `current` again when there is another.
    static func random(for level: Level, not current: TalkTopic? = nil,
                       using generator: inout some RandomNumberGenerator) -> TalkTopic {
        let topics = topics(for: level)
        let others = topics.filter { $0 != current }
        return (others.isEmpty ? topics : others).randomElement(using: &generator) ?? all[0]
    }

    static let all: [TalkTopic] = [
        TalkTopic(id: "family", band: .beginner, title: "Meine Familie",
                  question: "Wer gehört zu deiner Familie?", english: "My family"),
        TalkTopic(id: "day", band: .beginner, title: "Mein Tag",
                  question: "Was machst du an einem normalen Tag?", english: "My day"),
        TalkTopic(id: "food", band: .beginner, title: "Mein Lieblingsessen",
                  question: "Was isst du gern, und wer kocht es?", english: "My favourite food"),
        TalkTopic(id: "flat", band: .beginner, title: "Meine Wohnung",
                  question: "Wie sieht deine Wohnung aus?", english: "My flat"),
        TalkTopic(id: "weekend", band: .beginner, title: "Mein Wochenende",
                  question: "Was hast du am Wochenende gemacht?", english: "My weekend"),
        TalkTopic(id: "hobbies", band: .beginner, title: "Meine Hobbys",
                  question: "Was machst du in deiner Freizeit?", english: "My hobbies"),
        TalkTopic(id: "city", band: .beginner, title: "Meine Stadt",
                  question: "Wo wohnst du, und was gibt es dort?", english: "My town"),
        TalkTopic(id: "weather", band: .beginner, title: "Das Wetter",
                  question: "Wie ist das Wetter heute, und welches Wetter magst du?", english: "The weather"),
        TalkTopic(id: "friend", band: .beginner, title: "Ein guter Freund",
                  question: "Wer ist dein bester Freund oder deine beste Freundin?", english: "A good friend"),
        TalkTopic(id: "work", band: .beginner, title: "Meine Arbeit",
                  question: "Was arbeitest oder lernst du?", english: "My work"),

        TalkTopic(id: "film", band: .independent, title: "Ein Film, den ich empfehle",
                  question: "Welchen Film oder welche Serie sollte man sehen, und warum?", english: "A film I recommend"),
        TalkTopic(id: "trip", band: .independent, title: "Eine Reise, die ich nie vergesse",
                  question: "Wohin bist du gereist, und was ist passiert?", english: "A trip I'll never forget"),
        TalkTopic(id: "germany", band: .independent, title: "Was mich in Deutschland überrascht hat",
                  question: "Was war am Anfang neu oder komisch für dich?", english: "What surprised me in Germany"),
        TalkTopic(id: "dream-job", band: .independent, title: "Mein Traumjob",
                  question: "Was würdest du gern arbeiten, wenn alles möglich wäre?", english: "My dream job"),
        TalkTopic(id: "city-country", band: .independent, title: "Stadt oder Land?",
                  question: "Wo lebt man besser, und warum?", english: "City or countryside?"),
        TalkTopic(id: "phone", band: .independent, title: "Ein Tag ohne Handy",
                  question: "Wie wäre ein Tag ohne dein Handy?", english: "A day without my phone"),
        TalkTopic(id: "learned", band: .independent, title: "Etwas, das ich gelernt habe",
                  question: "Was hast du in letzter Zeit gelernt, und wie?", english: "Something I learned"),
        TalkTopic(id: "home-office", band: .independent, title: "Homeoffice oder Büro?",
                  question: "Wo arbeitest du lieber, und was sind die Vorteile?", english: "Working from home or the office?"),
        TalkTopic(id: "tradition", band: .independent, title: "Ein Fest aus meiner Heimat",
                  question: "Welches Fest feiert ihr, und wie?", english: "A celebration from my home country"),
        TalkTopic(id: "ten-years", band: .independent, title: "Mein Leben in zehn Jahren",
                  question: "Wie stellst du dir dein Leben in zehn Jahren vor?", english: "My life in ten years")
    ]
}
