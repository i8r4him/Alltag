//
//  WebExamples+B1.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WebExamples {
    /// B1: the consumer advice centre's explainers about everyday money and contracts, which stay online.
    static let b1: [WebExample] = [
        WebExample(title: "Mehrweg oder Einweg: Wichtige Unterschiede beim Pfand", site: "verbraucherzentrale.de",
                   url: URL(string: "https://www.verbraucherzentrale.de/wissen/umwelt-haushalt/abfall/mehrweg-oder-einweg-wichtige-unterschiede-beim-pfand-11504")!,
                   about: "How the deposit on bottles and cans works"),
        WebExample(title: "Deutschlandticket: Von Kaufen bis Kündigen – alle wichtigen Infos", site: "verbraucherzentrale.de",
                   url: URL(string: "https://www.verbraucherzentrale.de/wissen/reise-mobilitaet/unterwegs-sein/deutschlandticket-von-kaufen-bis-kuendigen-alle-wichtigen-infos-82203")!,
                   about: "Buying, using and cancelling the ticket for buses and trains"),
        WebExample(title: "Handyvertrag kündigen: Muss ich anrufen, um die Kündigung zu bestätigen?", site: "verbraucherzentrale.de",
                   url: URL(string: "https://www.verbraucherzentrale.de/wissen/digitale-welt/mobilfunk-und-festnetz/handyvertrag-kuendigen-muss-ich-anrufen-um-die-kuendigung-zu-bestaetigen-12777")!,
                   about: "Ending a phone contract without being talked out of it"),
        WebExample(title: "Nachzahlungs-Schock: Hilfe bei hoher Betriebs- und Heizkostenabrechnung", site: "verbraucherzentrale.de",
                   url: URL(string: "https://www.verbraucherzentrale.de/wissen/energie/preise-tarife-anbieterwechsel/nachzahlungsschock-hilfe-bei-hoher-betriebs-und-heizkostenabrechnung-83065")!,
                   about: "What to do when the service charges bill is high")
    ]
}
