//
//  ChatView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Texting with a friend: the bubbles, the friend typing, the field to write in.
/// A coral dot under the learner's message means there is something to fix; tapping it shows how.
struct ChatView: View {
    @State private var model: ChatModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @FocusState private var isTyping: Bool
    @State private var sends = 0

    init(chat: WritingChat, level: Level, service: any WritingService) {
        _model = State(initialValue: ChatModel(chat: chat, level: level, service: service))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(model.messages) { message in
                        ChatBubble(message: message, showsSender: model.chat.groupImage != nil)
                            .id(message.id)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    if model.phase == .waiting {
                        TypingBubble()
                            .transition(.opacity)
                    }
                    if case .failed(let failure) = model.phase {
                        CloudFailureCard(failure: failure, failedTitle: Text("Couldn’t send your message")) {
                            Task { await model.retry(in: modelContext) }
                        }
                    }
                    if model.phase == .ended {
                        ChatEndCard(fixes: model.fixCount, saved: model.savedMistakes) { dismiss() }
                            .padding(.top, 12)
                    }
                }
                .padding(.horizontal, Spacing.screen)
                .padding(.vertical, 12)
                .animation(.snappy, value: model.messages.count)
                .animation(.snappy, value: model.phase)
            }
            .defaultScrollAnchor(.bottom)
            .scrollDismissesKeyboard(.interactively)
            .scrollEdgeEffectStyle(.soft, for: .all)
            .scrollIndicators(.hidden)
            .readableContentMargins()
            .skyBackground()
            .fontDesign(.rounded)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbar }
            .safeAreaInset(edge: .bottom) {
                if model.phase != .ended { composer }
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: sends)
    }

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Close", systemImage: "xmark") { dismiss() }
        }
        ToolbarItem(placement: .principal) {
            HStack(spacing: 8) {
                FriendAvatar(chat: model.chat, size: 30)
                Text(verbatim: model.chat.contact)
                    .font(.headline)
            }
            .accessibilityElement(children: .combine)
        }
        ToolbarItem(placement: .topBarTrailing) {
            Text(verbatim: "\(min(model.learnerCount, ChatModel.limit))/\(ChatModel.limit)")
                .font(.subheadline.weight(.semibold))
                .monospacedDigit()
                .foregroundStyle(.secondary)
                .accessibilityLabel(Text("\(model.learnerCount) of \(ChatModel.limit) messages"))
        }
    }

    private var composer: some View {
        GlassEffectContainer(spacing: 10) {
            HStack(alignment: .bottom, spacing: 10) {
                TextField("Message", text: $model.draft, axis: .vertical)
                    .lineLimit(1...4)
                    .font(.body)
                    .focused($isTyping)
                    // The learner's own mistakes are the point: no autocorrect fixing them first.
                    .autocorrectionDisabled()
                    .environment(\.locale, Locale(identifier: "de"))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 22, style: .continuous))
                Button(action: send) {
                    Image(systemName: "arrow.up")
                        .font(.headline)
                        .frame(width: 30, height: 30)
                }
                .buttonStyle(.glassProminent)
                .buttonBorderShape(.circle)
                .disabled(!model.canSend)
                .accessibilityLabel(Text("Send"))
            }
        }
        .padding(.horizontal, Spacing.screen)
        .padding(.bottom, 8)
    }

    private func send() {
        sends += 1
        Task { await model.send(in: modelContext) }
    }
}

/// One message: the friend's on glass on the left (tap for the English), the learner's
/// in the theme colour on the right, with the check under it.
private struct ChatBubble: View {
    let message: ChatMessage
    let showsSender: Bool
    @State private var isOpen = false

