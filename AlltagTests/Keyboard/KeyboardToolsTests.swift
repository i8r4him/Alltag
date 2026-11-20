//
//  KeyboardToolsTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 21.11.26.
//

import CoreGraphics
import Foundation
import Testing
@testable import Alltag

/// Answers at once with what the test gave it.
@MainActor
final class FixedAssistant: KeyboardAssistant {
    var corrected: String?
    var reasons: [String] = []
    var german: [KeyboardRegister: String] = [.everyday: "Kann ich morgen kommen?", .formal: "Könnte ich morgen kommen?"]
    var error: Error?
    private(set) var asked: [String] = []

    func fix(_ text: String) async throws -> KeyboardFix {
        asked.append(text)
        if let error { throw error }
        return KeyboardFix(original: text, corrected: corrected ?? text, reasons: reasons)
    }

    func say(_ text: String, register: KeyboardRegister) async throws -> KeyboardAnswer {
        asked.append(text)
        if let error { throw error }
        return KeyboardAnswer(asked: text, german: german[register] ?? "", note: "")
    }
}

/// Answers a fix only when the test lets it, to try what happens meanwhile.
@MainActor
final class HeldAssistant: KeyboardAssistant {
    private(set) var waiting: CheckedContinuation<KeyboardFix, Error>?

    func fix(_ text: String) async throws -> KeyboardFix {
        try await withCheckedThrowingContinuation { waiting = $0 }
    }

    func say(_ text: String, register: KeyboardRegister) async throws -> KeyboardAnswer {
        KeyboardAnswer(asked: text, german: text)
    }

    func answer(_ fix: KeyboardFix) {
        waiting?.resume(returning: fix)
        waiting = nil
    }
}

@Suite("Keyboard tools")
@MainActor
struct KeyboardToolsTests {
    let document = FakeDocument()
    let model = KeyboardModel()
    let assistant = FixedAssistant()

    init() {
        model.document = document
        model.tools.assistant = assistant
        model.tools.hasFullAccess = true
        model.documentChanged(KeyboardTraits(capitalisation: .none))
    }

    @Test("A tool works on the typed text without the space around it; of a long text, its last sentences")
    func subject() {
        #expect(ToolText.subject(in: "  Ich habe Hunger. \n") == "Ich habe Hunger.")
        let long = String(repeating: "Das ist ein Satz. ", count: 40) + "Und der letzte Satz"
        let subject = ToolText.subject(in: long)
        #expect(subject.count <= ToolText.limit)
        #expect(subject.hasPrefix("Das ist ein Satz."))
        #expect(subject.hasSuffix("Und der letzte Satz"))
        let oneWord = String(repeating: "a", count: 700)
        #expect(ToolText.subject(in: oneWord).count == ToolText.limit)
    }

    @Test("Only the words that changed are marked in a fix")
    func marks() {
        let fix = KeyboardFix(original: "Ich habe gestern ins Kino gegangen", corrected: "Ich bin gestern ins Kino gegangen.")
        let words = FixMarks.words(of: fix)
        #expect(words.map(\.text) == ["Ich", "bin", "gestern", "ins", "Kino", "gegangen."])
        #expect(words.filter(\.isChanged).map(\.text) == ["bin", "gegangen."])
        // A change late in the text is shown from the word before it.
        let late = KeyboardFix(original: "eins zwei drei vier fünf sex", corrected: "eins zwei drei vier fünf sechs")
        let excerpt = FixMarks.excerpt(of: late)
        #expect(excerpt.startsLater)
        #expect(excerpt.words.map(\.text) == ["fünf", "sechs"])
    }

    @Test("Fix shows the corrected text, and Replace puts it in place of what was typed")
    func fix() async {
        document.before = "Hallo Lena! Ich habe gestern ins Kino gegangen "
        assistant.corrected = "Hallo Lena! Ich bin gestern ins Kino gegangen."
        assistant.reasons = ["Perfect with sein: „gehen“ takes „sein“."]
        await model.tools.fix()
        #expect(assistant.asked == ["Hallo Lena! Ich habe gestern ins Kino gegangen"])
        guard case .fix(let fix) = model.tools.panel else {
            Issue.record("No fix is shown")
            return
        }
        #expect(fix.corrected == "Hallo Lena! Ich bin gestern ins Kino gegangen.")
        #expect(!model.tools.isTall)
        model.tools.toggleWhy()
        #expect(model.tools.isTall)

        model.tools.replaceText()
        #expect(document.before == "Hallo Lena! Ich bin gestern ins Kino gegangen. ")
        #expect(model.tools.panel == nil)
        #expect(!model.tools.isTall)
    }

    @Test("Fix says so when nothing is wrong, nothing is typed, or it may not ask")
    func notices() async {
        await model.tools.fix()
        #expect(model.tools.panel == .notice(.nothingTyped(.fix)))
        await model.tools.say()
        #expect(model.tools.panel == .notice(.nothingTyped(.say)))

        document.before = "Ich bin müde."
        await model.tools.fix()
        #expect(model.tools.panel == .notice(.looksRight))

        assistant.error = RealtimeServiceError.dailyLimit
        await model.tools.fix()
        #expect(model.tools.panel == .notice(.dailyLimit))
        assistant.error = RealtimeServiceError.unavailable
        await model.tools.fix()
        #expect(model.tools.panel == .notice(.failed))

        model.tools.hasFullAccess = false
        await model.tools.fix()
        #expect(model.tools.panel == .notice(.needsFullAccess))
        #expect(assistant.asked.count == 3)
    }

