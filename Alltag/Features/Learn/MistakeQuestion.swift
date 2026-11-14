//
//  MistakeQuestion.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import Foundation

/// One of the learner's mistakes, ready to be asked about: what they said,
/// the correction, and what each way of fixing it needs.
struct MistakeQuestion: Identifiable, Equatable {
    /// The Memory item's `uuid`.
    let id: UUID
    let said: String
    let correction: String
    /// Shown after the answer.
    let explanation: String
    /// Where it was said, e.g. a scenario's title or "Articles".
    let source: String

    // Which sounds natural?
    let options: [String]
    let correctIndex: Int

    // Tap the wrong word, then pick the fix.
    let saidWords: [String]
    /// The places in `saidWords` that are the mistake. Empty when a word is only missing, or it was reworded.
    let wrongWords: Set<Int>
    /// What could stand there instead. Empty when the word simply doesn't belong.
    let fixOptions: [String]
    let fixIndex: Int

    // Fill the gap, or type what's missing.
    /// The places in `correctionWords` that what was said doesn't have: the gaps.
    let fixWords: Set<Int>
    /// The words that belong in the gaps.
    let fix: String

    // Build the corrected sentence from tiles.
    let correctionWords: [String]
    /// The correction's words and the wrong ones, mixed.
    let tiles: [String]

    var canSpot: Bool { !wrongWords.isEmpty }
    /// A gap with choices needs something to choose between.
    var canFill: Bool { !fixOptions.isEmpty }
    /// One or two words to type; more is a rewording, not a gap.
    var canType: Bool { (1...2).contains(fixWords.count) }

    func isFix(_ typed: String) -> Bool { Self.plain(typed) == Self.plain(fix) }
    /// Two to nine words: one tile is no puzzle, and more don't fit a phone.
    var canBuild: Bool { (2...9).contains(correctionWords.count) }

    func isBuilt(_ words: [String]) -> Bool {
        words.map { Self.plain($0) } == correctionWords.map { Self.plain($0) }
    }

    init(item: MemoryItem, shuffle: ([String]) -> [String] = { $0.shuffled() }) {
        id = item.uuid
        said = item.mistakeOriginal
        correction = item.context.isEmpty ? item.word : item.context
        explanation = [item.meaning, item.contextNote].filter { !$0.isEmpty }.joined(separator: ". ")
        source = item.sourceDetail.isEmpty ? String(localized: item.source.title) : item.sourceDetail

        // Whole sentence against whole sentence, alternating which comes first so it can't be guessed.
        let correctFirst = correction.count.isMultiple(of: 2)
        options = correctFirst ? [correction, said] : [said, correction]
        correctIndex = correctFirst ? 0 : 1

        let spoken = Self.words(said)
        let target = Self.words(correction).map { $0.trimmingCharacters(in: Self.sentenceEnd) }.filter { !$0.isEmpty }
        let marked = MistakePractice.wrongWords(said: said, correction: correction)
        saidWords = spoken
        correctionWords = target
        wrongWords = marked

        let wrong = marked.sorted().map { spoken[$0].trimmingCharacters(in: Self.sentenceEnd) }
        let missing = Self.missing(in: spoken, from: target)
        let fix = missing.map { target[$0] }.joined(separator: " ")
        fixWords = Set(missing)
        self.fix = fix
        let wrongText = wrong.joined(separator: " ")
        // Nothing to pick when the word doesn't belong at all, or only stands in the wrong place.
        if wrong.isEmpty || fix.isEmpty || Self.plain(fix) == Self.plain(wrongText) {
            fixOptions = []
            fixIndex = 0
        } else {
            var choices = [fix, wrongText]
            // der, die, das: offer all three.
            let articles = ["der", "die", "das"]
            if choices.allSatisfy({ articles.contains($0.lowercased()) }) {
                choices += articles.filter { article in !choices.contains { $0.lowercased() == article } }
            }
            let mixed = shuffle(choices)
            fixOptions = mixed
            fixIndex = mixed.firstIndex(of: fix) ?? 0
        }

        let known = Set(target.map { Self.plain($0) })
        let distractors = wrong.filter { !known.contains(Self.plain($0)) }
        var mixed = shuffle(target + distractors)
        // Never hand over the answer already in order.
        if Array(mixed.prefix(target.count)) == target, mixed.count > 1 { mixed.append(mixed.removeFirst()) }
        tiles = mixed
    }

    private static let sentenceEnd = CharacterSet(charactersIn: ".!?…")

    /// Without capitals and punctuation, for comparing.
    private static func plain(_ text: String) -> String { ConversationModel.normalized(text) }

    private static func words(_ text: String) -> [String] {
        text.split(whereSeparator: \.isWhitespace).map(String.init)
    }

    /// The places in the correction's words that what was said doesn't have: what should stand in the wrong words' place.
    private static func missing(in spoken: [String], from target: [String]) -> [Int] {
        let difference = spoken.map { plain($0) }.difference(from: target.map { plain($0) })
        return difference.removals.compactMap { change in
            if case .remove(let offset, _, _) = change { offset } else { nil }
        }
        .sorted()
    }
}
