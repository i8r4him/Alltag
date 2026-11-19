//
//  LearnShelvesLayout.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Page design 3, "Shelves": after Today's lesson, every part is a sideways
/// row of the real things in it, like a shop's shelves: the level's rules,
/// texts and "Read and do", the friends to text and the word collections, the
/// ones not done first. A part's title opens all of it; a tile opens that thing.
struct LearnShelvesLayout: View {
    let content: LearnPageContent

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            LessonHero(content: content)
            ForEach(content.overview.parts.filter { !$0.isComingSoon }) { part in
                VStack(alignment: .leading, spacing: 12) {
                    PartHeader(part: part) { content.openPart(part.kind) }
                    Shelf(items: part.items, zoom: content.zoom, open: content.open)
                }
            }
        }
    }
}

/// One part's things as square glass tiles that snap as they scroll, edge to edge.
private struct Shelf: View {
    let items: [LearnOverview.Item]
    let zoom: Namespace.ID
    let open: (LessonTarget) -> Void

    @ScaledMetric(relativeTo: .headline) private var side: CGFloat = 164

    var body: some View {
        ScrollView(.horizontal) {
            GlassEffectContainer(spacing: 0) {
                LazyHStack(spacing: Spacing.grid) {
                    ForEach(items) { item in
                        Button { open(item.target) } label: { tile(item) }
                            .buttonStyle(.card)
                            .matchedTransitionSource(id: item.target, in: zoom)
                            .accessibilityElement(children: .combine)
                            .accessibilityValue(item.isDone ? Text("Done") : Text(verbatim: ""))
                    }
                }
                .scrollTargetLayout()
            }
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .scrollClipDisabled()
        .contentMargins(.horizontal, Spacing.screen, for: .scrollContent)
        .padding(.horizontal, -Spacing.screen)
    }

    private func tile(_ item: LearnOverview.Item) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                ScenarioArtwork(systemImage: item.systemImage, symbolSize: 26, cornerRadius: 14)
                    .frame(width: 48, height: 48)
                Spacer(minLength: 4)
                if item.isDone {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.accent)
                        .accessibilityHidden(true)
                }
            }
            Spacer(minLength: 10)
            item.title.text
                .font(.headline)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
            if let subtitle = item.subtitle {
                subtitle.text
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .padding(.top, 2)
            }
        }
        .multilineTextAlignment(.leading)
        .padding(16)
        .frame(width: side, height: side, alignment: .topLeading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .contentShape(.rect(cornerRadius: Radius.hero, style: .continuous))
        .opacity(item.isDone ? 0.75 : 1)
    }
}
