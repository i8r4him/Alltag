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
        WebExample(title: "Essay und Diskurs", site: "deutschlandfunk.de",
                   url: c2Link("https://www.deutschlandfunk.de/essay-und-diskurs-100.html"),
                   about: "Long essays on ideas and society, to read or listen to"),
        WebExample(title: "Aus Politik und Zeitgeschichte", site: "bpb.de",
                   url: c2Link("https://www.bpb.de/shop/zeitschriften/apuz/"),
                   about: "Essays by researchers on politics, history and society"),
        WebExample(title: "Amtsdeutsch", site: "de.wikipedia.org",
                   url: c2Link("https://de.wikipedia.org/wiki/Amtsdeutsch"),
                   about: "Why official German is so hard to read, and where it comes from")
    ]

    private static func c2Link(_ address: String) -> URL {
        guard let url = URL(string: address) else { preconditionFailure("Not a link: \(address)") }
        return url
    }
}
