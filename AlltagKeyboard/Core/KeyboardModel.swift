//
//  KeyboardModel.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import CoreGraphics
import Foundation
import Observation

/// What the text field asks of the keyboard.
struct KeyboardTraits: Equatable {
    var capitalisation: AutoCapitalisation = .sentences
    var returnKey: ReturnKeyKind = .normal
    /// iOS shows its own globe under the keyboard on most iPhones; where it doesn't, the keyboard has to.
    var showsGlobe = false
    /// Off in fields for addresses, names and codes, where a dictionary only gets in the way.
    var offersSuggestions = true
    /// Some fields only take return once something is typed.
    var returnEnabled = true
}

/// What one key shows while a finger is on it. Each key watches only its own,
/// so a press redraws one key and not the whole keyboard.
@Observable
final class KeyState {
    var isPressed = false
}

/// The bubble over a pressed key: the key itself, larger, or the letters a long press offers.
struct KeyPopup: Equatable {
    let frame: KeyFrame
    /// One entry is the key itself; more are the alternates, the most wanted first.
    var options: [String]
    var isAlternates = false
    var selection = 0

    /// Alternates run away from the nearer edge, so the first one sits over the key.
    func runsLeft(in width: CGFloat) -> Bool { frame.frame.midX > width / 2 }

    var cellWidth: CGFloat { max(frame.frame.width, 36) }

    /// The left edge of the row of options.
    func minX(in width: CGFloat) -> CGFloat {
        let total = cellWidth * CGFloat(options.count)
        let start = runsLeft(in: width) ? frame.frame.maxX - total : frame.frame.minX
        return min(max(start, 2), max(width - total - 2, 2))
    }

    /// The option under a finger at `x`.
    func option(at x: CGFloat, in width: CGFloat) -> Int {
        let cell = Int(((x - minX(in: width)) / cellWidth).rounded(.down))
        let position = min(max(cell, 0), options.count - 1)
        return runsLeft(in: width) ? options.count - 1 - position : position
    }
}

/// The keyboard's state: which page shows, what is pressed, and what each touch types.
///
/// Touches arrive with the geometry they were made on. A key types when its
/// finger lifts or when the next finger comes down, so fast typing with two
/// thumbs loses nothing.
@Observable
final class KeyboardModel {
    private(set) var page: KeyboardPage = .letters
    /// Kept apart from the engine, so the keys redraw when Shift changes and not at every letter.
    private(set) var shift: ShiftState = .off
    private(set) var traits = KeyboardTraits()
    private(set) var suggestions: [String] = []
    private(set) var popup: KeyPopup?
    private(set) var pressed: Set<KeyboardKey> = []
    /// Holding the space bar turns it into a trackpad for the cursor.
    private(set) var movesCursor = false
    /// The emoji take the place of the keys.
    private(set) var showsEmoji = false

    /// Fix and "How do I say …?": they read and replace the text through the model.
    let tools = KeyboardTools()

    @ObservationIgnored private(set) var engine = TypingEngine() {
        didSet {
            if shift != engine.shift { shift = engine.shift }
        }
    }
    @ObservationIgnored var document: TextDocument?
    @ObservationIgnored var feedback: KeyFeedback?
    @ObservationIgnored var suggester: WordSuggesting?
    @ObservationIgnored var onNextKeyboard: () -> Void = {}

    @ObservationIgnored private var presses: [Int: Press] = [:]
    @ObservationIgnored private var holds: [Int: Task<Void, Never>] = [:]
    @ObservationIgnored private var suggesting: Task<Void, Never>?
    @ObservationIgnored private var lastShiftTap: Date?
    @ObservationIgnored private var pressCount = 0
    @ObservationIgnored private var states: [KeyboardKey: KeyState] = [:]

    var rows: [[KeyboardKey]] { KeyboardLayout.allRows(for: page, showsGlobe: traits.showsGlobe) }

    init() {
        tools.text = { [weak self] in self?.document?.textBeforeCursor ?? "" }
        tools.replace = { [weak self] old, new in self?.replace(old, with: new) ?? false }
    }

    /// The state one key draws itself from.
    func state(of key: KeyboardKey) -> KeyState {
        if let state = states[key] { return state }
        let state = KeyState()
        states[key] = state
        return state
    }

    /// The text field or the cursor changed.
    func documentChanged(_ traits: KeyboardTraits) {
        if self.traits != traits { self.traits = traits }
        engine.capitalisation = traits.capitalisation
        if let document { engine.sync(with: document) }
        suggestSoon()
    }

    /// Does what a key does, at once: VoiceOver and tests press keys this way.
    func activate(_ key: KeyboardKey) {
        switch key {
        case .character(let text): type(text)
        case .shift: tapShift()
        case .delete: delete()
        case .page(let page): self.page = page
        case .globe: onNextKeyboard()
        case .emoji: showsEmoji = true
        case .space: space()
        case .enter: enter()
        }
    }

