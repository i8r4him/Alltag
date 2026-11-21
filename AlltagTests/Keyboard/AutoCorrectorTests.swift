//
//  AutoCorrectorTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 21.11.26.
//

import CoreGraphics
import Foundation
import Testing
@testable import Alltag

/// What a mistyped word is taken for. Every touch is given, so nothing depends on a finger.
@Suite("Keyboard corrections")
@MainActor
struct AutoCorrectorTests {
    let geometry = KeyboardGeometry(rows: KeyboardLayout.allRows(for: .letters, showsGlobe: false),
                                    size: CGSize(width: 440, height: 271))

    func frame(_ letter: Character) throws -> CGRect {
        try #require(geometry.frame(of: .character(String(letter)))).frame
    }

    /// One touch that landed part of the way to another key.
    struct Lean {
        var index: Int
        var toward: Character
        var share: CGFloat
    }

    /// A word's letters, each touched in the middle of its key. `leaning` moves one touch
    /// towards another key; `low` moves one down on its key.
    func letters(_ word: String, leaning: Lean? = nil, low: Int? = nil) throws -> [TypedLetter] {
        try word.enumerated().map { index, letter in
            let own = try frame(Character(letter.lowercased()))
            var point = CGPoint(x: own.midX, y: own.midY)
            if let leaning, leaning.index == index {
                let other = try frame(leaning.toward)
                point.x += (other.midX - own.midX) * leaning.share
                point.y += (other.midY - own.midY) * leaning.share
            }
            if low == index { point.y += own.height * 0.35 }
            return TypedLetter(text: letter, point: point)
        }
    }

    func corrector(_ words: String, common: Set<String> = []) -> AutoCorrector {
        var corrector = AutoCorrector(centres: KeyCentres(geometry), checker: FixedDictionary(words))
        corrector.isCommon = { common.contains($0) }
        return corrector
    }

    @Test("A word the dictionary knows is left alone, with or without its capital")
    func known() throws {
        let corrector = corrector("nicht Tisch")
        #expect(try corrector.correction(of: letters("nicht")) == nil)
        #expect(try corrector.correction(of: letters("Nicht")) == nil)
        #expect(try corrector.correction(of: letters("Tisch")) == nil)
    }

    @Test("A slip to the key next door is put right, and a capital stays")
    func neighbour() throws {
        let corrector = corrector("nicht")
        #expect(try corrector.correction(of: letters("nichr")) == Correction(typed: "nichr", replacement: "nicht"))
        #expect(try corrector.correction(of: letters("Nichr"))?.replacement == "Nicht")
        // Two keys away is no slip.
        #expect(try corrector.correction(of: letters("nichw")) == nil)
    }

    @Test("Where the finger landed decides between two words")
    func touch() throws {
        let corrector = corrector("der des")
        #expect(try corrector.correction(of: letters("dee"))?.replacement == "der")
        let towardS = try letters("dee", leaning: Lean(index: 2, toward: "s", share: 0.6))
        #expect(corrector.correction(of: towardS)?.replacement == "des")
    }

    @Test("A noun typed small gets its capital")
    func noun() throws {
        #expect(try corrector("Tisch").correction(of: letters("tisch"))?.replacement == "Tisch")
        #expect(try corrector("Tisch").correction(of: letters("tisvh"))?.replacement == "Tisch")
    }

    @Test("An umlaut or ß left out is put in")
    func umlaut() throws {
        let corrector = corrector("für heiß")
        #expect(try corrector.correction(of: letters("fur"))?.replacement == "für")
        #expect(try corrector.correction(of: letters("heis"))?.replacement == "heiß")
    }

    @Test("Two swapped letters, a letter too many and a letter left out are put right")
    func lettersOutOfPlace() throws {
        let corrector = corrector("nicht kommen")
        #expect(try corrector.correction(of: letters("nihct"))?.replacement == "nicht")
        #expect(try corrector.correction(of: letters("nichtt"))?.replacement == "nicht")
        #expect(try corrector.correction(of: letters("nict"))?.replacement == "nicht")
        #expect(try corrector.correction(of: letters("komen"))?.replacement == "kommen")
    }

    @Test("Two words typed without a space are split, if one of them is a common word")
    func split() throws {
        let words = "ich bin Haus Tür"
        #expect(try corrector(words, common: ["ich", "bin"]).correction(of: letters("ichbin"))?.replacement == "ich bin")
        #expect(try corrector(words, common: ["ich", "bin"]).correction(of: letters("Ichbin"))?.replacement == "Ich bin")
        #expect(try corrector(words).correction(of: letters("ichbin")) == nil)
    }

    @Test("A touch low on a letter over the space bar was meant for the space bar")
    func missedSpace() throws {
        let corrector = corrector("ich bin")
        #expect(try corrector.correction(of: letters("ichnbin", low: 3))?.replacement == "ich bin")
        #expect(try corrector.correction(of: letters("ichnbin")) == nil)
    }

    @Test("Short words, abbreviations and names with capitals inside are left alone")
    func leftAlone() throws {
        let corrector = corrector("ok an in")
        #expect(try corrector.correction(of: letters("x")) == nil)
        #expect(try corrector.correction(of: letters("OK")) == nil)
        #expect(try corrector.correction(of: letters("iPhone")) == nil)
        // In a word of two letters a slip has to be clear: the middle of a key is not.
        #expect(try corrector.correction(of: letters("im")) == nil)
        let towardN = try letters("im", leaning: Lean(index: 1, toward: "n", share: 0.45))
        #expect(corrector.correction(of: towardN)?.replacement == "in")
    }

    @Test("Of two words as near, the one that often follows the word before wins")
    func context() throws {
        // n lies between b and m.
        var corrector = corrector("Butter Mutter")
        corrector.fits = { $0 == "Mutter" }
        #expect(try corrector.correction(of: letters("nutter"))?.replacement == "Mutter")
        corrector.fits = { $0 == "Butter" }
        #expect(try corrector.correction(of: letters("nutter"))?.replacement == "Butter")
    }

    @Test("A letter without a touch counts as the middle of its key")
    func noTouch() {
        let corrector = AutoCorrector(centres: .standard, checker: FixedDictionary("nicht"))
        let typed = "nichr".map { TypedLetter(text: $0, point: nil) }
        #expect(corrector.correction(of: typed)?.replacement == "nicht")
    }
}
