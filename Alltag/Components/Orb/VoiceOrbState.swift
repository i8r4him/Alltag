//
//  VoiceOrbState.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 09.11.26.
//

/// The state of a conversation turn, shown by the companion's motion.
enum VoiceOrbState: Equatable, CaseIterable {
    /// Waiting for the learner: slow and calm.
    case idle
    /// Hearing the learner.
    case listening
    /// Preparing a reply: the silk swirls faster.
    case thinking
    /// The companion is talking.
    case speaking
}
