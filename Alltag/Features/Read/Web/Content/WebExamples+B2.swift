//
//  WebExamples+B2.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WebExamples {
    /// B2: guides and explainers for adult life in Germany (contracts, bills, the flat, work), the topics of
    /// B2's texts and scenes. Pages that stay online, not the day's news.
    static let b2: [WebExample] = [
        WebExample(
            title: "Fitness-Studios: Was in Verträgen (nicht) erlaubt ist", site: "verbraucherzentrale.de",
            url: link("https://www.verbraucherzentrale.de/wissen/vertraege-reklamation/kundenrechte/"
                + "fitnessstudios-was-in-vertraegen-nicht-erlaubt-ist-21641"),
            about: "What a gym contract may and may not say"),
        WebExample(
            title: "Heizkostenabrechnungen prüfen: So erkennen Sie teure Fehler", site: "verbraucherzentrale.de",
            url: link("https://www.verbraucherzentrale.de/wissen/energie/heizen-und-warmwasser/"
                + "heizkostenabrechnungen-pruefen-so-erkennen-sie-teure-fehler-29217"),
            about: "How to find mistakes in your heating bill"),
        WebExample(
            title: "Mieterschutz", site: "bpb.de",
            url: link("https://www.bpb.de/kurz-knapp/lexika/lexikon-der-wirtschaft/20112/mieterschutz/"),
            about: "Tenants' rights, explained in a few lines"),
        WebExample(
            title: "Das Anerkennungsgesetz für ausländische Berufsabschlüsse", site: "deutschland.de",
            url: link("https://www.deutschland.de/de/topic/wirtschaft/karriere-arbeit/"
                + "das-anerkennungsgesetz-fuer-auslaendische-berufsabschluesse"),
            about: "How qualifications from abroad are recognised")
    ]

    /// A link written above. A typo in one stops the app at once instead of showing a broken row.
    private static func link(_ address: String) -> URL {
        guard let url = URL(string: address) else { preconditionFailure("Not a link: \(address)") }
        return url
    }
}
