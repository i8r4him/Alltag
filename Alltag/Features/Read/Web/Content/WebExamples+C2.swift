//
//  WebExamples+C2.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WebExamples {
    /// C2: essays, long reads and articles that explain how German works, on pages that stay online.
    static let c2: [WebExample] = [
        WebExample(title: "Arbeitszeugnis", site: "de.wikipedia.org",
                   url: c2Link("https://de.wikipedia.org/wiki/Arbeitszeugnis"),
                   about: "How German job references are written, and their hidden code"),
        WebExample(title: "Geschlechtergerechte Sprache? Sechs Perspektiven", site: "bpb.de",
                   url: c2Link("https://www.bpb.de/shop/zeitschriften/apuz/geschlechtergerechte-sprache-2022/"
                       + "346145/geschlechtergerechte-sprache-sechs-perspektiven/"),
                   about: "Six views on gender-fair German, side by side"),
        WebExample(title: "Surveillance Capitalism – Überwachungskapitalismus. Essay", site: "bpb.de",
                   url: c2Link("https://www.bpb.de/shop/zeitschriften/apuz/292337/"
                       + "surveillance-capitalism-ueberwachungskapitalismus-essay/"),
                   about: "An essay on how tech companies turn our data into money"),
        WebExample(title: "Verwaltungssprache", site: "de.wikipedia.org",
                   url: c2Link("https://de.wikipedia.org/wiki/Verwaltungssprache"),
                   about: "Why official German is so hard to read, and where it comes from")
    ]

    private static func c2Link(_ address: String) -> URL {
        guard let url = URL(string: address) else { preconditionFailure("Not a link: \(address)") }
        return url
    }
}
