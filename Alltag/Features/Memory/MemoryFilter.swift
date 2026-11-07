//
//  MemoryFilter.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The filter chips above the word list.
enum MemoryFilter: CaseIterable, Identifiable {
    case all
    case fromYourDay
    case saved
    case mistakes
    case due

    var id: Self { self }

    init(kind: MemoryKind?) {
        switch kind {
        case nil: self = .all
        case .fromYourDay: self = .fromYourDay
        case .saved: self = .saved
        case .mistake: self = .mistakes
        }
    }

    var title: LocalizedStringResource {
        switch self {
        case .all: "All"
        case .fromYourDay: "From your day"
        case .saved: "Saved"
        case .mistakes: "Mistakes"
        case .due: "Due"
        }
    }

    func includes(_ item: MemoryItem, at date: Date) -> Bool {
        switch self {
        case .all: true
        case .fromYourDay: item.kind == .fromYourDay
        case .saved: item.kind == .saved
        case .mistakes: item.kind == .mistake
        case .due: item.isDue(at: date)
        }
    }

    /// Items matching the filter and the search text (German or English,
    /// ignoring case and accents), due items first.
    func apply(to items: [MemoryItem], query: String, at date: Date = .now) -> [MemoryItem] {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        return items
            .filter { includes($0, at: date) }
            .filter { item in
                query.isEmpty
                    || item.displayWord.localizedStandardContains(query)
                    || item.meaning.localizedStandardContains(query)
            }
            .sorted { lhs, rhs in
                lhs.nextReview == rhs.nextReview
                    ? lhs.word.localizedStandardCompare(rhs.word) == .orderedAscending
                    : lhs.nextReview < rhs.nextReview
            }
    }
}

/// The "Ready to review" card's numbers.
struct ReviewSummary: Equatable {
    let count: Int
    let mistakes: Int

    init(items: [MemoryItem], at date: Date = .now) {
        let due = items.filter { $0.isDue(at: date) }
        count = due.count
        mistakes = due.filter { $0.kind == .mistake }.count
    }

    // `count` is an Int here, not a collection; the rule only matches the name.
    // swiftlint:disable:next empty_count
    var isEmpty: Bool { count == 0 }

    /// About 30 seconds per item, at least one minute.
    var minutes: Int { max(1, (count + 1) / 2) }
}