    // MARK: - Emoji

    func insertEmoji(_ emoji: String) {
        guard let document else { return }
        feedback?.keyDown(.emoji)
        tools.close()
        engine.insert(emoji, in: document)
        if !suggestions.isEmpty { suggestions = [] }
    }

    /// The delete key of the emoji panel.
    func deleteFromEmoji() {
        feedback?.keyDown(.delete)
        delete()
    }

    func closeEmoji() {
        showsEmoji = false
    }

    /// Puts a suggested word in place of the one being typed.
    func choose(_ suggestion: String) {
        guard let document else { return }
        tools.close()
        engine.apply(suggestion, in: document)
        suggestions = []
    }

    /// Puts a tool's answer in place of the text it was made from.
    func replace(_ old: String, with new: String) -> Bool {
        guard let document, engine.replace(old, with: new, in: document) else { return false }
        feedback?.keyDown(.enter)
        if !suggestions.isEmpty { suggestions = [] }
        return true
    }

    /// Looks up words for the one at the cursor.
    func refreshSuggestions() {
        guard traits.offersSuggestions, let suggester else {
            if !suggestions.isEmpty { suggestions = [] }
            return
        }
        let found = suggester.suggestions(for: TypingEngine.currentWord(in: engine.context))
        if found != suggestions { suggestions = found }
    }

    // MARK: - Typing

    private func type(_ text: String) {
        guard let document else { return }
        tools.close()
        engine.typeCharacter(text, in: document)
        // An apostrophe is nearly always followed by a letter.
        if text == "'", page != .letters { page = .letters }
        suggestSoon()
    }

    private func space() {
        guard let document else { return }
        tools.close()
        engine.space(in: document)
        if page != .letters { page = .letters }
        suggestSoon()
    }

    private func enter() {
        guard let document, traits.returnEnabled else { return }
        tools.close()
        engine.enter(in: document)
        if page != .letters { page = .letters }
        suggestSoon()
    }

    private func delete() {
        guard let document else { return }
        tools.close()
        engine.delete(in: document)
        suggestSoon()
    }

    private func tapShift() {
        let now = Date.now
        let again = lastShiftTap.map { now.timeIntervalSince($0) < 0.35 } ?? false
        engine.tapShift(again: again)
        lastShiftTap = now
    }

    /// Looking words up in the dictionary takes longer than a key press may. So it waits
    /// for a short pause in the typing; until then only the words that still fit stay.
    private func suggestSoon() {
        suggesting?.cancel()
        keepFittingSuggestions()
        suggesting = Task { [weak self] in
            try? await Task.sleep(for: Self.suggestionPause)
            guard !Task.isCancelled else { return }
            self?.refreshSuggestions()
        }
    }

    /// Drops the offered words the typed letters no longer lead to.
    func keepFittingSuggestions() {
        guard !suggestions.isEmpty else { return }
        let word = TypingEngine.currentWord(in: engine.context).lowercased()
        let fitting = word.isEmpty ? [] : suggestions.filter { $0.lowercased().hasPrefix(word) }
        if fitting != suggestions { suggestions = fitting }
    }
}

// MARK: - Touches

extension KeyboardModel {
    private struct Press {
        var key: KeyboardKey
        /// Where the cursor trackpad last moved the cursor.
        var anchor: CGFloat
        /// Presses type in the order they came down.
        let order: Int
        var movesCursor = false
    }

    private static let suggestionPause: Duration = .milliseconds(140)
    private static let holdDelay: Duration = .milliseconds(380)
    private static let repeatDelay: Duration = .milliseconds(420)
    private static let repeatInterval: Duration = .milliseconds(90)
    private static let wordInterval: Duration = .milliseconds(200)
    /// Held this many repeats, delete takes whole words.
    static let wordsAfter = 14
    /// How far a finger moves on the space bar for one step of the cursor.
    static let cursorStep: CGFloat = 9

    func touchDown(_ touch: Int, at point: CGPoint, in geometry: KeyboardGeometry) {
        guard let frame = geometry.key(at: point) else { return }
        typeHeldCharacters()
        pressCount += 1
        presses[touch] = Press(key: frame.key, anchor: point.x, order: pressCount)
        setPressed(frame.key, true)
        feedback?.keyDown(frame.key)
        switch frame.key {
        case .character(let text):
            popup = KeyPopup(frame: frame, options: [shown(text)])
            hold(touch, for: Self.holdDelay) { [weak self] in self?.longPress(touch, in: geometry) }
        case .space:
            hold(touch, for: Self.holdDelay) { [weak self] in self?.longPress(touch, in: geometry) }
        case .shift:
            tapShift()
        case .delete:
            delete()
            repeatDelete(while: touch)
        case .page(let page):
            self.page = page
        case .globe, .emoji, .enter:
            break
        }
    }

