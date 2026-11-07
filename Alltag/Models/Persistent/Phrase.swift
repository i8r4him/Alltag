//
//  Phrase.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData

/// A phrase in the Phrasebook, grouped by the place it is useful in.
@Model
final class Phrase {
    /// Stable identifier for App Intents and Spotlight.
    var uuid: UUID = UUID()
    var german: String = ""
    var english: String = ""
    /// Group title, e.g. "At the doctor".
    var place: String = ""
    /// SF Symbol for the group.
    var placeSymbol: String = "text.bubble"
    /// Shows a "NEW" badge until the learner has seen it.
    var isNew: Bool = false
    var createdAt: Date = Date.now

    init(german: String, english: String, place: String, placeSymbol: String,
         isNew: Bool = false, createdAt: Date = .now) {
        self.german = german
        self.english = english
        self.place = place
        self.placeSymbol = placeSymbol
        self.isNew = isNew
        self.createdAt = createdAt
    }
}
