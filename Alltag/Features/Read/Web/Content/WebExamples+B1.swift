//
//  WebExamples+B1.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WebExamples {
    /// B1: explainers about life in Germany, written for newcomers and learners, that stay online.
    static let b1: [WebExample] = [
        WebExample(title: "Einweg, Mehrweg, Umweg: Das Pfandsystem", site: "goethe.de",
                   url: URL(string: "https://www.goethe.de/ins/pl/de/kul/ges/27226175.html")!,
                   about: "How the deposit on bottles and cans works"),
        WebExample(title: "Deutsch, deutscher, Mülltrennung", site: "goethe.de",
                   url: URL(string: "https://www.goethe.de/prj/stg/de/deu/lvw/26915236.html")!,
                   about: "Why Germans sort their rubbish into so many bins"),
        WebExample(title: "Wohnung finden und anmelden", site: "make-it-in-germany.com",
                   url: URL(string: "https://www.make-it-in-germany.com/de/ankommen-bleiben/erste-schritte/wohnung-finden-anmelden")!,
                   about: "Finding a flat and registering your address"),
        WebExample(title: "Krankenversicherung", site: "make-it-in-germany.com",
                   url: URL(string: "https://www.make-it-in-germany.com/de/ankommen-bleiben/erste-schritte/krankenversicherung")!,
                   about: "How health insurance works in Germany")
    ]
}
