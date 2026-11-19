//
//  WriteParts.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A friend's round picture: the initial on the theme's two lights.
struct FriendAvatar: View {
    let chat: WritingChat
    var size: CGFloat = 44

    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: [Color.accentFill.opacity(0.95), AppTheme.shared.palette.deep.opacity(0.8)],
                                     startPoint: .topTrailing, endPoint: .bottomLeading))
            Text(verbatim: chat.initial)
                .font(.system(size: size * 0.45, weight: .bold, design: .rounded))
        }
        .foregroundStyle(.white)
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}

/// One message from the friend, on the left like in a chat.
struct FriendBubble: View {
    let text: String

    var body: some View {
        Text(verbatim: text)
            .font(.body)
            .environment(\.locale, Locale(identifier: "de_DE"))
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(.fill.tertiary, in: .rect(cornerRadius: 22, style: .continuous))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// The friend, their first messages and the button to answer.
struct FriendCard: View {
    let chat: WritingChat
    let onReply: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                FriendAvatar(chat: chat)
                VStack(alignment: .leading, spacing: 2) {
                    Text(verbatim: chat.contact)
                        .font(.headline)
                    Text(chat.title)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .accessibilityElement(children: .combine)
            }
            VStack(alignment: .leading, spacing: 6) {
                ForEach(MockWriting.friendMessages, id: \.self) { FriendBubble(text: $0) }
            }
            GlassEffectContainer {
                Button(action: onReply) {
                    Label { Text("Reply to \(chat.contact)") } icon: { Image(systemName: "bubble.left.and.bubble.right.fill") }
                }
                .buttonStyle(.primary)
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// "B1 · about 80 words".
struct TopicLengthText: View {
    let level: Level

    var body: some View {
        Self.text(for: level)
    }

    static func text(for level: Level) -> Text {
        Text("\(level.title) · about \(WritingLength.words(for: level)) words")
    }
}

/// The topic to write about: its length for the level, its title and the big button.
struct TopicCard: View {
    let topic: WritingTopic
    let onStart: () -> Void
    @ScaledMetric(relativeTo: .title3) private var artworkSize: CGFloat = 88

    var body: some View {
        VStack(spacing: 18) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    TopicLengthText(level: topic.level)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.accent)
                    Text(verbatim: topic.title)
                        .font(.title3.weight(.semibold))
                        .environment(\.locale, Locale(identifier: "de_DE"))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                ScenarioArtwork(systemImage: topic.systemImage)
                    .frame(width: artworkSize, height: artworkSize)
            }
            GlassEffectContainer {
                Button(action: onStart) {
                    Label("Start writing", systemImage: "pencil")
                }
                .buttonStyle(.primary)
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// Openings, requests, thanks and closings in one tone.
struct PhrasesList: View {
    let tone: WritingTone

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(MockWriting.phrases(tone)) { phrase in
                VStack(alignment: .leading, spacing: 3) {
                    Text(phrase.role)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.accent)
                    Text(verbatim: phrase.german)
                        .font(.title3.weight(.medium))
                        .environment(\.locale, Locale(identifier: "de_DE"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
            }
        }
    }
}

/// The phrases with their own du / Sie switch. The tone lives here, so
/// switching redraws only this card.
struct PhrasesCard: View {
    @State private var tone = WritingTone.everyday

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ToneSwitch(tone: $tone)
            PhrasesList(tone: tone)
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .animation(.snappy, value: tone)
        .sensoryFeedback(.selection, trigger: tone)
    }
}

/// "Informal · du" or "Formal · Sie".
struct ToneSwitch: View {
    @Binding var tone: WritingTone

    var body: some View {
        Picker("Register", selection: $tone) {
            Text("Informal · du").tag(WritingTone.everyday)
            Text("Formal · Sie").tag(WritingTone.formal)
        }
        .pickerStyle(.segmented)
    }
}
