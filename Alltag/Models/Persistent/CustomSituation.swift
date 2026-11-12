//
//  CustomSituation.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 12.11.26.
//

import Foundation
import SwiftData

/// A situation the learner added themselves, next to the ones Alltag offers.
///
/// Like every model, it follows CloudKit's rules so iCloud sync can be
/// switched on later: every property has a default and nothing is unique.
@Model
final class CustomSituation {
    var uuid: UUID = UUID()
    /// "At the vet".
    var title: String = ""
    /// What the learner wants to do there. May be empty.
    var detail: String = ""
    /// Raw value of `category`.
    var categoryRaw: String = Situation.Category.other.rawValue
    var createdAt: Date = Date.now

    var category: Situation.Category {
        get { Situation.Category(rawValue: categoryRaw) ?? .other }
        set { categoryRaw = newValue.rawValue }
    }

    init(title: String, detail: String = "", category: Situation.Category = .other, createdAt: Date = .now) {
        self.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        self.detail = detail.trimmingCharacters(in: .whitespacesAndNewlines)
        self.categoryRaw = category.rawValue
        self.createdAt = createdAt
    }

    /// The id used in routes, distinct from the catalogue's ids.
    var situationID: String { "custom-\(uuid.uuidString)" }

    /// The same shape as a catalogue situation, so lists and conversations treat both alike.
    var situation: Situation {
        Situation(id: situationID, category: category,
                  title: Situation.verbatim(title),
                  detail: Situation.verbatim(detail.isEmpty ? String(localized: "Your own situation") : detail),
                  systemImage: category.systemImage,
                  role: "the other person in this situation, whoever the learner would really talk to there",
                  aim: detail.isEmpty ? "handle this situation the way they would in real life" : "do this, in their own words: \(detail)",
                  isCustom: true)
    }
}
