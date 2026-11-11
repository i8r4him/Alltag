//
//  TranscriptView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The conversation so far, kept at the newest line, plus the words being heard.
struct TranscriptView: View {
    let messages: [ConversationModel.Message]
    /// Words heard so far while listening; empty otherwise.
    let heardText: String

    @State private var englishShown: Set<UUID> = []

    var body: some View {
        // Anchored to the bottom, so streamed lines stay in view without scrolling on every change.
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
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 24)
            .animation(.easeOut(duration: 0.4), value: messages.map(\.id))
        }
        .defaultScrollAnchor(.bottom, for: .initialOffset)
        .defaultScrollAnchor(.bottom, for: .sizeChanges)
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

/// The learner's words in a bubble tinted in the theme colour; shared by
/// finished lines and the words being heard.
private struct LearnerText: View {
    let text: String
    var isHearing = false

    var body: some View {
        words
            .padding(.horizontal, 16)
            .padding(.vertical, 11)
            .background {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(.accentFill.opacity(isHearing ? 0.12 : 0.22))
                    .overlay {
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .strokeBorder(.accent.opacity(0.35), lineWidth: 1)
                    }
            }
    }

    private var words: some View {
        Text(verbatim: text)
            .textRole(.userLine)
            .fontWeight(.medium)
            .foregroundStyle(isHearing ? .secondary : .primary)
            .multilineTextAlignment(.trailing)
    }
}

/// A learner line, right-aligned, with its feedback.
private struct LearnerLine: View {
    let line: ConversationLine

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            LearnerText(text: line.german)
            if let feedback = line.feedback {
                FeedbackCard(feedback: feedback)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.leading, 48)
        .transition(.opacity.combined(with: .offset(y: 8)))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("You: \(line.german)"))
    }
}

/// The words heard so far, in a fainter bubble, with a blinking caret.
private struct HeardText: View {
    let text: String
    @Environment(\.reducesMotion) private var reduceMotion

    var body: some View {
        TimelineView(.periodic(from: .now, by: 0.5)) { context in
            let caretVisible = reduceMotion || Int(context.date.timeIntervalSinceReferenceDate * 2) % 2 == 0
            HStack(alignment: .center, spacing: 6) {
                RoundedRectangle(cornerRadius: 1)
                    .fill(.accentFill)
                    .frame(width: 2, height: 18)
                    .opacity(caretVisible ? 1 : 0)
                    .accessibilityHidden(true)
                LearnerText(text: text, isHearing: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.leading, 48)
    }
}
