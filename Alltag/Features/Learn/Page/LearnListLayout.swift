//
//  LearnListLayout.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Page design 4, "List": calm and short. Today's lesson, then every part as
/// a row on one glass card: its symbol, its name, what comes next in it, its
/// progress in words and as a small ring.
struct LearnListLayout: View {
    let content: LearnPageContent

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            LessonHero(content: content)
            VStack(alignment: .leading, spacing: 12) {
                Text("Practise")
                    .textRole(.sectionHeader)
                    .padding(.horizontal, 4)
                VStack(spacing: 0) {
                    ForEach(Array(content.overview.parts.enumerated()), id: \.element.id) { index, part in
                        if index > 0 {
                            Divider()
                                .padding(.leading, 70)
                        }
                        PartListRow(part: part) { content.openPart(part.kind) }
                    }
                }
                .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
            }
        }
    }
}

private struct PartListRow: View {
    let part: LearnOverview.Part
    let onOpen: () -> Void

    var body: some View {
        Button(action: onOpen) {
            HStack(spacing: Spacing.grid) {
                Image(systemName: part.kind.systemImage)
                    .font(.title3)
                    .foregroundStyle(part.isComingSoon ? AnyShapeStyle(.secondary) : AnyShapeStyle(.accent))
                    .frame(width: 42, height: 42)
                    .background(Color.accent.opacity(part.isComingSoon ? 0.04 : 0.10),
                                in: .rect(cornerRadius: Radius.tile, style: .continuous))
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 3) {
                    Text(part.kind.title)
                        .font(.headline)
                    if let next = part.next {
                        HStack(spacing: 4) {
                            Text("Next")
                                .foregroundStyle(.secondary)
                            next.title.text
                                .lineLimit(1)
                        }
                        .font(.subheadline)
                    } else {
                        Text(part.kind.summary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    PartProgressText(part: part)
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(part.isComingSoon ? AnyShapeStyle(.secondary) : AnyShapeStyle(.accent))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                if let fraction = part.fraction {
                    PartRing(fraction: fraction, size: 34)
                }
                LearnChevron()
            }
            .multilineTextAlignment(.leading)
            .padding(Spacing.card)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}
