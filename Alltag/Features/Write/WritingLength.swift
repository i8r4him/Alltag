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
    /// The number of words to aim for.
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
}
