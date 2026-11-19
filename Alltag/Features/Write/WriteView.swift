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
    @State private var taps = 0

    private var level: Level { GrammarProgress.initialLevel(for: profiles.first?.level) }

    var body: some View {
        LearnScreen(title: "Write") {
            LearnSection(title: "Text a friend") {
                FriendCard(chat: MockWriting.friend, onReply: tapped)
            }
            if let topic = MockWriting.topics(at: level).first {
                LearnSection(title: "Write about a topic") {
                    TopicCard(topic: topic, onStart: tapped)
                }
            }
            LearnSection(title: "Useful phrases") {
                PhrasesCard()
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
    }

    private func tapped() {
        taps += 1
    }
}

#Preview {
    NavigationStack { WriteView() }
        .modelContainer(AlltagStore.preview)
}
