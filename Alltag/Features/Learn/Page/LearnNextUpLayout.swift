//
//  LearnNextUpLayout.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Page design 2, "Next up": every part says what comes next. After Today's
/// lesson, each part is one glass card with its next real thing (the next
/// rule, text, friend to text, word collection), its artwork, a bar of the
/// part's progress, Start, and "See all".
struct LearnNextUpLayout: View {
    let content: LearnPageContent

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            LessonHero(content: content)
            VStack(alignment: .leading, spacing: 12) {
                Text("Up next in each part")
                    .textRole(.sectionHeader)
                    .padding(.horizontal, 4)
                VStack(spacing: Spacing.grid) {
                    ForEach(content.overview.parts) { part in
                        if part.isComingSoon {
                            ComingSoonRow(part: part) { content.openPart(part.kind) }
                        } else {
                            NextCard(part: part, zoom: content.zoom, open: content.open) {
                                content.openPart(part.kind)
                            }
                        }
                    }
                }
            }
        }
    }
}

/// One part's next thing on a clear glass card.
private struct NextCard: View {
    let part: LearnOverview.Part
    let zoom: Namespace.ID
    let open: (LessonTarget) -> Void
    let openPart: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                Label { Text(part.kind.title) } icon: { Image(systemName: part.kind.systemImage) }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.accent)
                Spacer()
                PartProgressText(part: part)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            if let next = part.next {
                HStack(alignment: .center, spacing: 14) {
                    VStack(alignment: .leading, spacing: 6) {
                        next.title.text
                            .font(.title3.weight(.semibold))
                            .fixedSize(horizontal: false, vertical: true)
                        if let subtitle = next.subtitle {
                            detail(subtitle)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    ScenarioArtwork(systemImage: next.systemImage, symbolSize: 34, cornerRadius: 16)
                        .frame(width: 64, height: 64)
                }
                .accessibilityElement(children: .combine)
            } else {
                Text("Everything here is done")
                    .font(.title3.weight(.semibold))
            }
            if let fraction = part.fraction {
                ProgressView(value: fraction)
                    .tint(.accent)
                    .accessibilityHidden(true)
            }
            HStack {
                if let next = part.next {
                    Button { open(next.target) } label: {
                        Label("Start", systemImage: "play.fill")
                    }
                    .buttonStyle(.primaryCompact)
                    .matchedTransitionSource(id: next.target, in: zoom)
                }
                Spacer()
                Button(action: openPart) {
                    HStack(spacing: 4) {
                        Text("See all")
                        Image(systemName: "chevron.right")
                            .font(.footnote.weight(.bold))
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(minHeight: Spacing.minTouchTarget)
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    /// The line under the title; a friend's last message sits in a bubble.
    @ViewBuilder
    private func detail(_ subtitle: LessonTitle) -> some View {
        if part.kind == .write {
            subtitle.text
                .font(.subheadline)
                .lineLimit(2)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.controlFill, in: .rect(cornerRadius: 16, style: .continuous))
        } else {
            subtitle.text
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
    }
}

/// A part that is still a shell, as one quiet row.
private struct ComingSoonRow: View {
    let part: LearnOverview.Part
    let onOpen: () -> Void

    var body: some View {
        Button(action: onOpen) {
            HStack(spacing: 14) {
                Image(systemName: part.kind.systemImage)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .frame(width: 40, height: 40)
                    .background(.controlFill, in: .rect(cornerRadius: Radius.tile, style: .continuous))
                VStack(alignment: .leading, spacing: 2) {
                    Text(part.kind.title)
                        .font(.headline)
                    Text(part.kind.summary)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                PartProgressText(part: part)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(Spacing.card)
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
            .contentShape(.rect(cornerRadius: Radius.card, style: .continuous))
        }
        .buttonStyle(.card)
        .accessibilityElement(children: .combine)
    }
}
