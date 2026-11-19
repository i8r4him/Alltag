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
/// long as the level asks for, and a form at A1 and A2. Each opens out of its
/// card; what the learner writes is checked, and kept in Your sessions and
/// Fix your mistakes.
struct WriteView: View {
    /// What is open: a chat, or a text to write.
    private enum Opened: Identifiable {
        case chat(WritingChat)
        case text(WritingBrief, source: String)

        var id: String {
            switch self {
            case .chat(let chat): "chat-\(chat.id)"
            case .text(_, let source): source
            }
        }

        var isText: Bool {
            if case .text = self { true } else { false }
        }
    }

    @Query private var profiles: [UserProfile]
    @Query(filter: #Predicate<SessionRecord> { $0.kindRaw == "writing" }) private var written: [SessionRecord]
    @Environment(\.services) private var services
    @Namespace private var transition
    @State private var opened: Opened?
    @State private var taps = 0

    private var level: Level { GrammarProgress.initialLevel(for: profiles.first?.level) }

    var body: some View {
        LearnScreen(title: "Write") {
            if let step = DailyLesson.step(.write, at: level, records: .init(sessions: written)),
               case .chat(let id) = step.target,
               let chat = WritingContent.chats(at: level).first(where: { $0.id == id }) {
                NextForYouCard(step: step) { open(.chat(chat)) }
            }
            LearnSection(title: "Text a friend") {
                WriteGlassList {
                    ForEach(WritingContent.chats(at: level)) { chat in
                        ChatRow(chat: chat, isUnread: !written.contains { $0.title == chat.contact }) {
                            open(.chat(chat))
                        }
                        .matchedTransitionSource(id: "chat-\(chat.id)", in: transition)
                    }
                }
            }
            if let task = WritingContent.formalTask(at: level) {
                LearnSection(title: "Formal email", note: Text("Like in a course")) {
                    FormalEmailCard(task: task) { open(.text(WritingBrief(task, level: level), source: "formal")) }
                        .matchedTransitionSource(id: "formal", in: transition)
                }
            }
            if let topic = WritingContent.topic(at: level) {
                LearnSection(title: "Write about a topic") {
                    TopicCard(topic: topic) { open(.text(WritingBrief(topic, level: level), source: "topic")) }
                        .matchedTransitionSource(id: "topic", in: transition)
                }
            }
            // A form is only worth practising at the first two levels.
            if level <= .a2 {
                LearnSection(title: "Fill in a form") {
                    FormCard(form: WritingContent.form) {
                        open(.text(WritingBrief(WritingContent.form, level: level), source: "form"))
                    }
                    .matchedTransitionSource(id: "form", in: transition)
                }
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
        .sheet(item: $opened) { opened in
            Group {
                switch opened {
                case .chat(let chat):
                    ChatView(chat: chat, level: level, service: services.writing)
                case .text(let brief, _):
                    WritingSessionView(brief: brief, service: services.writing)
                }
            }
            .navigationTransition(.zoom(sourceID: opened.id, in: transition))
            // A text isn't kept until it is checked, so only Close leaves it.
            .interactiveDismissDisabled(opened.isText)
        }
    }

    private func open(_ sheet: Opened) {
        taps += 1
        opened = sheet
    }
}

#Preview {
    NavigationStack { WriteView() }
        .modelContainer(AlltagStore.preview)
}
