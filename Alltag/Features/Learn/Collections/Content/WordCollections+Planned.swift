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
        WordCollection(id: "c1-diskutieren", title: "Diskutieren und Argumentieren", subtitle: "Discussing and arguing",
                       level: .c1, category: .work, systemImage: "bubble.left.and.bubble.right.fill")
    ]
}
