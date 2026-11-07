//
//  MemoryKind.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// Where a memory item came from, used by the Memory filters.
enum MemoryKind: String, Codable, CaseIterable, Sendable {
    /// Picked up from everyday activity (reading, camera, podcasts).
    case fromYourDay
    /// Saved by the learner, e.g. from Translate.
    case saved
    /// A mistake the learner made, with the correct form.
    case mistake
}

/// The app or activity a memory item was found in.
enum MemorySource: String, Codable, CaseIterable, Sendable {
    case safari
    case messages
    case conversation
    case translate
    case podcast
    case camera
    case debrief

    /// SF Symbol shown next to the source.
    var systemImage: String {
        switch self {
        case .safari: "safari"
        case .messages: "message"
        case .conversation: "bubble.left.and.bubble.right"
        case .translate: "translate"
        case .podcast: "headphones"
        case .camera: "camera"
        case .debrief: "text.bubble"
        }
    }
}
