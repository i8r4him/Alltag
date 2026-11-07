//
//  DebriefModel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Observation
import SwiftData

/// Debrief: what the learner wanted to say, the phrases for next time, and
/// saving them to the Phrasebook.
@Observable
final class DebriefModel {
    enum Phase: Equatable {
        case input
        case thinking
        case result
    }

    /// The moment being debriefed, e.g. lunch at the bakery.
    let moment: Debrief
    /// What the learner wanted to say. Editing it returns to the input.
    var input: String {
        didSet { if input != oldValue, phase != .thinking { phase = .input } }
    }
    private(set) var phase: Phase = .input
    private(set) var result: Debrief?

    private let companion: any CompanionService

    init(moment: Debrief = MockDebrief.bakery, services: AppServices) {
        self.moment = moment
        input = moment.sampleInput
        companion = services.companion
    }

    var canFind: Bool { phase == .input && !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

    /// Asks the companion how to say it.
    func findWords() async {
        guard canFind else { return }
        phase = .thinking
        result = try? await companion.debrief(input)
        phase = result == nil ? .input : .result
    }

    /// The grammar tip with the phrase before " + " in bold, e.g. **allergisch gegen** + accusative.
    static func styledTip(_ text: String) -> AttributedString {
        var tip = AttributedString(text)
        if let range = tip.range(of: " + ") {
            tip[tip.startIndex..<range.lowerBound].inlinePresentationIntent = .stronglyEmphasized
        }
        return tip
    }

    // MARK: Phrasebook

    func isSaved(in phrases: [Phrase]) -> Bool {
        guard let result else { return false }
        let saved = Set(phrases.map(\.german))
        return result.phrases.allSatisfy { saved.contains($0.german) }
    }

    /// Adds the phrases to the Phrasebook (marked NEW), or removes them again.
    /// Returns whether they are saved afterwards.
    @discardableResult
    func toggleSave(in context: ModelContext) -> Bool {
        guard let result else { return false }
        let germans = result.phrases.map(\.german)
        let existing = (try? context.fetch(FetchDescriptor<Phrase>(predicate: #Predicate { germans.contains($0.german) }))) ?? []
        if existing.count == germans.count {
            existing.forEach(context.delete)
            try? context.save()
            return false
        }
        let have = Set(existing.map(\.german))
        for phrase in result.phrases where !have.contains(phrase.german) {
            context.insert(Phrase(german: phrase.german, english: phrase.english,
                                  place: result.phrasebookPlace, placeSymbol: result.phrasebookSymbol, isNew: true))
        }
        try? context.save()
        return true
    }
}
