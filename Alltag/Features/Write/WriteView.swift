//
//  WriteView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import SwiftData
import SwiftUI

/// Learn › Write: text a German friend in everyday German, write about a topic
/// at the learner's level (formal, as long as the level asks for), and useful
/// phrases in both tones. The chat and the writing come in their own issues;
/// for now a tap only answers with a haptic.
struct WriteView: View {
    @Query private var profiles: [UserProfile]
    @AppStorage("writeDesign") private var design = 0
    @State private var taps = 0

    private var level: Level { GrammarProgress.initialLevel(for: profiles.first?.level) }

    var body: some View {
        LearnScreen(title: "Write") {
            switch WriteDesign(rawValue: design) ?? .cards {
            case .cards:
                WriteCardsDesign(level: level, onOpen: tapped)
            case .tones:
                WriteTonesDesign(level: level, onOpen: tapped)
            case .messages:
                WriteMessagesDesign(level: level, onOpen: tapped)
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
        .sensoryFeedback(.selection, trigger: design)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                WriteDesignSwitcher(design: $design)
            }
        }
    }

    private func tapped() {
        taps += 1
    }
}

#Preview {
    NavigationStack { WriteView() }
        .modelContainer(AlltagStore.preview)
}
