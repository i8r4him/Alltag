//
//  TodaySituations.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 12.11.26.
//

import SwiftUI

/// "Situations" on Today: a few everyday situations to train, and a way to all of them.
struct TodaySituations: View {
    let situations: [Situation]
    let onShowAll: () -> Void
    let onSelect: (Situation) -> Void

    // Temporary: the maintainer picks one design, then the others and the switcher go.
    @AppStorage("situationsDesign") private var design = 0
    private static let designs = 3

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Button(action: onShowAll) {
                    HStack(spacing: 6) {
                        Text("Situations")
                            .textRole(.sectionHeader)
                        Image(systemName: "chevron.right")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(.isHeader)
                .accessibilityHint("Shows all situations.")
                Spacer()
                switcher
            }

            switch design {
            case 1: SituationRows(situations: Array(situations.prefix(3)), onSelect: onSelect)
            case 2: SituationGrid(situations: situations, onSelect: onSelect)
            default: SituationTiles(situations: situations, onSelect: onSelect)
            }
        }
        .fontDesign(.rounded)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var switcher: some View {
        HStack(spacing: 10) {
            Button { design = (design + Self.designs - 1) % Self.designs } label: { Image(systemName: "chevron.left") }
            Text(verbatim: "\(design + 1) / \(Self.designs)").monospacedDigit()
            Button { design = (design + 1) % Self.designs } label: { Image(systemName: "chevron.right") }
        }
        .font(.footnote.weight(.semibold))
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .glassEffect(.regular, in: .capsule)
    }
}

// MARK: - Design 1: large tiles in a snapping row

private struct SituationTiles: View {
    let situations: [Situation]
    let onSelect: (Situation) -> Void

    @ScaledMetric(relativeTo: .title3) private var side: CGFloat = 196

    var body: some View {
        ScrollView(.horizontal) {
            // One container: the tiles' glass is rendered together.
            // Spacing 0, so neighbouring tiles never melt into each other.
            GlassEffectContainer(spacing: 0) {
                LazyHStack(spacing: Spacing.grid) {
                    ForEach(situations) { situation in
                        Button { onSelect(situation) } label: { tile(situation) }
                            .buttonStyle(.card)
                    }
                }
                .scrollTargetLayout()
            }
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        // Not the screen's readable-width margins (they are inherited).
        .contentMargins(.horizontal, 0, for: .scrollContent)
    }

    private func tile(_ situation: Situation) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ScenarioArtwork(systemImage: situation.systemImage, symbolSize: 34, cornerRadius: 16)
                .frame(width: 64, height: 64)
            Spacer(minLength: 8)
            Text(situation.title)
                .font(.title3.weight(.semibold))
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            Text(situation.detail)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(18)
        .frame(width: side, height: side, alignment: .topLeading)
        .multilineTextAlignment(.leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .contentShape(.rect(cornerRadius: Radius.hero, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityHint("Practise this situation.")
    }
}

// MARK: - Design 2: a glass list

private struct SituationRows: View {
    let situations: [Situation]
    let onSelect: (Situation) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(situations.enumerated()), id: \.element.id) { index, situation in
                if index > 0 { Divider().padding(.leading, 72) }
                Button { onSelect(situation) } label: { SituationRow(situation: situation) }
                    .buttonStyle(.plain)
            }
        }
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

// MARK: - Design 3: a grid of small tiles

private struct SituationGrid: View {
    let situations: [Situation]
    let onSelect: (Situation) -> Void

    var body: some View {
        GlassEffectContainer(spacing: 0) {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: Spacing.grid), GridItem(.flexible())], spacing: Spacing.grid) {
                ForEach(situations.prefix(4)) { situation in
                    Button { onSelect(situation) } label: { tile(situation) }
                        .buttonStyle(.tile)
                }
            }
        }
    }

    private func tile(_ situation: Situation) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ScenarioArtwork(systemImage: situation.systemImage, symbolSize: 24, cornerRadius: 12)
                .frame(width: 44, height: 44)
            Text(situation.title)
                .font(.headline)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .topLeading)
        }
        .padding(Spacing.card)
        .multilineTextAlignment(.leading)
        .glassEffect(.regular, in: .rect(cornerRadius: 28, style: .continuous))
        .contentShape(.rect(cornerRadius: 28, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityHint("Practise this situation.")
    }
}

// MARK: - Shared row

/// One situation in a list: its artwork, title and what to do there.
struct SituationRow: View {
    let situation: Situation

    var body: some View {
        HStack(spacing: Spacing.grid) {
            ScenarioArtwork(systemImage: situation.systemImage, symbolSize: 24, cornerRadius: 12)
                .frame(width: 44, height: 44)
            VStack(alignment: .leading, spacing: 2) {
                Text(situation.title)
                    .font(.headline)
                Text(situation.detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
            Image(systemName: "waveform")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.accent)
                .accessibilityHidden(true)
        }
        .padding(Spacing.card)
        .contentShape(.rect)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Practise this situation.")
    }
}

#Preview {
    TodaySituations(situations: SituationCatalogue.suggestions(), onShowAll: {}, onSelect: { _ in })
        .padding(Spacing.screen)
        .skyBackground()
}
