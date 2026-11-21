//
//  AutoCorrector.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 21.11.26.
//

import CoreGraphics
import Foundation

/// One letter as it was typed: which one, and where the finger came down for it.
struct TypedLetter: Equatable {
    var text: Character
    /// Nil when no tap chose the letter: VoiceOver, a slide to it, a held letter.
    var point: CGPoint?
}

/// A word as it was typed, and the word the keyboard takes it for.
struct Correction: Equatable {
    var typed: String
    var replacement: String
}

/// Where the letters sit on the keyboard, to tell how far a touch was from a letter it may have meant.
struct KeyCentres: Equatable {
    private(set) var size: CGSize = .zero
    private var frames: [Character: CGRect] = [:]
    /// From one key to the next and from one row to the next; distances are counted in these.
    private var pitch = CGSize(width: 1, height: 1)
    /// The letters right over the space bar.
    private var overSpace: Set<Character> = []

    /// The keys of the iPhone Apple's keyboard was measured on, for letters no touch chose.
    static let standard = KeyCentres(KeyboardGeometry(rows: KeyboardLayout.allRows(for: .letters, showsGlobe: false),
                                                      size: CGSize(width: 440, height: 271)))

    init(_ geometry: KeyboardGeometry) {
        var found: [Character: CGRect] = [:]
        for frame in geometry.frames {
            guard case .character(let text) = frame.key, text.count == 1, let letter = text.first, letter.isLetter else { continue }
            found[letter] = frame.frame
        }
        guard let first = found["q"], let next = found["w"], let below = found["a"] else { return }
        frames = found
        size = geometry.size
        pitch = CGSize(width: max(next.midX - first.midX, 1), height: max(below.midY - first.midY, 1))
        if let space = geometry.frame(of: .space)?.frame {
            let lowest = found.values.map(\.midY).max() ?? 0
            let over = found.filter { abs($0.value.midY - lowest) < 1 && $0.value.midX > space.minX && $0.value.midX < space.maxX }
            overSpace = Set(over.keys)
        }
    }

    var isEmpty: Bool { frames.isEmpty }

    /// The key a character is typed with: ß and é are held letters of s and e.
    static func key(of character: Character) -> Character {
        let lower = character.lowercased().first ?? character
        return heldLetters[lower] ?? lower
    }

    private static let heldLetters: [Character: Character] = {
        var keys: [Character: Character] = [:]
        for key in "abcdefghijklmnopqrstuvwxyz" {
            for held in KeyboardLayout.alternates(for: String(key)) {
                if let letter = held.first { keys[letter] = key }
            }
        }
        return keys
    }()

    /// How far a letter's touch was from the key of `character`, in keys. Nil for a character without a key.
    func distance(from letter: TypedLetter, to character: Character) -> Double? {
        guard let target = frames[Self.key(of: character)] else { return nil }
        let origin: CGPoint
        if let point = letter.point {
            origin = point
        } else if let own = frames[Self.key(of: letter.text)] {
            origin = CGPoint(x: own.midX, y: own.midY)
        } else {
            return nil
        }
        return hypot(Double((origin.x - target.midX) / pitch.width), Double((origin.y - target.midY) / pitch.height))
    }

    /// The other keys a touch may have meant, the nearest first.
    func neighbours(of letter: TypedLetter, within reach: Double) -> [Character] {
        let own = Self.key(of: letter.text)
        var near: [(key: Character, distance: Double)] = []
        for key in frames.keys where key != own {
            if let distance = self.distance(from: letter, to: key), distance <= reach {
                near.append((key, distance))
            }
        }
        near.sort { $0.distance < $1.distance || ($0.distance == $1.distance && $0.key < $1.key) }
        return near.map { $0.key }
    }

    /// Whether a letter's touch was low on a key over the space bar: it may have meant a space.
    func mayBeSpace(_ letter: TypedLetter) -> Bool {
        let key = Self.key(of: letter.text)
        guard overSpace.contains(key), let point = letter.point, let frame = frames[key] else { return false }
        return point.y > frame.midY + frame.height * 0.15
    }
}

/// Finds the word a mistyped one was meant to be. The dictionary says which words exist;
/// where the fingers landed says which of them is the likeliest.
///
/// A word the dictionary knows is never changed, so a wrong but real word stays.
struct AutoCorrector {
    var centres: KeyCentres
    var checker: WordChecking
    /// The words every text is full of: they win when two words are as near.
    var isCommon: (String) -> Bool = { _ in false }
    /// Whether a word often follows the one before it.
    var fits: (String) -> Bool = { _ in false }

