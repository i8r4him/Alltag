//
//  MockMemoryItems.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The prototype's Memory items (`MEM`).
enum MockMemoryItems {
    static func make(now: Date = .now) -> [MemoryItem] {
        let calendar = Calendar.current
        func due() -> Date { now.addingTimeInterval(-3_600) }
        func inDays(_ days: Int) -> Date { calendar.date(byAdding: .day, value: days, to: now) ?? now }

        return [
            MemoryItem(article: "die ", word: "Kündigungsfrist", meaning: "notice period",
                       context: "Die Kündigungsfrist beträgt drei Monate.",
                       contextNote: "The notice period is three months.",
                       kind: .fromYourDay, source: .safari, sourceDetail: "Spiegel, today",
                       strength: 1, nextReview: due()),
            MemoryItem(article: "die ", word: "Mietpreisbremse", meaning: "rent cap",
                       context: "Die Mietpreisbremse gilt in Berlin seit 2015.",
                       contextNote: "The rent cap has applied in Berlin since 2015.",
                       kind: .fromYourDay, source: .safari, sourceDetail: "Spiegel, today",
                       strength: 1, nextReview: due()),
            MemoryItem(word: "unterwegs", meaning: "on the way",
                       context: "Ich bin noch unterwegs, in zehn Minuten bin ich da.",
                       contextNote: "I'm still on the way, I'll be there in ten minutes.",
                       kind: .fromYourDay, source: .safari, sourceDetail: "Spiegel, today",
                       strength: 2, nextReview: due()),
            MemoryItem(word: "seit drei Jahren", meaning: "for three years (and still)",
                       context: "Ich wohne hier seit drei Jahren.",
                       contextNote: "You wrote „für drei Jahren“.",
                       kind: .mistake, source: .messages, sourceDetail: "yesterday",
                       strength: 1, nextReview: due()),
            MemoryItem(word: "wenn mir das passt", meaning: "if that suits me — verb last",
                       context: "Ich komme um 15 Uhr, wenn Ihnen das passt.",
                       contextNote: "You said „wenn das passt mir“.",
                       kind: .mistake, source: .conversation, sourceDetail: "Monday",
                       strength: 1, nextReview: due()),
            MemoryItem(word: "Bescheid sagen", meaning: "to let someone know",
                       context: "Sag mir Bescheid, wann du Zeit hast.",
                       contextNote: "Let me know when you're free.",
                       kind: .saved, source: .translate, sourceDetail: "last week",
                       strength: 2, nextReview: due()),
            MemoryItem(article: "der ", word: "Feierabend", meaning: "time after work",
                       context: "Ich mache jetzt Feierabend.",
                       contextNote: "I'm calling it a day.",
                       kind: .saved, source: .translate, sourceDetail: "today",
                       strength: 3, nextReview: inDays(3)),
            MemoryItem(word: "verschieben", meaning: "to postpone, move",
                       context: "Können wir den Termin verschieben?",
                       contextNote: "Can we move the appointment?",
                       kind: .saved, source: .conversation, sourceDetail: "Monday",
                       strength: 3, nextReview: inDays(3)),
            MemoryItem(word: "eigentlich", meaning: "actually, really",
                       context: "Eigentlich wollte ich nur kurz fragen …",
                       contextNote: "Actually I just wanted to ask quickly …",
                       kind: .fromYourDay, source: .podcast, sourceDetail: "2 weeks ago",
                       strength: 4, nextReview: inDays(7)),
            MemoryItem(article: "die ", word: "Rechnung", meaning: "bill, invoice",
                       context: "Die Rechnung, bitte!",
                       contextNote: "The bill, please!",
                       kind: .fromYourDay, source: .camera, sourceDetail: "receipt",
                       strength: 4, nextReview: inDays(7))
        ]
    }
}
