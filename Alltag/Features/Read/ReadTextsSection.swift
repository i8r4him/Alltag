//
//  ReadTextsSection.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The level's texts as they look in real life, on big cards to swipe
/// through, starting at the next one to read (the maintainer's pick, 19 Nov).
struct ReadTextsSection: View {
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
