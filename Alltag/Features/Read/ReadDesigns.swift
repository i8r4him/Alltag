//
//  ReadDesigns.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

// Temporary: two ways to lay out Read, behind a "‹ n / 2 ›" switcher in the
// toolbar. The maintainer picks one; the other and the switcher go before
// the PR is merged.

/// The designs to choose from. The reader follows the same choice for where
/// its questions show.
enum ReadDesign: Int, CaseIterable {
    /// The texts sorted by where you meet them; the questions on a sheet.
    case sources
    /// The texts as they look in real life, on cards to swipe; the questions
    /// on a card at the bottom of the reader.
    case realThing

    static let storageKey = "read.design"

    var name: String {
        switch self {
        case .sources: "Where it comes from"
        case .realThing: "The real thing"
        }
    }
}

/// "‹ 1 / 2 ›" with the design's name under it.
struct ReadDesignSwitcher: View {
    @Binding var design: Int

    private var count: Int { ReadDesign.allCases.count }

    var body: some View {
        HStack(spacing: 4) {
            Button { design = (design + count - 1) % count } label: {
                Image(systemName: "chevron.left")
            }
            .accessibilityLabel(Text(verbatim: "Previous design"))
            VStack(spacing: 0) {
                Text(verbatim: "\(design + 1) / \(count)")
                    .font(.subheadline.weight(.semibold).monospacedDigit())
                Text(verbatim: (ReadDesign(rawValue: design) ?? .sources).name)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .frame(minWidth: 64)
            Button { design = (design + 1) % count } label: {
                Image(systemName: "chevron.right")
            }
            .accessibilityLabel(Text(verbatim: "Next design"))
        }
    }
}

/// Where a text comes from in the learner's day, for design 1's sections.
enum ReadingSource: CaseIterable {
    case letterbox
    case phone
    case outside

    var title: LocalizedStringResource {
        switch self {
        case .letterbox: "Letters and emails"
        case .phone: "On your phone"
        case .outside: "Out and about"
        }
    }

    static func of(_ kind: ReadingKind) -> ReadingSource {
        switch kind {
        case .letter, .email: .letterbox
        case .chat, .message, .advert, .article: .phone
        case .notice, .menu, .announcement: .outside
        }
    }
}

/// Design 1: the level's texts in sections by where you meet them, each row
/// ticked once read; the next one to read has a dot.
struct ReadSourcesDesign: View {
    let level: Level
    let texts: [ReadingText]
    let read: Set<String>
    let zoom: Namespace.ID
    let onOpen: (ReadingText) -> Void

    private var nextID: String? { texts.first { !read.contains($0.id) }?.id }

    var body: some View {
        Group {
            Text("\(level.title) · \(texts.filter { read.contains($0.id) }.count) of \(texts.count) read")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
            sections
        }
    }

    private var sections: some View {
        ForEach(ReadingSource.allCases, id: \.self) { source in
            let inSource = texts.filter { ReadingSource.of($0.kind) == source }
            if !inSource.isEmpty {
                LearnSection(title: source.title, note: newNote(inSource)) {
                    WriteGlassList {
                        ForEach(inSource) { text in
                            LearnRow(systemImage: text.systemImage, title: Text(text.title),
                                     detail: Text(text.detail), action: { onOpen(text) },
                                     trailing: { trailing(for: text) })
                            .matchedTransitionSource(id: text.id, in: zoom)
                        }
                    }
                }
            }
        }
    }

    /// "1 new": the texts of a section not read yet.
    private func newNote(_ texts: [ReadingText]) -> Text? {
        let unread = texts.filter { !read.contains($0.id) }.count
        return unread == 0 ? nil : Text("\(unread) new")
    }

    @ViewBuilder
    private func trailing(for text: ReadingText) -> some View {
        if read.contains(text.id) {
            Image(systemName: "checkmark.circle.fill")
                .font(.title3)
                .foregroundStyle(.accent)
                .accessibilityLabel(Text("Read"))
        } else if text.id == nextID {
            Circle()
                .fill(Color.accentFill)
                .frame(width: 10, height: 10)
                .accessibilityLabel(Text("Next"))
        } else {
            LearnChevron()
        }
    }
}

/// Design 2: the level's texts as they look in real life, on big cards to
/// swipe through, starting at the next one to read.
struct ReadRealThingDesign: View {
    let level: Level
    let texts: [ReadingText]
    let read: Set<String>
    let zoom: Namespace.ID
    let onOpen: (ReadingText) -> Void

    @State private var current: String?
    @ScaledMetric(relativeTo: .body) private var cardHeight: CGFloat = 420

    init(level: Level, texts: [ReadingText], read: Set<String>, zoom: Namespace.ID,
         onOpen: @escaping (ReadingText) -> Void) {
        self.level = level
        self.texts = texts
        self.read = read
        self.zoom = zoom
        self.onOpen = onOpen
        _current = State(initialValue: texts.first { !read.contains($0.id) }?.id ?? texts.first?.id)
    }

    private var shown: ReadingText? {
        texts.first { $0.id == current } ?? texts.first
    }

    var body: some View {
        LearnSection(title: "Your \(level.title) texts",
                     note: Text("\(texts.filter { read.contains($0.id) }.count) of \(texts.count) read")) {
            VStack(spacing: 14) {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 14) {
                        ForEach(texts) { text in
                            Button { onOpen(text) } label: {
                                RealTextCard(text: text, isRead: read.contains(text.id))
                                    .frame(height: cardHeight)
                            }
                            .buttonStyle(.card)
                            .containerRelativeFrame(.horizontal)
                            .matchedTransitionSource(id: text.id, in: zoom)
                            .id(text.id)
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $current)
                .scrollClipDisabled()
                .scrollIndicators(.hidden)
                .scrollEdgeEffectStyle(.soft, for: .all)
                PageDots(ids: texts.map(\.id), current: current ?? texts.first?.id)
                if let shown {
                    Button { onOpen(shown) } label: {
                        Label("Read · \(shown.minutes) min · 3 questions", systemImage: "book.fill")
                    }
                    .buttonStyle(.primary)
                }
            }
        }
        .sensoryFeedback(.selection, trigger: current)
    }
}

/// One dot per text, the one on screen long and bright.
private struct PageDots: View {
    let ids: [String]
    let current: String?

    var body: some View {
        HStack(spacing: 6) {
            ForEach(ids, id: \.self) { id in
                Capsule()
                    .fill(id == current ? Color.primary : Color.primary.opacity(0.3))
                    .frame(width: id == current ? 20 : 7, height: 7)
            }
        }
        .animation(.easeOut(duration: 0.2), value: current)
        .accessibilityHidden(true)
    }
}
