//
//  ConversationModel+TalkMode.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// Hands-free or hold to talk.
///
/// Hands-free (the default), a tap on the orb starts listening, and the live voice
/// answers after a pause. Holding to talk, the learner holds the orb while they speak
/// and the companion answers when they let go, however long they pause to think.
extension ConversationModel {
    /// The learner pressed the orb, holding to talk.
    func orbPressed() {
        guard holdsToTalk, !isFinished else { return }
        if isUsingCloudVoice {
            holdCloudTurn(true)
        } else if phase == .idle {
            orbTapped()
        }
    }

    /// The learner let go of the orb, holding to talk.
    func orbReleased() {
        guard holdsToTalk else { return }
        if isUsingCloudVoice {
            holdCloudTurn(false)
        } else if phase == .listening {
            orbTapped()
        }
    }

    /// Under the orb while holding to talk; `nil` hands-free.
    var holdLabel: LocalizedStringResource? {
        guard holdsToTalk else { return nil }
        return phase == .listening ? "Listening… let go when done" : "Hold to talk"
    }

    /// Holding to talk, the orb can't end the live voice, so a button does.
    var showsFinishButton: Bool { holdsToTalk && isUsingCloudVoice && !isFinished }

    /// What was said so far, for the live voice when it reconnects.
    var transcriptForReconnecting: String {
        messages
            .filter { !$0.line.german.trimmingCharacters(in: .whitespaces).isEmpty }
            .map { "\($0.line.speaker == .learner ? "Learner" : "You"): \($0.line.german)" }
            .joined(separator: "\n")
    }
}