    private struct Candidate {
        var text: String
        var cost: Double
    }

    /// How far from the touch another key may be to count as meant.
    static let reach = 1.3
    private static let extraLetter = 0.7
    private static let doubledLetter = 0.45
    private static let missingLetter = 0.7
    private static let swappedLetters = 0.5
    /// The same letters with a capital: a noun typed small. Dear enough for a clear slip to a common word to win.
    private static let capitalOnly = 0.3
    private static let commonWord = 0.3
    private static let fittingWord = 0.3
    /// What the dictionary's first guesses are worth.
    private static let guessBonus = [0.2, 0.1, 0.05]

    /// What a correction may cost. A short word has few letters to go by, so it needs a clear slip.
    static func limit(for length: Int) -> Double {
        switch length {
        case ...2: 0.4
        case 3: 0.65
        case 4...6: 0.8
        default: 1
        }
    }

    func correction(of letters: [TypedLetter]) -> Correction? {
        let typed = String(letters.map(\.text))
        // Capitals inside a word are a name or an abbreviation; those are left as they are.
        guard (2...24).contains(letters.count), letters.allSatisfy({ $0.text.isLetter }),
              typed.dropFirst().allSatisfy(\.isLowercase), !isKnown(typed) else { return nil }
        let lower = letters.map { TypedLetter(text: $0.text.lowercased().first ?? $0.text, point: $0.point) }
        let isCapital = letters[0].text.isUppercase
        let limit = Self.limit(for: lower.count)
        var costs: [String: Double] = [:]
        func offer(_ candidate: Candidate?) {
            guard let candidate, candidate.text != typed else { return }
            costs[candidate.text] = min(costs[candidate.text] ?? .infinity, candidate.cost)
        }
        for word in [lower.map(\.text)] + nearWords(to: lower) {
            offer(candidate(word, for: lower, isCapital: isCapital, limit: limit))
        }
        for split in splits(of: lower, isCapital: isCapital) { offer(split) }
        // The dictionary's own guesses know about letters left out, and which word is the usual one.
        for (rank, guess) in checker.guesses(for: typed).prefix(6).enumerated() where guess.allSatisfy(\.isLetter) {
            let written = isCapital ? SuggestionPicker.matchingCapital(of: typed, in: guess) : guess
            if costs[written] == nil {
                offer(Candidate(text: written, cost: cost(of: Array(guess.lowercased()), typed: lower) - bonus(for: written)))
            }
            if lower.count > 2, rank < Self.guessBonus.count, let price = costs[written] {
                costs[written] = price - Self.guessBonus[rank]
            }
        }
        guard let found = costs.min(by: { ($0.value, $0.key) < ($1.value, $1.key) }), found.value <= limit else { return nil }
        return Correction(typed: typed, replacement: found.key)
    }

    // MARK: - Candidates

    private func isKnown(_ typed: String) -> Bool {
        let lower = typed.lowercased()
        if checker.isWord(typed) || checker.isForeignWord(typed) { return true }
        return lower != typed && (checker.isWord(lower) || checker.isForeignWord(lower))
    }

    /// The word as it is written: a noun with its capital, any word with one where the typed word had one.
    private func form(of lower: String, capital: Bool) -> String? {
        let capitalised = lower.prefix(1).uppercased() + lower.dropFirst()
        if capital { return checker.isWord(capitalised) || checker.isWord(lower) ? capitalised : nil }
        if checker.isWord(lower) { return lower }
        return checker.isWord(capitalised) ? capitalised : nil
    }

    private func bonus(for word: String) -> Double {
        (isCommon(word.lowercased()) ? Self.commonWord : 0) + (fits(word) ? Self.fittingWord : 0)
    }

    /// A word near the typed one, if the dictionary knows it.
    private func candidate(_ word: [Character], for typed: [TypedLetter], isCapital: Bool, limit: Double) -> Candidate? {
        let isSame = word == typed.map(\.text)
        // Two letters with a capital are mostly a chemist's: "Ir", "Sn".
        if isSame, word.count < 3 { return nil }
        let price = isSame ? Self.capitalOnly : cost(of: word, typed: typed)
        // The dictionary is slow, so it is asked only about words that could still win.
        guard price - Self.commonWord - Self.fittingWord - Self.guessBonus[0] <= limit,
              let written = form(of: String(word), capital: isCapital) else { return nil }
        return Candidate(text: written, cost: price - bonus(for: written))
    }

