//
//  WebExamples+C1.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WebExamples {
    /// C1: explainers, science news and debate, from pages that stay online.
    static let c1: [WebExample] = [
        WebExample(title: "Die Mietpreisbremse tritt in Kraft", site: "bpb.de",
                   url: c1Link("https://www.bpb.de/kurz-knapp/hintergrund-aktuell/208048/die-mietpreisbremse-tritt-in-kraft/"),
                   about: "How Germany caps the rent for new tenancies, explained"),
        WebExample(title: "Andere Familiensprache als Deutsch: Was bedeutet mehrsprachig aufzuwachsen?", site: "bpb.de",
                   url: c1Link("https://www.bpb.de/themen/bildung/dossier-bildung/572961/"
                       + "andere-familiensprache-als-deutsch-was-bedeutet-mehrsprachig-aufzuwachsen/"),
                   about: "What it means to grow up speaking two languages"),
        WebExample(title: "Debatte über Viertagewoche", site: "taz.de",
                   url: c1Link("https://taz.de/Debatte-ueber-Viertagewoche/!5929894/"),
                   about: "Should Germany work four days a week? A debate"),
        WebExample(title: "Deutsche Sprache: Antworten auf die wichtigsten Fragen", site: "deutschland.de",
                   url: c1Link("https://www.deutschland.de/de/topic/wissen/deutsche-sprache-antworten-auf-die-wichtigsten-fragen"),
                   about: "Facts about German: who speaks it, and how it changes")
    ]

    private static func c1Link(_ address: String) -> URL {
        guard let url = URL(string: address) else { preconditionFailure("Not a link: \(address)") }
        return url
    }
}
