//
//  Route.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// Screens pushed onto a tab's navigation stack, or shown as a tab's root.
enum Route: Hashable {
    /// Translate, optionally pre-filled (e.g. from Siri).
    case translate(text: String? = nil)
    /// Translate, opened to ask: the field is ready and the answer is German.
    case howToSay
    /// Look up an article, and the der, die, das trainer.
    case articles
    /// Every word collection, by level and topic.
    case collections
    /// Memory, optionally filtered to one kind (e.g. words from your day)
    /// or searching for a word (e.g. from Siri).
    case memory(kind: MemoryKind? = nil, search: String? = nil)
    case learn
    /// Learn › Read: your reading list, texts from daily life and the letter scan.
    case read
    /// Learn › Write: tasks from daily life and useful phrases.
    case write
    /// Learn › Listen: real audio situations.
    case listen
    case grammar
    case rule(id: String)
    case progress
    case profile
    case settings
    case beyond
    case debrief
    case briefing
    /// The learner's saved sessions, and one of them.
    case sessions
    case session(UUID)
    /// Every situation to train.
    case situations
}

/// Screens presented full-screen over everything else.
enum FullScreenRoute: Hashable, Identifiable {
    case conversation(Scenario.ID)
    /// A situation from the catalogue, by its id.
    case situation(String)
    /// 60 seconds of talking about a random topic.
    case sixtySeconds
    /// A round of der, die, das.
    case articles
    case activity(Activity.ID)
    /// Replaying onboarding from Settings. First-run onboarding is shown by `RootView`.
    case onboarding

    var id: Self { self }
}
