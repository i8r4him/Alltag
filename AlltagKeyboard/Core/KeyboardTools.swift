//
//  KeyboardTools.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 21.11.26.
//

import Foundation
import Observation

/// The part of the typed text a tool works on.
enum ToolText {
    /// The server takes more; a keyboard's tool is for a message, not a letter.
    static let limit = 500

    /// The text before the cursor without the space around it; of a long text, its last sentences.
    static func subject(in context: String) -> String {
        let text = context.trimmingCharacters(in: .whitespacesAndNewlines)
        guard text.count > limit else { return text }
        let tail = text.suffix(limit)
        // Start at a sentence if one starts in there, otherwise at a word.
        let sentence = tail.indices.first { index in
            index > tail.startIndex && ".!?\n".contains(tail[tail.index(before: index)]) && tail[index].isWhitespace
        }
        let start = sentence ?? tail.firstIndex(where: \.isWhitespace) ?? tail.startIndex
        return String(tail[start...]).trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

/// Alltag's tools in the keyboard: Fix and "How do I say …?".
///
/// A tool reads the text before the cursor only when it is tapped, asks the
/// assistant, and shows the answer in place of the top rows. Replace puts the
/// answer where the text was.
@Observable
final class KeyboardTools {
    enum Tool: Equatable {
        case fix
        case say
    }

    /// What a tool says when it has no answer to show.
    enum Notice: Equatable {
        case needsFullAccess
        case nothingTyped(Tool)
        case looksRight
        case dailyLimit
        case failed
        case textChanged
    }

    enum Panel: Equatable {
        case working(Tool)
        case fix(KeyboardFix)
        case answer(KeyboardAnswer, KeyboardRegister)
        case notice(Notice)
    }

    private(set) var panel: Panel?
    /// The reasons of a fix are open.
    private(set) var showsWhy = false
    /// "How do I say …?" is asking again in another register; the old answer stays until the new one is there.
    private(set) var isAskingAgain = false

    @ObservationIgnored var assistant: KeyboardAssistant?
    /// The tools need the network, which iOS gives a keyboard only with Full Access.
    @ObservationIgnored var hasFullAccess = false
    /// The text before the cursor, read when a tool is tapped.
    @ObservationIgnored var text: () -> String = { "" }
    /// Puts new text in place of old text before the cursor; false when the old text isn't there any more.
    @ObservationIgnored var replace: (_ old: String, _ new: String) -> Bool = { _, _ in false }

    /// Each request has a number; an answer to an older one is dropped.
    @ObservationIgnored private var request = 0

    /// The answer covers the numbers row too, not only the tools row.
    var isTall: Bool {
        switch panel {
        case .answer: true
        case .fix: showsWhy
        case .working, .notice, nil: false
        }
    }

    // MARK: - Fix

    func fix() async {
        guard let subject = start(.fix), let assistant else { return }
        let number = request
        do {
            let fix = try await assistant.fix(subject)
            guard number == request else { return }
            panel = fix.isClean ? .notice(.looksRight) : .fix(fix)
        } catch {
            guard number == request else { return }
            panel = .notice(Self.notice(for: error))
        }
    }

    func toggleWhy() {
        guard case .fix = panel else { return }
        showsWhy.toggle()
    }

    // MARK: - How do I say …?

    func say(register: KeyboardRegister = .everyday) async {
        guard let subject = start(.say), let assistant else { return }
        await ask(assistant, subject, register: register)
    }

    /// The same question in the other register.
    func sayAgain(register: KeyboardRegister) async {
        guard case .answer(let answer, let shown) = panel, shown != register, let assistant else { return }
        request += 1
        isAskingAgain = true
        panel = .answer(answer, register)
        await ask(assistant, answer.asked, register: register, keeping: (answer, shown))
    }

    private func ask(_ assistant: KeyboardAssistant, _ subject: String, register: KeyboardRegister,
                     keeping old: (KeyboardAnswer, KeyboardRegister)? = nil) async {
        let number = request
        do {
            let answer = try await assistant.say(subject, register: register)
            guard number == request else { return }
            isAskingAgain = false
            panel = .answer(answer, register)
        } catch {
            guard number == request else { return }
            isAskingAgain = false
            // The answer that was there stays; without one the notice says what happened.
            if let old {
                panel = .answer(old.0, old.1)
            } else {
                panel = .notice(Self.notice(for: error))
            }
        }
    }

    // MARK: - Replace and close

    /// Puts the shown answer in place of the text it was made from.
    func replaceText() {
        let done: Bool
        switch panel {
        case .fix(let fix): done = replace(fix.original, fix.corrected)
        case .answer(let answer, _): done = replace(answer.asked, answer.german)
        case .working, .notice, nil: return
        }
        request += 1
        showsWhy = false
        isAskingAgain = false
        panel = done ? nil : .notice(.textChanged)
    }

    /// Closes what a tool shows and drops an answer still on its way.
    func close() {
        request += 1
        guard panel != nil else { return }
        panel = nil
        showsWhy = false
        isAskingAgain = false
    }

    /// Opens a tool: reads the text and shows that it is working, or says why it can't.
    private func start(_ tool: Tool) -> String? {
        request += 1
        showsWhy = false
        isAskingAgain = false
        guard hasFullAccess, assistant != nil else {
            panel = .notice(.needsFullAccess)
            return nil
        }
        let subject = ToolText.subject(in: text())
        guard !subject.isEmpty else {
            panel = .notice(.nothingTyped(tool))
            return nil
        }
        panel = .working(tool)
        return subject
    }

    private static func notice(for error: Error) -> Notice {
        (error as? RealtimeServiceError) == .dailyLimit ? .dailyLimit : .failed
    }
}
