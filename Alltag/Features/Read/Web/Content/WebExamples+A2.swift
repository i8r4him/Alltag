//
//  WebExamples+A2.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WebExamples {
    /// A2: short explainers in simple German that stay online, about things the
    /// learner meets in daily life: the train ticket, the rubbish, Advent.
    static let a2: [WebExample] = [
        WebExample(title: "Das Deutschland-Ticket ist eine neue Fahr-Karte in Deutschland", site: "nachrichtenleicht.de",
                   url: URL(string: "https://www.nachrichtenleicht.de/deutschlandticket-106.html")!,
                   about: "One ticket for buses and local trains all over Germany"),
        WebExample(title: "Sozial-Verband lobt \"Stille Stunden\" auf Weihnachts-Märkten", site: "nachrichtenleicht.de",
                   url: URL(string: "https://www.nachrichtenleicht.de/stille-stunden-weihnachtsmarkt-102.html")!,
                   about: "Quiet hours at Christmas markets, without loud music"),
        WebExample(title: "Recycling", site: "Klexikon",
                   url: URL(string: "https://klexikon.zum.de/wiki/Recycling")!,
                   about: "How old things are made into new ones"),
        WebExample(title: "Advent", site: "Klexikon",
                   url: URL(string: "https://klexikon.zum.de/wiki/Advent")!,
                   about: "The four weeks before Christmas, and the Advent calendar")
    ]
}
