//
//  TranscriptView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The conversation so far, scrolled to the newest line, plus the words being heard.
struct TranscriptView: View {
    let messages: [ConversationModel.Message]
    /// Words heard so far while listening; empty otherwise.
    let heardText: String

    @State private var englishShown: Set<UUID> = []
    private static let bottomID = "bottom"

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 26) {
                    ForEach(messages.filter { !$0.line.german.isEmpty }) { message in
                        switch message.line.speaker {
                        case .companion:
                            CompanionLine(line: message.line, showsEnglish: englishShown.contains(message.id)) {
                                englishShown.formSymmetricDifference([message.id])
                            }
                        case .learner:
                            LearnerLine(line: message.line)
                        }
                    }
                    if !heardText.isEmpty {
                        HeardText(text: heardText)
                    }
                    Color.clear.frame(height: 1).id(Self.bottomID)
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 24)
                .animation(.easeOut(duration: 0.4), value: messages.map(\.id))
            }
            .onChange(of: messages.last) { scrollToBottom(proxy) }
            .onChange(of: heardText) { scrollToBottom(proxy) }
        }
    }

    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        withAnimation(.easeOut(duration: 0.3)) { proxy.scrollTo(Self.bottomID, anchor: .bottom) }
    }
}

/// A companion line: German in 23pt; tap to show or hide the English.
private struct CompanionLine: View {
    let line: ConversationLine
    let showsEnglish: Bool
    let toggle: () -> Void

    var body: some View {
        Group {
            if line.english.isEmpty {
                content
            } else {
                Button(action: toggle) { content.contentShape(.rect) }
                    .buttonStyle(.plain)
                    .accessibilityHint(showsEnglish ? Text("Hides the English") : Text("Shows the English"))
            }
        }
        .transition(.opacity.combined(with: .offset(y: 8)))
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Companion")
                .textRole(.caption)
                .textCase(.uppercase)
                .tracking(0.8)
                .foregroundStyle(.tertiary)
            Text(verbatim: line.german)
                .textRole(.aiLine)
                .foregroundStyle(.primary)
            if !line.english.isEmpty {
                if showsEnglish {
                    Text(verbatim: line.english)
                        .textRole(.bodySmall)
                        .foregroundStyle(.secondary)
                        .transition(.opacity)
                } else {
                    Text("Tap to see English")
                        .textRole(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// A learner line, right-aligned, with its feedback.
private struct LearnerLine: View {
    let line: ConversationLine

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Text("You")
                .textRole(.caption)
                .textCase(.uppercase)
                .tracking(0.8)
                .foregroundStyle(.tertiary)
            Text(verbatim: line.german)
                .textRole(.userLine)
                .foregroundStyle(.primary.opacity(0.86))
                .multilineTextAlignment(.trailing)
            if let feedback = line.feedback {
                FeedbackCard(feedback: feedback)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.leading, 32)
        .transition(.opacity.combined(with: .offset(y: 8)))
    }
}

/// The words heard so far, with a blinking amber caret.
private struct HeardText: View {
    let text: String
    @Environment(\.reducesMotion) private var reduceMotion

    var body: some View {
        TimelineView(.periodic(from: .now, by: 0.5)) { context in
            let caretVisible = reduceMotion || Int(context.date.timeIntervalSinceReferenceDate * 2) % 2 == 0
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(verbatim: text)
                    .textRole(.userLine)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
                RoundedRectangle(cornerRadius: 1)
                    .fill(.accentFill)
                    .frame(width: 2, height: 18)
                    .opacity(caretVisible ? 1 : 0)
                    .accessibilityHidden(true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.leading, 32)
    }
}
