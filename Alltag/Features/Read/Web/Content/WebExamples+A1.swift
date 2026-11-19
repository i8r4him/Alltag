//
//  WebExamples+A1.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WebExamples {
    /// A1: explainers in Leichte Sprache, short sentences with hard words explained,
    /// about things that come back every year, so the pages stay online.
    static let a1: [WebExample] = [
        WebExample(title: "Fasching, Fastnacht, Karneval", site: "nachrichtenleicht.de",
                   url: URL(string: "https://www.nachrichtenleicht.de/fasching-fastnacht-karneval-100.html")!,
                   about: "Carnival in Germany, explained simply"),
        WebExample(title: "Winter-Zeit - Brauchen wir die Zeit-Umstellung noch?", site: "nachrichtenleicht.de",
                   url: URL(string: "https://www.nachrichtenleicht.de/zeitumstellung-winterzeit-102.html")!,
                   about: "Why the clocks change in autumn"),
        WebExample(title: "Neue Wörter in dem Buch Duden", site: "nachrichtenleicht.de",
                   url: URL(string: "https://www.nachrichtenleicht.de/duden-neue-woerter-102.html")!,
                   about: "The new words in the German dictionary"),
        WebExample(title: "Tag der Leichten Sprache: Leichte Sprache hilft vielen Menschen", site: "nachrichtenleicht.de",
                   url: URL(string: "https://www.nachrichtenleicht.de/tag-der-leichten-sprache-104.html")!,
                   about: "Who easy German is for, and how it helps")
    ]
}