    func touchMoved(_ touch: Int, to point: CGPoint, in geometry: KeyboardGeometry) {
        guard var press = presses[touch] else { return }
        if press.movesCursor {
            let steps = Int((point.x - press.anchor) / Self.cursorStep)
            guard steps != 0 else { return }
            document?.moveCursor(by: steps)
            press.anchor += CGFloat(steps) * Self.cursorStep
            presses[touch] = press
        } else if let popup, popup.isAlternates, popup.frame.key == press.key {
            let selection = popup.option(at: point.x, in: geometry.size.width)
            if selection != popup.selection { self.popup?.selection = selection }
        } else if press.key.isCharacter, let frame = geometry.key(at: point), frame.key != press.key,
                  let text = frame.key.text {
            // The finger slid to another letter before lifting.
            setPressed(press.key, false)
            setPressed(frame.key, true)
            press.key = frame.key
            presses[touch] = press
            popup = KeyPopup(frame: frame, options: [shown(text)])
            hold(touch, for: Self.holdDelay) { [weak self] in self?.longPress(touch, in: geometry) }
        }
    }

    func touchUp(_ touch: Int) {
        guard let press = presses[touch] else { return }
        let chosen = popup?.frame.key == press.key ? popup : nil
        release(touch)
        switch press.key {
        case .character(let text):
            if let chosen, chosen.isAlternates {
                type(KeyboardLayout.alternates(for: text)[chosen.selection])
            } else {
                type(text)
            }
        case .space:
            if !press.movesCursor { space() }
        case .enter:
            enter()
        case .globe:
            onNextKeyboard()
        case .emoji:
            showsEmoji = true
        case .shift, .delete, .page:
            break
        }
    }

    /// The system took the touch away (a call came in, the keyboard went): nothing is typed.
    func touchCancelled(_ touch: Int) {
        release(touch)
    }

    /// A key was held: letters offer their alternates, the space bar becomes a trackpad.
    func longPress(_ touch: Int, in geometry: KeyboardGeometry) {
        guard let press = presses[touch] else { return }
        if press.key == .space {
            presses[touch]?.movesCursor = true
            movesCursor = true
        } else if let text = press.key.text, let frame = geometry.frame(of: press.key) {
            let options = KeyboardLayout.alternates(for: text).map(shown)
            guard !options.isEmpty else { return }
            popup = KeyPopup(frame: frame, options: options, isAlternates: true)
        }
    }

    /// One step of a held delete: letters first, whole words after a while.
    func repeatDelete(step: Int) {
        guard let document else { return }
        tools.close()
        if step < Self.wordsAfter {
            engine.delete(in: document)
        } else {
            engine.deleteWord(in: document)
        }
        suggestSoon()
    }

    /// A second finger came down: what the first one holds is typed now, in order.
    private func typeHeldCharacters() {
        for (touch, press) in presses.sorted(by: { $0.value.order < $1.value.order }) {
            guard let text = press.key.text else { continue }
            let chosen = popup?.frame.key == press.key ? popup : nil
            release(touch)
            if let chosen, chosen.isAlternates {
                type(KeyboardLayout.alternates(for: text)[chosen.selection])
            } else {
                type(text)
            }
        }
    }

    private func release(_ touch: Int) {
        holds.removeValue(forKey: touch)?.cancel()
        guard let press = presses.removeValue(forKey: touch) else { return }
        if !presses.values.contains(where: { $0.key == press.key }) { setPressed(press.key, false) }
        if popup?.frame.key == press.key { popup = nil }
        if press.movesCursor { movesCursor = false }
    }

    private func setPressed(_ key: KeyboardKey, _ isPressed: Bool) {
        if isPressed {
            pressed.insert(key)
        } else {
            pressed.remove(key)
        }
        state(of: key).isPressed = isPressed
    }

    private func hold(_ touch: Int, for delay: Duration, then action: @escaping @MainActor () -> Void) {
        holds[touch]?.cancel()
        holds[touch] = Task {
            try? await Task.sleep(for: delay)
            guard !Task.isCancelled else { return }
            action()
        }
    }

    private func repeatDelete(while touch: Int) {
        holds[touch]?.cancel()
        holds[touch] = Task { [weak self] in
            try? await Task.sleep(for: Self.repeatDelay)
            var step = 0
            while !Task.isCancelled {
                guard let self, self.presses[touch]?.key == .delete else { return }
                self.repeatDelete(step: step)
                self.feedback?.keyDown(.delete)
                step += 1
                try? await Task.sleep(for: step > Self.wordsAfter ? Self.wordInterval : Self.repeatInterval)
            }
        }
    }

    /// A key's text as it shows now: a capital while Shift is on.
    private func shown(_ text: String) -> String {
        shift.isOn ? TypingEngine.capital(text) : text
    }
}
