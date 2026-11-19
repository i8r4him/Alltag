//
//  LearnHubLayout.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Page design 1, "Hub": Today's lesson, then the four parts as square glass
/// tiles in a two-by-two grid, each with its artwork and a ring of its real
/// progress, then the word collections as they are.
struct LearnHubLayout: View {
    let content: LearnPageContent
    @Binding var notice: ToastMessage?

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            LessonHero(content: content)
            VStack(alignment: .leading, spacing: 12) {
                Text("Practise")
                    .textRole(.sectionHeader)
                    .padding(.horizontal, 4)
                GlassEffectContainer(spacing: 0) {
                    Grid(horizontalSpacing: Spacing.grid, verticalSpacing: Spacing.grid) {
                        GridRow {
                            tile(.grammar)
                            tile(.read)
                        }
                        GridRow {
                            tile(.write)
                            tile(.listen)
                        }
                    }
                }
            }
            WordCollectionsSection(level: content.level, notice: $notice)
        }
    }

    @ViewBuilder
    private func tile(_ kind: LearnPart) -> some View {
        if let part = content.overview.part(kind) {
            HubTile(part: part) { content.openPart(kind) }
        }
    }
}

/// A part as a square glass tile: artwork and progress ring on top, the name
/// and the progress in words at the bottom.
private struct HubTile: View {
    let part: LearnOverview.Part
    let onOpen: () -> Void

    @ScaledMetric(relativeTo: .title3) private var height: CGFloat = 164

    var body: some View {
        Button(action: onOpen) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    ScenarioArtwork(systemImage: part.kind.systemImage, symbolSize: 28, cornerRadius: 14)
                        .frame(width: 52, height: 52)
                    Spacer(minLength: 8)
                    if let fraction = part.fraction {
                        PartRing(fraction: fraction)
                    }
                }
                Spacer(minLength: 14)
                Text(part.kind.title)
                    .font(.title3.weight(.bold))
                PartProgressText(part: part)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(part.isComingSoon ? AnyShapeStyle(.secondary) : AnyShapeStyle(.accent))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .padding(18)
            .frame(maxWidth: .infinity, minHeight: height, alignment: .topLeading)
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
            .contentShape(.rect(cornerRadius: Radius.hero, style: .continuous))
            .opacity(part.isComingSoon ? 0.7 : 1)
        }
        .buttonStyle(.card)
        .accessibilityElement(children: .combine)
    }
}
