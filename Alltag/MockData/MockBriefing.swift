//
//  MockBriefing.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The prototype's morning briefing (`BRIEF`, `BRIEF_WORDS`).
enum MockBriefing {
    static let briefing = Briefing(
        title: "Renting in Berlin, in words you're learning",
        transcript: "Guten Morgen, Mara. In Berlin wird wieder über die Mietpreisbremse diskutiert. "
            + "Viele Mieter wissen eigentlich nicht, dass die Kündigungsfrist meistens drei Monate beträgt. "
            + "Wer unterwegs ist, kann sich den Artikel für den Feierabend merken. "
            + "Und wer umziehen will: Sag dem Vermieter rechtzeitig Bescheid.",
        words: ["Mietpreisbremse", "eigentlich", "Kündigungsfrist", "unterwegs", "Feierabend", "Bescheid"]
    )
}
