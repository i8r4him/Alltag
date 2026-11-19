//
//  MockWriteListen.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import Foundation

/// A German friend, or a group, the learner texts with.
struct WritingChat: Identifiable {
    let id: String
    /// The friend's or the group's name, in German.
    let contact: String
    /// The friend's last message, in German.
    let preview: String
    /// A group shows this symbol instead of an initial.
    var groupImage: String?
    var isUnread = false

    var initial: String { String(contact.prefix(1)) }
}

/// A formal email to answer, in German.
struct FormalEmail {
    let sender: String
    let subject: String
    let body: String
}

/// A formal email as a language course or exam sets it, in German: the
/// situation and the points to write about, sometimes an email to answer.
struct FormalTask {
    let level: Level
    /// The email to answer, if the task is a reply.
    var email: FormalEmail?
    let situation: String
    let points: [String]
}

/// A German form to fill in; its last field asks for full sentences.
struct WritingForm {
    let title: String
    let fields: [String]
    let question: String
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
    /// The chats at `level`: the friends write the way people text at that level.
    static func chats(at level: Level) -> [WritingChat] {
        let messages = previews(at: level)
        return [
            WritingChat(id: "lena", contact: "Lena", preview: messages[0], isUnread: true),
            WritingChat(id: "wg", contact: "WG Kölner Str. 12", preview: messages[1], groupImage: "person.3.fill"),
            WritingChat(id: "jonas", contact: "Jonas", preview: messages[2])
        ]
    }

    /// Lena's, the group's and Jonas's last message.
    private static func previews(at level: Level) -> [String] {
        switch level {
        case .a1:
            ["Hallo! Wie geht's? 😊", "Wer kauft heute Milch? 🥛", "Am Samstag ist meine Party. Kommst du?"]
        case .a2:
            ["Hast du heute Abend Zeit? Kino? 🎬", "Wer putzt diese Woche das Bad? 🧽", "Morgen ist meine Party 🎉 Kommst du?"]
        case .b1:
            ["Hast du heute Abend Bock auf Kino? 🎬", "Wer ist diese Woche mit dem Bad dran? 🧽",
             "Party morgen, bist du dabei? 🎉"]
        case .b2:
            ["Sorry, war voll im Stress 😅 Kino heute?", "Leute, der Müll stapelt sich schon wieder… wer ist dran? 🙄",
             "Bin mega aufgeregt wegen morgen! Kommst du auch? 🎉"]
        case .c1, .c2:
            ["Na, lebst du noch? 😄 Lust, heute Abend was zu unternehmen?",
             "Kleine Erinnerung: Der Putzplan hängt nicht nur zur Deko am Kühlschrank 😉",
             "Morgen steigt die Party, diesmal keine Ausreden! 😜"]
        }
    }

    static let formalTasks = [
        FormalTask(level: .a1,
                   situation: "Sie sind krank und können morgen nicht zum Deutschkurs kommen. "
                       + "Schreiben Sie Ihrer Lehrerin, Frau Weber, eine kurze Nachricht.",
                   points: ["Warum Sie nicht kommen", "Bitte um die Hausaufgaben", "Wann Sie wiederkommen"]),
        FormalTask(level: .a2,
                   email: FormalEmail(
                       sender: "Praxis Dr. Sommer", subject: "Ihr Termin am Donnerstag",
                       body: "Sehr geehrte Patientin, sehr geehrter Patient,\nIhr Termin am Donnerstag um 10 Uhr muss leider "
                           + "ausfallen. Bitte schreiben Sie uns, wann Sie Zeit haben."),
                   situation: "Antworten Sie der Praxis.",
                   points: ["Für die Nachricht danken", "Wann Sie Zeit haben", "Ob Sie etwas mitbringen müssen"]),
        FormalTask(level: .b1,
                   situation: "Sie haben im Internet eine Anzeige für einen Deutschkurs gelesen. "
                       + "Schreiben Sie eine E-Mail an die Sprachschule.",
                   points: ["Warum Sie schreiben", "Ihr Deutschniveau", "Wann Sie Zeit haben", "Was der Kurs kostet"]),
        FormalTask(level: .b2,
                   email: FormalEmail(
                       sender: "Hausverwaltung Becker", subject: "Wartung der Heizung",
                       body: "Sehr geehrte Mieterinnen und Mieter,\nam Montag, den 24. November, wird zwischen 8 und 12 Uhr die "
                           + "Heizung gewartet. Bitte teilen Sie uns mit, ob an diesem Vormittag jemand in der Wohnung ist."),
                   situation: "Antworten Sie der Hausverwaltung.",
                   points: ["Sie sind an diesem Vormittag nicht zu Hause", "Einen anderen Termin vorschlagen",
                            "Die Heizung im Bad ist seit Tagen kalt", "Um eine schnelle Lösung bitten"]),
        FormalTask(level: .c1,
                   situation: "Ihre Stadt will die Stadtbibliothek schließen. Schreiben Sie einen Brief an die Bürgermeisterin.",
                   points: ["Warum die Bibliothek wichtig ist", "Wer sie nutzt", "Welche Folgen eine Schließung hätte",
                            "Ein Vorschlag, wie man sie finanzieren könnte"])
    ]

    /// The formal email at `level`; C2 gets C1's.
    static func formalTask(at level: Level) -> FormalTask? {
        formalTasks.first { $0.level == level } ?? formalTasks.first { $0.level == .c1 }
    }

    static let form = WritingForm(title: "Anmeldung zum Deutschkurs", fields: ["Name", "Kurs"],
                                  question: "Warum möchten Sie Deutsch lernen?")

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
