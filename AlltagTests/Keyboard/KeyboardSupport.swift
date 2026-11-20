//
//  KeyboardSupport.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import Foundation
@testable import Alltag

/// A text field for the keyboard tests: the text before and after the cursor.
@MainActor
final class FakeDocument: TextDocument {
    var before: String
    var after = ""

    init(_ before: String = "") {
        self.before = before
    }

    var textBeforeCursor: String { before }

    func insert(_ text: String) {
        before += text
    }

    func deleteBackward() {
        if !before.isEmpty { before.removeLast() }
    }

    func moveCursor(by offset: Int) {
        if offset < 0 {
            let count = min(-offset, before.count)
            after = String(before.suffix(count)) + after
            before.removeLast(count)
        } else {
            let count = min(offset, after.count)
            before += after.prefix(count)
            after.removeFirst(count)
        }
    }
}

/// Offers fixed words, so no test asks the dictionary on the device.
@MainActor
struct FixedWords: WordSuggesting {
    let words: [String: [String]]

    func suggestions(for word: String) -> [String] {
        words[word] ?? []
    }
}