    @Test("How do I say answers in everyday German, asks again for formal, and Replace swaps the text")
    func say() async {
        document.before = "Can I come tomorrow?"
        await model.tools.say()
        #expect(model.tools.panel == .answer(KeyboardAnswer(asked: "Can I come tomorrow?", german: "Kann ich morgen kommen?"), .everyday))
        #expect(model.tools.isTall)

        await model.tools.sayAgain(register: .formal)
        #expect(model.tools.panel == .answer(KeyboardAnswer(asked: "Can I come tomorrow?", german: "Könnte ich morgen kommen?"), .formal))
        #expect(!model.tools.isAskingAgain)

        // When asking again fails, the answer that was there stays.
        assistant.error = RealtimeServiceError.unavailable
        await model.tools.sayAgain(register: .everyday)
        #expect(model.tools.panel == .answer(KeyboardAnswer(asked: "Can I come tomorrow?", german: "Könnte ich morgen kommen?"), .formal))

        model.tools.replaceText()
        #expect(document.before == "Könnte ich morgen kommen?")
        #expect(model.tools.panel == nil)
    }

    @Test("Replace leaves the text alone when it is no longer what the tool read")
    func textChanged() async {
        document.before = "Ich habe gegangen"
        assistant.corrected = "Ich bin gegangen"
        await model.tools.fix()
        document.before = "Etwas ganz anderes"
        model.tools.replaceText()
        #expect(document.before == "Etwas ganz anderes")
        #expect(model.tools.panel == .notice(.textChanged))
    }

    @Test("Typing closes a tool, and an answer that arrives after that is dropped")
    func typingCloses() async {
        let held = HeldAssistant()
        model.tools.assistant = held
        document.before = "Ich habe gegangen"
        let asking = Task { await model.tools.fix() }
        while held.waiting == nil { await Task.yield() }
        #expect(model.tools.panel == .working(.fix))

        model.activate(.character("x"))
        #expect(model.tools.panel == nil)
        held.answer(KeyboardFix(original: "Ich habe gegangen", corrected: "Ich bin gegangen"))
        await asking.value
        #expect(model.tools.panel == nil)
        #expect(document.before == "Ich habe gegangenx")
    }

    @Test("The engine replaces text before the cursor and keeps the space after it")
    func engineReplace() {
        var engine = TypingEngine()
        let field = FakeDocument("Hi. Wie gehts \n")
        #expect(engine.replace("Wie gehts", with: "Wie geht's?", in: field))
        #expect(field.before == "Hi. Wie geht's? \n")
        #expect(engine.context == "Hi. Wie geht's? \n")
        #expect(!engine.replace("nicht da", with: "x", in: field))
        #expect(field.before == "Hi. Wie geht's? \n")
    }

    @Test("The server's answers become a fix and an answer")
    func server() async throws {
        var sent: [(String, [String: String])] = []
        let check = """
        {"sentences":[{"original":"Ich habe gegangen.","kind":"fix","title":"Perfect with sein","note":"„gehen“ takes „sein“.",
        "correction":"Ich bin gegangen.","english":"I went."},{"original":"Gut.","kind":"good","title":"Fine","note":"",
        "correction":"","english":"Good."}],"corrected":"Ich bin gegangen. Gut.","points":[],"summary":"Good."}
        """
        let translation = """
        {"german":"Kann ich morgen kommen?","other":"Can I come tomorrow?","source_is_german":false,"note":"Casual.",
        "words":[],"tones":[],"examples":[]}
        """
        let server = ServerKeyboardAssistant(send: { function, body in
            sent.append((function, body))
            return Data((function == "write" ? check : translation).utf8)
        })
        let fix = try await server.fix("Ich habe gegangen. Gut.")
        #expect(fix == KeyboardFix(original: "Ich habe gegangen. Gut.", corrected: "Ich bin gegangen. Gut.",
                                   reasons: ["Perfect with sein: „gehen“ takes „sein“."]))
        let answer = try await server.say("Can I come tomorrow?", register: .formal)
        #expect(answer == KeyboardAnswer(asked: "Can I come tomorrow?", german: "Kann ich morgen kommen?", note: "Casual."))
        #expect(sent.map(\.0) == ["write", "translate"])
        #expect(sent[0].1 == ["action": "check", "text": "Ich habe gegangen. Gut."])
        #expect(sent[1].1["register"] == "formal")
    }

    @Test("With the numbers row hidden, every other key stays where it was")
    func hiddenNumbers() {
        let rows = KeyboardLayout.allRows(for: .letters, showsGlobe: false)
        let size = CGSize(width: 440, height: 271)
        let full = KeyboardGeometry(rows: rows, size: size)
        let hidden = KeyboardGeometry(rows: rows, size: size, hidesNumbers: true)
        #expect(hidden.frames == full.frames.filter { $0.row > 0 })
        #expect(hidden.frame(of: .character("1")) == nil)
        let bottom = KeyboardGeometry.numbersBottom(rowCount: rows.count, height: size.height, metrics: .portrait)
        #expect(abs(bottom - (full.frame(of: .character("1"))?.frame.maxY ?? 0)) < 0.01)
    }
}
