//
//  PhrasebookTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Phrasebook")
@MainActor
struct PhrasebookTests {
    let now = Calendar.current.date(from: DateComponents(year: 2026, month: 11, day: 7, hour: 19)) ?? .now

    @Test("The sample phrasebook has the prototype's four places, in order, two phrases each")
    func sampleGroups() {
        let groups = PhrasebookGroup.groups(from: MockPhrasebook.make(now: now).shuffled())
        #expect(groups.map(\.place) == ["At the doctor", "Trains & travel", "With my landlord", "At work"])
        #expect(groups.allSatisfy { $0.phrases.count == 2 })
        #expect(groups.allSatisfy { !$0.isNew })
        #expect(groups.first?.phrases.first?.german == "Können wir den Termin auf morgen verschieben?")
    }

    @Test("A place with new phrases comes first and is marked new")
    func newGroupFirst() {
        var phrases = MockPhrasebook.make(now: now)
        phrases.append(Phrase(german: "Sind da Nüsse drin?", english: "Are there nuts in it?",
                              place: "At the bakery", placeSymbol: "birthday.cake", isNew: true,
                              createdAt: now.addingTimeInterval(60)))

        let groups = PhrasebookGroup.groups(from: phrases)
        #expect(groups.first?.place == "At the bakery")
        #expect(groups.first?.isNew == true)
        #expect(groups.dropFirst().map(\.place) == ["At the doctor", "Trains & travel", "With my landlord", "At work"])
    }
}
