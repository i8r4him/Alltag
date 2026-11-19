//
//  ReadingContentTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

/// The texts to read are written by hand, so these check what a typo could break.
@MainActor
struct ReadingContentTests {
    @Test("Every text has a unique id that starts with its level")
    func ids() {
        let ids = ReadingTexts.all.map(\.id)
        #expect(Set(ids).count == ids.count)
        for text in ReadingTexts.all {
            #expect(text.id.hasPrefix(text.level.rawValue.lowercased() + "-"), "\(text.id)")
        }
    }

    @Test("Every text has three questions of three options, with the right answer among them")
    func questions() {
        for text in ReadingTexts.all {
            #expect(text.questions.count == 3, "\(text.id)")
            for question in text.questions {
                #expect(question.options.count == 3, "\(text.id): \(question.prompt)")
                #expect(Set(question.options).count == 3, "\(text.id): \(question.prompt)")
                #expect(question.options.indices.contains(question.answer), "\(text.id): \(question.prompt)")
            }
        }
    }

    @Test("Every answer's sentence is in its text, on one line, word for word")
    func evidence() {
        for text in ReadingTexts.all {
            let lines = text.german.split(separator: "\n").map(String.init)
            for question in text.questions {
                #expect(lines.contains { $0.contains(question.evidence) }, "\(text.id): \(question.evidence)")
            }
        }
    }

    @Test("Every level has texts; C2 reads its own once they are written, C1's until then")
    func levels() {
        for level in Level.allCases {
            #expect(!ReadingTexts.texts(at: level).isEmpty, "\(level)")
        }
        let c2Level: Level = ReadingTexts.c2.isEmpty ? .c1 : .c2
        #expect(ReadingTexts.texts(at: .c2).allSatisfy { $0.level == c2Level })
    }
}
