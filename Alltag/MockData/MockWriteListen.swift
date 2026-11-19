//
//  MockWriteListen.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import Foundation

/// How a message sounds: to a friend (*du*) or formal (*Sie*).
enum WritingTone { case everyday, formal }

/// A phrase for the start or end of a message, in German.
struct WritingPhrase: Identifiable {
    let id = UUID()
    let role: LocalizedStringResource
    let german: String
}

/// A German friend, or a group, the learner texts with.
struct WritingChat: Identifiable {
    let id: String
    /// What the chat is about.
    let title: LocalizedStringResource
    /// The friend's or the group's name, in German.
    let contact: String
    /// The friend's last message, in German.
    let preview: String
    /// A group shows this symbol instead of an initial.
    var groupImage: String?
    var isUnread = false

    var initial: String { String(contact.prefix(1)) }
}

/// A title to write about, at one level.
struct WritingTopic: Identifiable {
    /// The title, in German.
    let title: String
    let level: Level
    let systemImage: String

    var id: String { title }
}

/// A short audio clip from daily life.
struct ListeningClip: Identifiable {
    let id = UUID()
    let title: LocalizedStringResource
    let detail: LocalizedStringResource
    /// The length, e.g. "0:40".
    let length: String
    let systemImage: String
}

/// Sample content for Write until the chat and the topics are built.
enum MockWriting {
    /// The friend's first messages in the chat.
    static let friendMessages = ["Heyy 👋", "Hast du heute Abend Bock auf Kino? 🎬"]

    static let chats = [
        WritingChat(id: "kino", title: "Plan the evening", contact: "Lena",
                    preview: "Hast du heute Abend Bock auf Kino? 🎬", isUnread: true),
        WritingChat(id: "wg", title: "The WG cleaning plan", contact: "WG Kölner Str. 12",
                    preview: "Wer ist diese Woche mit dem Bad dran? 🧽", groupImage: "person.3.fill"),
        WritingChat(id: "party", title: "Birthday wishes", contact: "Jonas",
                    preview: "Morgen ist meine Party 🎉 Kommst du?")
    ]

    static let topics = [
        WritingTopic(title: "Mein Wochenende", level: .a1, systemImage: "sun.max.fill"),
        WritingTopic(title: "Meine Familie", level: .a1, systemImage: "figure.2.and.child.holdinghands"),
        WritingTopic(title: "Mein Lieblingsessen", level: .a1, systemImage: "fork.knife"),
        WritingTopic(title: "Meine Wohnung", level: .a2, systemImage: "house.fill"),
        WritingTopic(title: "Ein Tag in meinem Leben", level: .a2, systemImage: "clock.fill"),
        WritingTopic(title: "Mein letzter Urlaub", level: .a2, systemImage: "airplane"),
        WritingTopic(title: "Mein Lieblingsort in der Stadt", level: .b1, systemImage: "mappin.and.ellipse"),
        WritingTopic(title: "Sport im Alltag", level: .b1, systemImage: "figure.run"),
        WritingTopic(title: "Soziale Medien: Fluch oder Segen?", level: .b1, systemImage: "iphone"),
        WritingTopic(title: "Wohnen in der Stadt oder auf dem Land?", level: .b2, systemImage: "building.2.fill"),
        WritingTopic(title: "Sollten Bus und Bahn kostenlos sein?", level: .b2, systemImage: "tram.fill"),
        WritingTopic(title: "Arbeiten im Homeoffice", level: .b2, systemImage: "laptopcomputer"),
        WritingTopic(title: "Sollte Homeoffice ein Recht sein?", level: .c1, systemImage: "briefcase.fill"),
        WritingTopic(title: "Künstliche Intelligenz im Alltag", level: .c1, systemImage: "cpu"),
        WritingTopic(title: "Der Wert des Ehrenamts", level: .c1, systemImage: "hands.sparkles.fill")
    ]

    /// The topics at `level`; C2 gets C1's.
    static func topics(at level: Level) -> [WritingTopic] {
        let shown = topics.filter { $0.level == level }
        return shown.isEmpty ? topics.filter { $0.level == .c1 } : shown
    }

    static let formalPhrases = [
        WritingPhrase(role: "Opening", german: "Sehr geehrte Damen und Herren,"),
        WritingPhrase(role: "Asking", german: "Könnten Sie mir bitte mitteilen, …"),
        WritingPhrase(role: "Thanks", german: "Vielen Dank im Voraus."),
        WritingPhrase(role: "Closing", german: "Mit freundlichen Grüßen")
    ]

    static let informalPhrases = [
        WritingPhrase(role: "Opening", german: "Liebe Anna, / Lieber Tom,"),
        WritingPhrase(role: "Asking", german: "Hast du Lust, …?"),
        WritingPhrase(role: "Thanks", german: "Danke dir!"),
        WritingPhrase(role: "Closing", german: "Viele Grüße")
    ]

    static func phrases(_ tone: WritingTone) -> [WritingPhrase] {
        tone == .formal ? formalPhrases : informalPhrases
    }
}

/// Sample content for Listen until listening is built.
enum MockListening {
    static let picked = ListeningClip(title: "Platform change in Munich", detail: "For your trip on Friday.",
                                      length: "1:00", systemImage: "tram.fill")

    static let clips = [
        ListeningClip(title: "A voicemail from the doctor", detail: "Your test results",
                      length: "0:40", systemImage: "phone.fill"),
        ListeningClip(title: "At the supermarket", detail: "An announcement",
                      length: "0:25", systemImage: "cart.fill"),
        ListeningClip(title: "The weather on the radio", detail: "The weekend",
                      length: "1:10", systemImage: "cloud.sun.fill"),
        ListeningClip(title: "A parcel delivery call", detail: "Where to leave it",
                      length: "0:50", systemImage: "shippingbox.fill"),
        ListeningClip(title: "On hold at the Bürgeramt", detail: "Music and a message",
                      length: "0:35", systemImage: "building.columns.fill")
    ]
}
