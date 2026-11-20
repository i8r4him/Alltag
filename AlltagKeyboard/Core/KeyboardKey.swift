//
//  KeyboardKey.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import Foundation

/// The pages of keys under the numbers row.
enum KeyboardPage: Hashable, CaseIterable {
    case letters
    case symbols
    case moreSymbols

    /// What the key that opens this page shows.
    var label: String {
        switch self {
        case .letters: "ABC"
        case .symbols: "123"
        case .moreSymbols: "#+="
        }
    }
}

/// One key of the Alltag keyboard.
enum KeyboardKey: Hashable {
    /// Types its text. Letters are kept in lowercase; Shift decides at typing time.
    case character(String)
    case shift
    case delete
    /// Shows another page of keys.
    case page(KeyboardPage)
    /// Switches to the next keyboard, where iOS doesn't show its own globe.
    case globe
    /// Opens the emoji in place of the keys.
    case emoji
    case space
    case enter

    /// The text a character key types; `nil` for every other key.
    var text: String? {
        if case let .character(text) = self { return text }
        return nil
    }

    var isCharacter: Bool { text != nil }
}

/// What the return key does in the text field, which decides its symbol.
enum ReturnKeyKind: Equatable {
    case normal
    case forward
    case search
    case send
    case done
    case next

    var symbol: String {
        switch self {
        case .normal: "return"
        case .forward: "arrow.right"
        case .search: "magnifyingglass"
        case .send: "arrow.up"
        case .done: "checkmark"
        case .next: "arrow.right.to.line"
        }
    }
}
