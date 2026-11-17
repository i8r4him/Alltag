//
//  WordCollections+Planned.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    /// Topics whose words aren't written yet: names only, shown as "Coming soon".
    static let planned: [WordCollection] = [
        WordCollection(id: "b1-bank", title: "Bank und Geld", subtitle: "Banking and money", level: .b1,
                       category: .paperwork, systemImage: "banknote.fill"),
        WordCollection(id: "b1-wohnungssuche", title: "Wohnungssuche", subtitle: "Finding a flat", level: .b1,
                       category: .home, systemImage: "key.fill"),
        WordCollection(id: "b1-urlaub", title: "Urlaub und Reisen", subtitle: "Holidays", level: .b1,
                       category: .travel, systemImage: "airplane"),
        WordCollection(id: "b2-vertraege", title: "Verträge und Versicherungen", subtitle: "Contracts and insurance",
                       level: .b2, category: .paperwork, systemImage: "doc.text.fill"),
        WordCollection(id: "b2-nachrichten", title: "Nachrichten und Politik", subtitle: "News and politics", level: .b2,
                       category: .everyday, systemImage: "newspaper.fill"),
        WordCollection(id: "b2-umwelt", title: "Umwelt und Klima", subtitle: "Environment", level: .b2,
                       category: .everyday, systemImage: "leaf.fill"),
        WordCollection(id: "c1-diskutieren", title: "Diskutieren und Argumentieren", subtitle: "Discussing and arguing",
                       level: .c1, category: .work, systemImage: "bubble.left.and.bubble.right.fill")
    ]
}
