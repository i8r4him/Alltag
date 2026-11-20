//
//  LearnChatDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Page design 8, "Chat": Alltag texts the learner today's lesson. Each step
/// done shows as their own reply ("Erledigt ✓"), the next one arrives with a
/// button to start it, and the rest wait behind "…" as if Alltag were still
/// typing. The parts of Learn follow as a list of chats.
struct LearnChatDesign: View {
    let content: LearnPageContent

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            if !content.steps.isEmpty {
                LessonChat(content: content)
            }
            VStack(alignment: .leading, spacing: 12) {
                LearnSectionTitle(title: Text(verbatim: "Chats"))
                VStack(spacing: 0) {
                    ForEach(Array(content.overview.doors.enumerated()), id: \.element.id) { index, part in
                        if index > 0 {
                            Divider()
                                .padding(.leading, 76)
                        }
                        Button { content.openPart(part.kind) } label: { chatRow(part) }
                            .buttonStyle(.plain)
                            .accessibilityElement(children: .combine)
                    }
                }
                .padding(.vertical, 4)
                .glassEffect(.regular, in: .rect(cornerRadius: 26, style: .continuous))
            }
        }
    }

    /// A part as a chat in the list: its picture, its name, the next thing as the last message, and what's left as a badge.
    private func chatRow(_ part: LearnOverview.Part) -> some View {
        HStack(spacing: 12) {
            ScenarioArtwork(systemImage: part.kind.systemImage, symbolSize: 22, cornerRadius: 26)
                .frame(width: 48, height: 48)
                .clipShape(.circle)
            VStack(alignment: .leading, spacing: 2) {
                Text(part.kind.title)
                    .font(.headline)
                Group {
                    if let next = part.next {
                        next.title.text
                    } else {
                        PartProgressText(part: part)
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            if part.total > part.done {
                Text(verbatim: "\(part.total - part.done)")
                    .font(.caption.weight(.heavy))
                    .monospacedDigit()
                    .foregroundStyle(.onAccent)
                    .padding(.horizontal, 8)
                    .frame(minWidth: 24, minHeight: 24)
                    .background(.accentFill, in: .capsule)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .contentShape(.rect)
    }
}

/// The conversation with Alltag: a hello, then each step as a message, the
/// learner's ticks as replies, and "…" for what is still to come.
private struct LessonChat: View {
    let content: LearnPageContent

    var body: some View {
        let current = content.current
        let shown = content.steps.filter { $0.isDone || $0.id == current?.id }
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                ScenarioArtwork(systemImage: "sparkles", symbolSize: 18, cornerRadius: 20)
                    .frame(width: 36, height: 36)
                    .clipShape(.circle)
                VStack(alignment: .leading, spacing: 0) {
                    Text(verbatim: "Alltag")
                        .font(.headline)
                    Text(verbatim: current == nil ? "zuletzt online" : "online")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.bottom, 6)
            incoming {
                Text(verbatim: "Hallo! 👋 Heute habe ich \(content.steps.count) Sachen für dich, "
                     + "zusammen \(content.totalMinutes) Minuten.")
            }
            ForEach(shown) { step in
                incoming { stepMessage(step, isCurrent: step.id == current?.id) }
                if step.isDone {
                    outgoing(Text(verbatim: "Erledigt ✓"))
                }
            }
            if current == nil {
                incoming { Text(verbatim: "Super, alles erledigt für heute! 🎉 Bis morgen.") }
            } else if content.steps.count > shown.count {
                TypingBubble()
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    private func stepMessage(_ step: LessonStep, isCurrent: Bool) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(verbatim: step.part.germanName.uppercased())
                .font(.caption2.weight(.heavy))
                .foregroundStyle(.accent)
            step.title.text
                .font(.body.weight(.semibold))
            if isCurrent {
                if let preview = step.preview {
                    Text(verbatim: preview)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                Button { content.open(step.target) } label: {
                    Label {
                        Text(verbatim: "Los geht’s · \(step.minutes) Min.")
                    } icon: {
                        Image(systemName: "play.fill")
                    }
                }
                .buttonStyle(.primaryCompact)
                .padding(.top, 4)
                .matchedTransitionSource(id: step.target, in: content.zoom)
            } else {
                Button { content.open(step.target) } label: {
                    Label {
                        Text(verbatim: "Nochmal")
                    } icon: {
                        Image(systemName: "arrow.counterclockwise")
                    }
                    .font(.footnote.weight(.semibold))
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
                .matchedTransitionSource(id: step.target, in: content.zoom)
            }
        }
    }

    /// A message from Alltag, on the left.
    private func incoming<Message: View>(@ViewBuilder _ message: () -> Message) -> some View {
        message()
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(.controlFill, in: .rect(cornerRadius: 20, style: .continuous))
            .frame(maxWidth: 290, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// The learner's reply, on the right, in the theme colour.
    private func outgoing(_ message: Text) -> some View {
        message
            .font(.body.weight(.semibold))
            .foregroundStyle(.onAccent)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.accentFill, in: .rect(cornerRadius: 20, style: .continuous))
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

/// Three dots in a bubble, as when someone is typing.
private struct TypingBubble: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(.secondary)
                    .frame(width: 8, height: 8)
                    .phaseAnimator([0.3, 1]) { dot, opacity in
                        dot.opacity(reduceMotion ? 0.6 : opacity)
                    } animation: { _ in
                        .easeInOut(duration: 0.6).delay(Double(index) * 0.2)
                    }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(.controlFill, in: .rect(cornerRadius: 20, style: .continuous))
        .accessibilityLabel(Text("More to come"))
    }
}
