//
//  WriteView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import SwiftData
import SwiftUI

/// Learn › Write: text a German friend in everyday German; formal writing
/// (answer an email, a letter as a language course sets it, a form, a topic at
/// the learner's level, as long as the level asks for); and useful phrases in
/// both tones. The chat and the writing come in their own issues;
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
            LearnSection(title: "Reply to an email") {
                EmailCard(email: MockWriting.email, onReply: tapped)
            }
            LearnSection(title: "Write a letter", note: Text("Like in a course")) {
                LetterTaskCard(task: MockWriting.letter, level: level, onStart: tapped)
            }
            LearnSection(title: "Fill in a form") {
                FormCard(form: MockWriting.form, onStart: tapped)
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
