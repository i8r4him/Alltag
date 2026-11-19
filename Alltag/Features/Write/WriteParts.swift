//
//  WriteParts.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A friend's or a group's round picture: the initial, or the group's symbol,
/// on the theme's two lights.
struct FriendAvatar: View {
    let chat: WritingChat
    var size: CGFloat = 44

    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: [Color.accentFill.opacity(0.95), AppTheme.shared.palette.deep.opacity(0.8)],
                                     startPoint: .topTrailing, endPoint: .bottomLeading))
            if let groupImage = chat.groupImage {
                Image(systemName: groupImage)
                    .font(.system(size: size * 0.38, weight: .semibold))
            } else {
                Text(verbatim: chat.initial)
                    .font(.system(size: size * 0.45, weight: .bold, design: .rounded))
            }
        }
        .foregroundStyle(.white)
        .frame(width: size, height: size)
        .accessibilityHidden(true)
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

/// Rows on one clear glass card, with dividers between them.
struct WriteGlassList<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 0) {
            Group(subviews: content) { rows in
                ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                    if index > 0 { Divider().padding(.leading, 74) }
                    row
                }
            }
        }
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }
}

/// A chat in a list: the picture, a title, the last message and an unread dot.
struct ChatRow: View {
    let chat: WritingChat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                FriendAvatar(chat: chat, size: 46)
                VStack(alignment: .leading, spacing: 3) {
                    Text(verbatim: chat.contact)
                        .font(.headline)
                    Text(verbatim: chat.preview)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .environment(\.locale, Locale(identifier: "de_DE"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                if chat.isUnread {
                    Circle()
                        .fill(Color.accentFill)
                        .frame(width: 10, height: 10)
                        .accessibilityHidden(true)
                } else {
                    LearnChevron()
                }
            }
            .multilineTextAlignment(.leading)
            .padding(.horizontal, Spacing.card)
            .padding(.vertical, 12)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}
