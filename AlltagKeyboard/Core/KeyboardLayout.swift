//
//  KeyboardLayout.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import Foundation

/// The German layout: a numbers row that is always there and, under it, the
/// letters (QWERTZ with ä, ö and ü) or one of two pages of symbols.
enum KeyboardLayout {
    static let numbers: [KeyboardKey] = keys("1234567890")

    /// The four rows under the numbers row.
    static func rows(for page: KeyboardPage, showsGlobe: Bool) -> [[KeyboardKey]] {
        let other: KeyboardPage = page == .letters ? .symbols : .letters
        let bottom: [KeyboardKey] = [.page(other)] + (showsGlobe ? [.globe] : []) + [.space, .enter]
        let punctuation = keys(".,?!'")
        switch page {
        case .letters:
            return [keys("qwertzuiopü"), keys("asdfghjklöä"), [.shift] + keys("yxcvbnm") + [.delete], bottom]
        case .symbols:
            return [keys("-/:;()€&@\""), keys("[]{}#%^*+="), [.page(.moreSymbols)] + punctuation + [.delete], bottom]
        case .moreSymbols:
            return [keys("_\\|~<>$£¥•"), keys("§°…„“”‚‘«»"), [.page(.symbols)] + punctuation + [.delete], bottom]
        }
    }

    /// Every row from top to bottom, the numbers row first.
    static func allRows(for page: KeyboardPage, showsGlobe: Bool) -> [[KeyboardKey]] {
        [numbers] + rows(for: page, showsGlobe: showsGlobe)
    }

    /// What a long press on a key offers, the most wanted first: ß on s, the
    /// accents of the languages around Germany on the vowels.
    static func alternates(for text: String) -> [String] {
        alternatesByKey[text] ?? []
    }

    private static let alternatesByKey: [String: [String]] = [
        "a": ["à", "á", "â", "æ", "å"],
        "c": ["ç", "ć", "č"],
        "e": ["é", "è", "ê", "ë"],
        "i": ["í", "ì", "î", "ï"],
        "l": ["ł"],
        "n": ["ñ", "ń"],
        "o": ["ó", "ò", "ô", "œ", "ø"],
        "s": ["ß", "ś", "š"],
        "u": ["ú", "ù", "û"],
        "y": ["ÿ"],
        "z": ["ž", "ź"],
        "0": ["°"],
        "-": ["–", "—", "•"],
        "/": ["\\"],
        "€": ["$", "£", "¥"],
        "&": ["§"],
        "\"": ["„", "“", "”", "«", "»"],
        "'": ["’", "‚", "‘"],
        ".": ["…"],
        "?": ["¿"],
        "!": ["¡"]
    ]

    private static func keys(_ characters: String) -> [KeyboardKey] {
        characters.map { KeyboardKey.character(String($0)) }
    }
}
