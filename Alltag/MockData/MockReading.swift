//
//  MockReading.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import Foundation

/// An article the learner shared from Safari.
struct SavedArticle: Identifiable {
    let id = UUID()
    /// The article's German headline, shown as is.
    let title: String
    let site: String
    let level: String
    let minutes: Int
}

/// A text from daily life to read: a letter, notice or form.
struct ReadingText: Identifiable {
    let id = UUID()
    let title: LocalizedStringResource
    let detail: LocalizedStringResource
    let level: String
    let minutes: Int
    let systemImage: String
}

/// Sample content for the Read screen until reading is built.
enum MockReading {
    static let articles = [
        SavedArticle(title: "Mietpreise in Berlin steigen weiter", site: "Spiegel", level: "B1", minutes: 6),
        SavedArticle(title: "Deutschlandticket: Was sich 2027 ändert", site: "tagesschau", level: "B1", minutes: 4)
    ]

    static let picked = ReadingText(title: "A letter from your landlord",
                                    detail: "Your service charges, explained.",
                                    level: "A2", minutes: 3, systemImage: "envelope.open.fill")

    static let more = [
        ReadingText(title: "A notice from the Bürgeramt", detail: "Your appointment",
                    level: "A2", minutes: 2, systemImage: "building.columns.fill"),
        ReadingText(title: "A form at the doctor's", detail: "Fill it in",
                    level: "B1", minutes: 4, systemImage: "cross.case.fill"),
        ReadingText(title: "An email from work", detail: "A change of shift",
                    level: "B1", minutes: 3, systemImage: "briefcase.fill"),
        ReadingText(title: "A menu at the café", detail: "Order lunch",
                    level: "A1", minutes: 2, systemImage: "cup.and.saucer.fill"),
        ReadingText(title: "A notice from Deutsche Bahn", detail: "Engineering works",
                    level: "A2", minutes: 2, systemImage: "tram.fill")
    ]
}