    /// Letters that are often typed for another: the umlauts and ß are a reach or a long press away.
    static func variants(of letter: Character) -> [Character] {
        switch letter {
        case "a": ["ä"]
        case "o": ["ö"]
        case "u": ["ü"]
        case "s": ["ß"]
        default: []
        }
    }

    /// The typed letters with one slip undone: a neighbouring key, two letters swapped, a letter too many.
    private func nearWords(to typed: [TypedLetter]) -> [[Character]] {
        let word = typed.map(\.text)
        var words: [[Character]] = []
        for index in word.indices {
            for key in centres.neighbours(of: typed[index], within: Self.reach) + Self.variants(of: word[index]) {
                var changed = word
                changed[index] = key
                words.append(changed)
            }
            if index > 0, word[index] != word[index - 1] {
                var changed = word
                changed.swapAt(index - 1, index)
                words.append(changed)
            }
            if word.count > 3 {
                var changed = word
                changed.remove(at: index)
                words.append(changed)
            }
        }
        return words
    }

    /// Two words where a space was left out, or where the finger hit a letter over the space bar.
    private func splits(of typed: [TypedLetter], isCapital: Bool) -> [Candidate] {
        let word = typed.map(\.text)
        guard word.count >= 4 else { return [] }
        var found: [Candidate] = []
        for cut in 2...(word.count - 2) {
            if let pair = self.pair(word[..<cut], word[cut...], isCapital: isCapital, needsCommon: true) {
                found.append(Candidate(text: pair.text, cost: pair.bothCommon ? 0.45 : 0.6))
            }
            if cut < word.count - 2, centres.mayBeSpace(typed[cut]),
               let pair = self.pair(word[..<cut], word[(cut + 1)...], isCapital: isCapital, needsCommon: false) {
                found.append(Candidate(text: pair.text, cost: 0.45))
            }
        }
        return found
    }

    /// Two real words. Run together they need a common word among them, or long words would fall apart.
    private func pair(_ left: ArraySlice<Character>, _ right: ArraySlice<Character>, isCapital: Bool,
                      needsCommon: Bool) -> (text: String, bothCommon: Bool)? {
        let first = String(left)
        let second = String(right)
        let firstIsCommon = isCommon(first)
        let secondIsCommon = isCommon(second)
        guard !needsCommon || firstIsCommon || secondIsCommon,
              let start = form(of: first, capital: isCapital), let end = form(of: second, capital: false) else { return nil }
        return ("\(start) \(end)", firstIsCommon && secondIsCommon)
    }

    // MARK: - Cost

    /// What it costs to take the typed letters for `word`: little where a touch was close to the
    /// word's letter, more for a letter too many, one left out or two swapped.
    func cost(of word: [Character], typed: [TypedLetter]) -> Double {
        guard !word.isEmpty, !typed.isEmpty else { return .infinity }
        var table = Array(repeating: Array(repeating: 0.0, count: word.count + 1), count: typed.count + 1)
        for row in 1...typed.count { table[row][0] = table[row - 1][0] + Self.extraLetter }
        for column in 1...word.count { table[0][column] = table[0][column - 1] + Self.missingLetter }
        for row in 1...typed.count {
            for column in 1...word.count {
                let isDoubled = row > 1 && typed[row - 1].text == typed[row - 2].text
                var best = min(table[row - 1][column - 1] + substitution(of: typed[row - 1], for: word[column - 1]),
                               table[row - 1][column] + (isDoubled ? Self.doubledLetter : Self.extraLetter),
                               table[row][column - 1] + Self.missingLetter)
                if row > 1, column > 1, typed[row - 1].text == word[column - 2], typed[row - 2].text == word[column - 1] {
                    best = min(best, table[row - 2][column - 2] + Self.swappedLetters)
                }
                table[row][column] = best
            }
        }
        return table[typed.count][word.count]
    }

    private func substitution(of letter: TypedLetter, for character: Character) -> Double {
        if letter.text == character { return 0 }
        if KeyCentres.key(of: letter.text) == KeyCentres.key(of: character) { return 0.1 }
        if Self.variants(of: letter.text).contains(character) { return 0.3 }
        guard let distance = centres.distance(from: letter, to: character) else { return 3 }
        return min(0.6 * distance * distance, 3)
    }
}
