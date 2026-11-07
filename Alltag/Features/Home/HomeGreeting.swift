//
//  HomeGreeting.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The logic behind Home's greeting and subtitle, kept free of views so it can be tested.
enum HomeGreeting {
    enum PartOfDay: Equatable {
        case morning
        case afternoon
        case evening

        /// Morning 5:00–11:59, afternoon 12:00–17:59, evening otherwise.
        init(hour: Int) {
            switch hour {
            case 5..<12: self = .morning
            case 12..<18: self = .afternoon
            default: self = .evening
            }
        }

        init(date: Date, calendar: Calendar = .current) {
            self.init(hour: calendar.component(.hour, from: date))
        }
    }

    /// "Good evening, Mara." — or without the name if there is none.
    static func title(for part: PartOfDay, name: String) -> LocalizedStringResource {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        switch (part, name.isEmpty) {
        case (.morning, false): return "Good morning, \(name)."
        case (.afternoon, false): return "Good afternoon, \(name)."
        case (.evening, false): return "Good evening, \(name)."
        case (.morning, true): return "Good morning."
        case (.afternoon, true): return "Good afternoon."
        case (.evening, true): return "Good evening."
        }
    }

    /// Words picked up from reading today, for "You picked up 3 new words while
    /// reading in Safari today."
    static func newReadingWords(in items: [MemoryItem], on date: Date = .now, calendar: Calendar = .current) -> Int {
        items.filter {
            $0.kind == .fromYourDay && $0.source == .safari && calendar.isDate($0.createdAt, inSameDayAs: date)
        }.count
    }
}