    var body: some View {
        VStack(alignment: message.isLearner ? .trailing : .leading, spacing: 4) {
            if showsSender, let from = message.from {
                Text(verbatim: from)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.accent)
                    .padding(.horizontal, 12)
            }
            Button { if canOpen { isOpen.toggle() } } label: { bubble }
                .buttonStyle(.plain)
            if isOpen { details.transition(.opacity.combined(with: .move(edge: .top))) }
        }
        .frame(maxWidth: .infinity, alignment: message.isLearner ? .trailing : .leading)
        .padding(message.isLearner ? .leading : .trailing, 48)
        .animation(.snappy, value: isOpen)
        .animation(.snappy, value: message.feedback)
        .sensoryFeedback(.selection, trigger: isOpen)
    }

    private var canOpen: Bool {
        message.isLearner ? message.feedback.map { $0.kind != .good } ?? false : !message.english.isEmpty
    }

    private var bubble: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(verbatim: message.text)
                .font(.body)
                .environment(\.locale, Locale(identifier: "de"))
                .multilineTextAlignment(.leading)
                .foregroundStyle(message.isLearner ? Color.onAccent : Color.primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background {
                    if message.isLearner {
                        RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color.accentFill)
                    }
                }
                .glassEffect(message.isLearner ? .identity : .regular, in: .rect(cornerRadius: 20, style: .continuous))
            if message.isLearner, let feedback = message.feedback {
                CheckMark(kind: feedback.kind)
            }
        }
        .contentShape(.rect)
    }

    @ViewBuilder private var details: some View {
        if message.isLearner, let feedback = message.feedback {
            VStack(alignment: .leading, spacing: 8) {
                if let correction = feedback.correction {
                    changedWords(said: message.text, correction: correction)
                        .font(.body)
                        .environment(\.locale, Locale(identifier: "de"))
                }
                FeedbackCard(feedback: feedback)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Spacing.card)
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
        } else {
            Text(verbatim: message.english)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 12)
        }
    }
}

/// Under the learner's message: a coral dot for a mistake, a tip, or a quiet tick.
private struct CheckMark: View {
    let kind: Feedback.Kind

    var body: some View {
        switch kind {
        case .fix:
            Label("Fix", systemImage: "circle.fill")
                .foregroundStyle(Color.mistake)
                .font(.caption.weight(.semibold))
        case .note:
            Label("Tip", systemImage: "lightbulb.fill")
                .foregroundStyle(.secondary)
                .font(.caption.weight(.semibold))
        case .good:
            Image(systemName: "checkmark")
                .font(.caption.weight(.bold))
                .foregroundStyle(Color.success)
                .accessibilityLabel(Text("Good"))
        }
    }
}

/// Three dots while the friend writes.
private struct TypingBubble: View {
    @Environment(\.reducesMotion) private var reduceMotion

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .frame(width: 7, height: 7)
                    .phaseAnimator(reduceMotion ? [1.0] : [0.3, 1.0]) { dot, opacity in
                        dot.opacity(opacity)
                    } animation: { _ in
                        .easeInOut(duration: 0.5).delay(Double(index) * 0.15)
                    }
            }
        }
        .foregroundStyle(.secondary)
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .glassEffect(.regular, in: .rect(cornerRadius: 20, style: .continuous))
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityLabel(Text("Typing …"))
    }
}

/// The friend said goodbye: how it went, and Done.
private struct ChatEndCard: View {
    let fixes: Int
    let saved: Int
    let onDone: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Chat finished", systemImage: "checkmark.seal.fill")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.accent)
            Group {
                if fixes == 0 {
                    Text("No mistakes. You text like a German!")
                } else if saved > 0 {
                    Text("^[\(saved) fix](inflect: true) saved to Fix your mistakes.")
                } else {
                    Text("^[\(fixes) thing](inflect: true) to fix. Tap the coral dots to see them.")
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            GlassEffectContainer {
                Button("Done", systemImage: "checkmark", action: onDone)
                    .buttonStyle(.primary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

#Preview {
    ChatView(chat: WritingContent.chats(at: .b1)[0], level: .b1, service: MockWritingService())
        .modelContainer(AlltagStore.preview)
}
