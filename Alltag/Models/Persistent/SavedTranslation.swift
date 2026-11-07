//
//  SavedTranslation.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData

/// A translation the learner bookmarked in Translate.
@Model
final class SavedTranslation {
    var english: String = ""
    var german: String = ""
    var savedAt: Date = Date.now

    init(english: String, german: String, savedAt: Date = .now) {
        self.english = english
        self.german = german
        self.savedAt = savedAt
    }
}
