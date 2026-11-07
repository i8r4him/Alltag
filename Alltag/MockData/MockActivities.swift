//
//  MockActivities.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The prototype's practice activities (`ACTS`).
enum MockActivities {
    typealias Question = Activity.Question

    static let all: [Activity] = [mistakes, recall, listen]

    static func activity(_ id: Activity.ID) -> Activity {
        switch id {
        case .mistakes: mistakes
        case .recall: recall
        case .listen: listen
        }
    }

    static let mistakes = Activity(
        id: .mistakes,
        label: "FIX YOUR MISTAKES",
        tone: .mistake,
        title: "Two small fixes",
        questions: [
            Question(context: "You wrote in Messages:",
                     quote: "„Ich wohne hier für drei Jahren.“",
                     question: "Which sounds natural?",
                     options: ["Ich wohne hier seit drei Jahren.",
                               "Ich wohne hier für drei Jahre.",
                               "Ich wohne seit drei Jahre hier."],
                     correctIndex: 0,
                     explanation: "Use „seit“ + dative for something that started in the past and is still true. "
                        + "Dative plural adds -n: Jahren."),
            Question(context: "You said in a conversation:",
                     quote: "„… wenn das passt mir.“",
                     question: "Where does the verb go?",
                     options: ["… wenn passt mir das.", "… wenn mir das passt.", "… wenn das passt mir."],
                     correctIndex: 1,
                     explanation: "After „wenn“, „weil“ and „dass“, the conjugated verb moves to the very end of the clause.")
        ]
    )

    static let recall = Activity(
        id: .recall,
        label: "RECALL · FROM YOUR READING",
        tone: .accent,
        title: "Words from Safari",
        questions: [
            Question(context: "From a Spiegel article you read today",
                     quote: "Die ___ beträgt drei Monate.",
                     question: "Which word fits?",
                     options: ["Rechnung", "Kündigungsfrist", "Feierabend"],
                     correctIndex: 1,
                     explanation: "die Kündigungsfrist — notice period. Compound: Kündigung (termination) + Frist (deadline)."),
            Question(context: "From a message you wrote",
                     quote: "Kannst du mir ___ sagen, ob du kommst?",
                     question: "Which word fits?",
                     options: ["Bescheid", "Termin", "unterwegs"],
                     correctIndex: 0,
                     explanation: "Bescheid sagen — to let someone know. Almost always used as a fixed pair."),
            Question(context: "From the same article",
                     quote: "Ich bin noch ___, bin gleich da.",
                     question: "Which word fits?",
                     options: ["eigentlich", "Bescheid", "unterwegs"],
                     correctIndex: 2,
                     explanation: "unterwegs — on the way, out and about.")
        ]
    )

    static let listen = Activity(
        id: .listen,
        label: "LISTEN · FOR FRIDAY",
        tone: .accent,
        title: "Platform change",
        audio: "Achtung an Gleis vier: Der ICE nach München fährt heute von Gleis sieben ab.",
        questions: [
            Question(question: "Where does the train to Munich leave from?",
                     options: ["Platform 4", "Platform 7", "Platform 11"],
                     correctIndex: 1,
                     explanation: "„fährt heute von Gleis sieben ab“ — abfahren is separable, so „ab“ lands at the end.")
        ]
    )
}
