//
//  KeyboardModelTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import CoreGraphics
import Foundation
import Testing
@testable import Alltag

/// The tests press keys through the same calls the touch layer makes. What a
/// held key does is called directly (`longPress`, `repeatDelete`), so no test
/// waits for a timer.
@Suite("Keyboard touches")
@MainActor
struct KeyboardModelTests {
    let document = FakeDocument()
    let model = KeyboardModel()
    let size = CGSize(width: 393, height: 260)

    init() {
        model.document = document
        model.documentChanged(KeyboardTraits(capitalisation: .none))
    }

    var geometry: KeyboardGeometry { KeyboardGeometry(rows: model.rows, size: size) }

    func centre(of key: KeyboardKey) throws -> CGPoint {
        let frame = try #require(geometry.frame(of: key)).frame
        return CGPoint(x: frame.midX, y: frame.midY)
    }

    func press(_ touch: Int, _ key: KeyboardKey) throws {
        try model.touchDown(touch, at: centre(of: key), in: geometry)
    }

    @Test("A key types when the finger lifts, and shows its letter while it is down")
    func tap() throws {
        try press(1, .character("q"))
        #expect(document.before.isEmpty)
        #expect(model.popup?.options == ["q"])
        #expect(model.pressed == [.character("q")])
        model.touchUp(1)
        #expect(document.before == "q")
        #expect(model.popup == nil)
        #expect(model.pressed.isEmpty)
    }

    @Test("A second finger types the first key at once, so two thumbs keep their order")
    func twoThumbs() throws {
        try press(1, .character("h"))
        try press(2, .character("i"))
        #expect(document.before == "h")
        model.touchUp(2)
        model.touchUp(1)
        #expect(document.before == "hi")
    }

    @Test("Sliding to another letter types that one")
    func slide() throws {
        try press(1, .character("q"))
        try model.touchMoved(1, to: centre(of: .character("w")), in: geometry)
        #expect(model.popup?.options == ["w"])
        model.touchUp(1)
        #expect(document.before == "w")
    }

    @Test("A touch the system takes away types nothing")
    func cancelled() throws {
        try press(1, .character("q"))
        model.touchCancelled(1)
        #expect(document.before.isEmpty)
        #expect(model.popup == nil)
        #expect(model.pressed.isEmpty)
    }

    @Test("Holding s offers ß, and lifting types it")
    func eszett() throws {
        try press(1, .character("s"))
        model.longPress(1, in: geometry)
        #expect(model.popup?.options == ["ß", "ś", "š"])
        model.touchUp(1)
        #expect(document.before == "ß")
    }

    @Test("Sliding along the held letters chooses one")
    func chooseAlternate() throws {
        try press(1, .character("a"))
        model.longPress(1, in: geometry)
        let popup = try #require(model.popup)
        let third = popup.minX(in: size.width) + popup.cellWidth * 2.5
        model.touchMoved(1, to: CGPoint(x: third, y: 0), in: geometry)
        #expect(model.popup?.selection == 2)
        model.touchUp(1)
        #expect(document.before == "â")
    }

    @Test("On the right half the held letters run to the left, the first one over the key")
    func alternatesOnTheRight() throws {
        try press(1, .character("o"))
        model.longPress(1, in: geometry)
        let popup = try #require(model.popup)
        #expect(popup.runsLeft(in: size.width))
        #expect(popup.option(at: popup.frame.frame.midX, in: size.width) == 0)
        #expect(popup.option(at: popup.minX(in: size.width) + 1, in: size.width) == popup.options.count - 1)
        #expect(popup.minX(in: size.width) >= 0)
    }

    @Test("A key without other letters shows nothing more when held")
    func noAlternates() throws {
        try press(1, .character("q"))
        model.longPress(1, in: geometry)
        #expect(model.popup?.isAlternates == false)
        model.touchUp(1)
        #expect(document.before == "q")
    }

    @Test("Shift gives one capital")
    func shift() throws {
        try press(1, .shift)
        #expect(model.shift == .once)
        model.touchUp(1)
        try press(2, .character("a"))
        model.touchUp(2)
        try press(3, .character("b"))
        model.touchUp(3)
        #expect(document.before == "Ab")
    }

    @Test("Delete takes a letter as soon as it is touched")
    func delete() throws {
        document.before = "ab"
        try press(1, .delete)
        #expect(document.before == "a")
        model.touchUp(1)
        #expect(document.before == "a")
    }

    @Test("A held delete takes letters first and whole words later")
    func heldDelete() {
        document.before = "Guten Morgen"
        model.repeatDelete(step: 0)
        #expect(document.before == "Guten Morge")
        model.repeatDelete(step: KeyboardModel.wordsAfter)
        #expect(document.before == "Guten ")
    }

    @Test("Holding the space bar moves the cursor and types no space")
    func cursor() throws {
        document.before = "Hallo"
        try press(1, .space)
        model.longPress(1, in: geometry)
        #expect(model.movesCursor)
        let start = try centre(of: .space)
        model.touchMoved(1, to: CGPoint(x: start.x - KeyboardModel.cursorStep * 3.5, y: start.y), in: geometry)
        #expect(document.before == "Ha")
        #expect(document.after == "llo")
        model.touchMoved(1, to: CGPoint(x: start.x - KeyboardModel.cursorStep * 1.8, y: start.y), in: geometry)
        #expect(document.before == "Hal")
        model.touchUp(1)
        #expect(!model.movesCursor)
        #expect(document.before == "Hal")
    }

    @Test("The symbols stay for the next sign and go back to the letters after a space")
    func pages() throws {
        try press(1, .page(.symbols))
        model.touchUp(1)
        #expect(model.page == .symbols)
        model.activate(.character("?"))
        #expect(model.page == .symbols)
        model.activate(.space)
        #expect(model.page == .letters)
        #expect(document.before == "? ")
    }

    @Test("An apostrophe goes straight back to the letters")
    func apostrophe() {
        model.activate(.page(.symbols))
        model.activate(.character("'"))
        #expect(model.page == .letters)
    }

    @Test("Words are offered for the one being typed, and a tap puts one in")
    func suggestions() {
        model.suggester = FixedWords(words: ["hau": ["haus", "hause"]])
        for letter in ["h", "a", "u"] { model.activate(.character(letter)) }
        model.refreshSuggestions()
        #expect(model.suggestions == ["haus", "hause"])
        model.choose("hause")
        #expect(document.before == "hause ")
        #expect(model.suggestions.isEmpty)
    }

    @Test("No words are offered where the text field doesn't want them")
    func noSuggestions() {
        model.suggester = FixedWords(words: ["hau": ["haus"]])
        model.documentChanged(KeyboardTraits(capitalisation: .none, offersSuggestions: false))
        for letter in ["h", "a", "u"] { model.activate(.character(letter)) }
        model.refreshSuggestions()
        #expect(model.suggestions.isEmpty)
    }

    @Test("The globe key shows when iOS asks for it and switches the keyboard")
    func globe() {
        var switched = 0
        model.onNextKeyboard = { switched += 1 }
        #expect(!model.rows.flatMap { $0 }.contains(.globe))
        model.documentChanged(KeyboardTraits(showsGlobe: true))
        #expect(model.rows.flatMap { $0 }.contains(.globe))
        model.activate(.globe)
        #expect(switched == 1)
    }

    @Test("The return key types a new line")
    func enter() throws {
        document.before = "Hallo"
        try press(1, .enter)
        model.touchUp(1)
        #expect(document.before == "Hallo\n")
    }
}
