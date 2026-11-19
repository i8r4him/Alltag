//
//  WritingLength.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// How long a text about a topic should be at each level, about as long as
/// the writing part of the Goethe exams asks for.
enum WritingLength {
    /// The number of words to aim for in a text about a topic.
    static func words(for level: Level) -> Int {
        switch level {
        case .a1: 30
        case .a2: 50
        case .b1: 80
        case .b2: 150
        case .c1: 200
        case .c2: 250
        }
    }

    /// The number of words to aim for in a formal email.
    static func formalWords(for level: Level) -> Int {
        switch level {
        case .a1: 30
        case .a2: 40
        case .b1: 80
        case .b2: 100
        case .c1: 120
        case .c2: 150
        }
    }

    /// The number of words to aim for in a form's answer (only A1 and A2 have forms).
    static func formWords(for level: Level) -> Int {
        level <= .a1 ? 20 : 30
    }
}
