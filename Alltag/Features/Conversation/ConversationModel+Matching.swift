//
//  ConversationModel+Matching.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ConversationModel {
    /// Whether what was heard is close enough to the scripted line to count as
    /// it: at least 80% of its words, in any order. Recognition can drop a short
    /// word or write numbers as digits, so an exact match would be too strict.
    static func isScripted(_ heard: String, _ line: String) -> Bool {
        let expected = normalized(line).split(separator: " ")
        guard !expected.isEmpty else { return false }
        var heardWords = normalized(heard).split(separator: " ")
        var found = 0
        for word in expected {
            if let index = heardWords.firstIndex(of: word) {
                heardWords.remove(at: index)
                found += 1
            }
        }
        return Double(found) / Double(expected.count) >= 0.8 && heardWords.count <= 2
    }

    /// Lowercased letters, digits and spaces only, for comparing sentences.
    static func normalized(_ text: String) -> String {
        text.lowercased()
            .filter { $0.isLetter || $0.isNumber || $0 == " " }
            .trimmingCharacters(in: .whitespaces)
    }
}
