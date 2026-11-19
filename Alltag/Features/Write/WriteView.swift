//
//  WriteView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import SwiftData
import SwiftUI

/// Learn › Write, all at the learner's level: chats with German friends in
/// everyday German, a formal email as a language course sets it, a topic as
/// long as the level asks for, and a form at A1 and A2. The chat and the
/// writing come in their own issues; for now a tap only answers with a haptic.
struct WriteView: View {
    @Query private var profiles: [UserProfile]
    @State private var taps = 0

    private var level: Level { GrammarProgress.initialLevel(for: profiles.first?.level) }

    var body: some View {
        LearnScreen(title: "Write") {
            LearnSection(title: "Text a friend") {
                WriteGlassList {
                    ForEach(MockWriting.chats(at: level)) { chat in
                        ChatRow(chat: chat, action: tapped)
                    }
                }
            }
            if let task = MockWriting.formalTask(at: level) {
                LearnSection(title: "Formal email", note: Text("Like in a course")) {
                    FormalEmailCard(task: task, onStart: tapped)
                }
            }
            if let topic = MockWriting.topics(at: level).first {
                LearnSection(title: "Write about a topic") {
                    TopicCard(topic: topic, onStart: tapped)
                }
            }
            // A form is only worth practising at the first two levels.
            if level <= .a2 {
                LearnSection(title: "Fill in a form") {
                    FormCard(form: MockWriting.form, onStart: tapped)
                }
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
