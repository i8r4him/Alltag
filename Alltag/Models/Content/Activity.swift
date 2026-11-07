//
//  Activity.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// A short multiple-choice practice session.
struct Activity: Identifiable, Hashable, Sendable {
    enum ID: String, Hashable, CaseIterable, Sendable {
        /// Fix your own mistakes.
        case mistakes
        /// Recall words from your reading.
        case recall
        /// Listen to an announcement.
        case listen
    }

    /// Colour of the eyebrow label.
    enum Tone: Hashable, Sendable {
        case accent
        case mistake
    }

    let id: ID
    /// Eyebrow, e.g. "FIX YOUR MISTAKES".
    let label: String
    let tone: Tone
    let title: String
    /// German audio to play before the questions, if any.
    var audio: String?
    let questions: [Question]

    struct Question: Hashable, Sendable {
        /// Where the material came from, e.g. "You wrote in Messages:".
        var context: String?
        /// The quoted sentence, e.g. "„Ich wohne hier für drei Jahren.“".
        var quote: String?
        let question: String
        let options: [String]
        let correctIndex: Int
        /// Shown after answering.
        let explanation: String

        var correctAnswer: String { options[correctIndex] }
    }
}
