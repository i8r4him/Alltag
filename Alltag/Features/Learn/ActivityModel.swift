//
//  ActivityModel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Observation

/// A multiple-choice activity in progress: one pick per question, then an
/// explanation and Continue; a summary at the end.
@Observable
final class ActivityModel {
    let activity: Activity
    private(set) var index = 0
    /// The option picked for the current question, if any.
    private(set) var picked: Int?
    private(set) var score = 0
    private(set) var isDone = false
    private(set) var isPlaying = false

    private let voice: any VoiceService

    init(activity: Activity, services: AppServices) {
        self.activity = activity
        voice = services.voice
    }

    var question: Activity.Question { activity.questions[index] }
    var hasPicked: Bool { picked != nil }
    var total: Int { activity.questions.count }

    /// A progress segment is filled for answered questions.
    func isSegmentFilled(_ segment: Int) -> Bool {
        isDone || segment < index || (segment == index && hasPicked)
    }

    /// How an option looks after picking.
    enum OptionState: Equatable {
        case open
        case right
        case wrong
        case dimmed
    }

    func state(ofOption option: Int) -> OptionState {
        guard let picked else { return .open }
        if option == question.correctIndex { return .right }
        if option == picked { return .wrong }
        return .dimmed
    }

    /// Picks an answer. Only the first pick per question counts.
    /// Returns whether it was right, or `nil` if a pick was already made.
    @discardableResult
    func pick(_ option: Int) -> Bool? {
        guard picked == nil, question.options.indices.contains(option) else { return nil }
        picked = option
        let isRight = option == question.correctIndex
        if isRight { score += 1 }
        return isRight
    }

    /// Moves to the next question, or to the summary after the last one.
    func next() {
        guard hasPicked else { return }
        stopAudio()
        if index + 1 < total {
            index += 1
            picked = nil
        } else {
            isDone = true
        }
    }

    /// "2 of 2. Nicely done."
    var doneTitle: LocalizedStringResource { "\(score) of \(total). Nicely done." }

    // MARK: Audio (listening activities)

    /// Plays the activity's audio, or stops it if it's playing.
    func toggleAudio() async {
        guard let audio = activity.audio else { return }
        if isPlaying {
            stopAudio()
            return
        }
        isPlaying = true
        await voice.speak(audio, rate: .normal)
        isPlaying = false
    }

    func stopAudio() {
        guard isPlaying else { return }
        voice.stop()
        isPlaying = false
    }
}
