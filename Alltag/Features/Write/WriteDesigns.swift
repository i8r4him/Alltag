//
//  WriteDesigns.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

// Temporary: three ways to lay out Write's three parts (Text a friend, Write
// about a topic, Useful phrases), behind a "‹ n / 3 ›" switcher in the
// toolbar. The maintainer picks one; the others and the switcher go before
// the PR is merged.

/// The designs to choose from.
enum WriteDesign: Int, CaseIterable {
    /// A big glass card for each part, one under the other.
    case cards
    /// One du / Sie switch on top: the friend's chats or the formal topics.
    case tones
    /// Like a messages app: the chats as a list, the topic as a sheet of paper,
    /// the phrases as cards to swipe through.
    case messages

    var name: String {
        switch self {
        case .cards: "Cards"
        case .tones: "Two tones"
        case .messages: "Messages"
        }
    }
}

/// "‹ 1 / 3 ›" with the design's name under it.
struct WriteDesignSwitcher: View {
    @Binding var design: Int

    private var count: Int { WriteDesign.allCases.count }

    var body: some View {
        HStack(spacing: 4) {
            Button { design = (design + count - 1) % count } label: {
                Image(systemName: "chevron.left")
            }
            .accessibilityLabel(Text(verbatim: "Previous design"))
            VStack(spacing: 0) {
                Text(verbatim: "\(design + 1) / \(count)")
                    .font(.subheadline.weight(.semibold).monospacedDigit())
                Text(verbatim: (WriteDesign(rawValue: design) ?? .cards).name)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(minWidth: 64)
            Button { design = (design + 1) % count } label: {
                Image(systemName: "chevron.right")
            }
            .accessibilityLabel(Text(verbatim: "Next design"))
        }
    }
}

/// Design 1: the friend's card, the topic's card, the phrases' card.
struct WriteCardsDesign: View {
    let level: Level
    let onOpen: () -> Void

    var body: some View {
        Group {
            LearnSection(title: "Text a friend") {
                FriendCard(chat: MockWriting.chats[0], onReply: onOpen)
            }
            if let topic = MockWriting.topics(at: level).first {
                LearnSection(title: "Write about a topic") {
                    TopicCard(topic: topic, onStart: onOpen)
                }
            }
            LearnSection(title: "Useful phrases") {
                PhrasesCard()
            }
        }
    }
}

/// Design 2: one switch decides everything below it. Everyday shows the
/// friend and more chats; formal shows the topic and more topics. The phrases
/// follow the same switch.
struct WriteTonesDesign: View {
    let level: Level
    let onOpen: () -> Void
    @State private var tone = WritingTone.everyday

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            ToneSwitch(tone: $tone)
            if tone == .everyday {
                LearnSection(title: "Text a friend") {
                    FriendCard(chat: MockWriting.chats[0], onReply: onOpen)
                }
                LearnSection(title: "More chats") {
                    WriteGlassList {
                        ForEach(MockWriting.chats.dropFirst()) { chat in
                            ChatRow(chat: chat, showsTopic: true, action: onOpen)
                        }
                    }
                }
            } else {
                let topics = MockWriting.topics(at: level)
                if let topic = topics.first {
                    LearnSection(title: "Write about a topic") {
                        TopicCard(topic: topic, onStart: onOpen)
                    }
                }
                LearnSection(title: "More topics") {
                    WriteGlassList {
                        ForEach(topics.dropFirst()) { topic in
                            LearnRow(systemImage: topic.systemImage, title: Text(verbatim: topic.title),
                                     detail: TopicLengthText.text(for: topic.level), action: onOpen)
                        }
                    }
                }
            }
            LearnSection(title: "Useful phrases") {
                PhrasesList(tone: tone)
                    .padding(Spacing.cardLarge)
                    .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
            }
        }
        .animation(.snappy, value: tone)
        .sensoryFeedback(.selection, trigger: tone)
    }
}

/// Design 3: the chats as a list like a messages app, the topic on a sheet of
/// paper, and each phrase with its du and Sie version on a card to swipe.
struct WriteMessagesDesign: View {
    let level: Level
    let onOpen: () -> Void

    var body: some View {
        Group {
            LearnSection(title: "Text a friend") {
                WriteGlassList {
                    ForEach(MockWriting.chats) { chat in
                        ChatRow(chat: chat, action: onOpen)
                    }
                }
            }
            if let topic = MockWriting.topics(at: level).first {
                LearnSection(title: "Write about a topic") {
                    TopicPaperCard(topic: topic, onStart: onOpen)
                }
            }
            LearnSection(title: "Useful phrases") {
                PhrasePairsRow()
            }
        }
    }
}

/// The topic as a sheet of paper: its length, its title, empty lines to write
/// on and a word count. The whole card starts writing.
private struct TopicPaperCard: View {
    let topic: WritingTopic
    let onStart: () -> Void

    var body: some View {
        Button(action: onStart) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    TopicLengthText(level: topic.level)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.accent)
                    Spacer()
                    Image(systemName: "square.and.pencil")
                        .font(.title3)
                        .foregroundStyle(.accent)
                        .accessibilityHidden(true)
                }
                Text(verbatim: topic.title)
                    .font(.title2.weight(.semibold))
                    .environment(\.locale, Locale(identifier: "de_DE"))
                    .fixedSize(horizontal: false, vertical: true)
                VStack(spacing: 22) {
                    ForEach(0..<4, id: \.self) { _ in
                        Rectangle()
                            .fill(.separator)
                            .frame(height: 1)
                    }
                }
                .padding(.top, 12)
                .accessibilityHidden(true)
                Text(verbatim: "0 / \(WritingLength.words(for: topic.level))")
                    .font(.footnote.monospacedDigit())
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .accessibilityHidden(true)
            }
            .multilineTextAlignment(.leading)
            .padding(Spacing.cardLarge)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// Each phrase on its own glass card, the du and the Sie version together,
/// in a row to swipe through.
private struct PhrasePairsRow: View {
    private var pairs: [(everyday: WritingPhrase, formal: WritingPhrase)] {
        zip(MockWriting.informalPhrases, MockWriting.formalPhrases).map { (everyday: $0, formal: $1) }
    }

    var body: some View {
        ScrollView(.horizontal) {
            GlassEffectContainer {
                HStack(spacing: Spacing.grid) {
                    ForEach(pairs, id: \.everyday.id) { pair in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(pair.everyday.role)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.accent)
                            PhraseLine(tone: "du", german: pair.everyday.german)
                            PhraseLine(tone: "Sie", german: pair.formal.german)
                        }
                        .padding(Spacing.card)
                        .frame(maxHeight: .infinity, alignment: .topLeading)
                        .containerRelativeFrame(.horizontal, count: 5, span: 4, spacing: Spacing.grid)
                        .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
                        .accessibilityElement(children: .combine)
                    }
                }
                .scrollTargetLayout()
            }
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
    }
}

/// "du  Hast du Lust, …?"
private struct PhraseLine: View {
    let tone: String
    let german: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(verbatim: tone)
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
                .frame(minWidth: 26, alignment: .leading)
            Text(verbatim: german)
                .font(.body.weight(.medium))
                .environment(\.locale, Locale(identifier: "de_DE"))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
