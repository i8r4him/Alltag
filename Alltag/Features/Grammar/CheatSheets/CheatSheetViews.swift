//
//  CheatSheetViews.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// "Cheat sheets": the three sheets of the learner's level as glass tiles.
/// A sheet grows out of its tile.
struct CheatSheetsSection: View {
    /// The learner's level.
    let level: Level

    @State private var open: CheatSheet.ID?
    @Namespace private var transition

    var body: some View {
        LearnSection(title: "Cheat sheets") {
            // No GlassEffectContainer here: it merges the tiles into one glass
            // layer, and the sheet then has no single tile to zoom out of
            // (the same as Articles' clue tiles).
            HStack(alignment: .top, spacing: Spacing.grid) {
                ForEach(CheatSheet.sheets(for: level)) { sheet in
                    CheatSheetTile(sheet: sheet) { open = sheet.id }
                        .matchedTransitionSource(id: sheet.id, in: transition)
                }
            }
        }
        .sheet(item: Binding(get: { CheatSheet.all.first { $0.id == open } }, set: { open = $0?.id })) { sheet in
            CheatSheetDetail(sheet: sheet)
                .navigationTransition(.zoom(sourceID: sheet.id, in: transition))
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: open) { _, opened in opened != nil }
    }
}

/// A glass tile with the sheet's German pattern and what it's about.
private struct CheatSheetTile: View {
    let sheet: CheatSheet
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                Image(systemName: sheet.systemImage)
                    .font(.title3)
                    .foregroundStyle(.accent)
                    .accessibilityHidden(true)
                Spacer(minLength: 8)
                Text(verbatim: sheet.label)
                    .font(.headline)
                    .foregroundStyle(.accent)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                Text(sheet.title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .multilineTextAlignment(.leading)
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: 132, alignment: .topLeading)
            .contentShape(.rect(cornerRadius: 26, style: .continuous))
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 26, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}

/// A cheat sheet opened from its tile, in Today's look: the sky, the artwork,
/// what it's about, and each part on a glass card.
struct CheatSheetDetail: View {
    let sheet: CheatSheet
    @State private var design = CheatSheetDesign.symbols
    @Environment(\.dismiss) private var dismiss
    @ScaledMetric(relativeTo: .largeTitle) private var artworkSize: CGFloat = 112

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 14) {
                        ScenarioArtwork(systemImage: sheet.systemImage, symbolSize: 54, cornerRadius: 28)
                            .frame(width: artworkSize, height: artworkSize)
                        Text(sheet.title)
                            .font(.title.weight(.bold))
                            .accessibilityAddTraits(.isHeader)
                        Text(sheet.summary)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)

                    if design == .key, !sheet.keys.isEmpty {
                        CheatSheetKeyCard(keys: sheet.keys)
                    }

                    ForEach(Array(sheet.parts.enumerated()), id: \.offset) { _, part in
                        CheatSheetPartCard(part: part, sheet: sheet, design: design)
                    }
                }
                .padding(.horizontal, Spacing.onboarding)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .scrollEdgeEffectStyle(.soft, for: .all)
            .scrollIndicators(.hidden)
            .safeAreaInset(edge: .bottom) {
                // Temporary, for choosing a design: only the sheet that has them.
                if !sheet.keys.isEmpty {
                    CheatSheetDesignSwitcher(design: $design)
                        .padding(.bottom, 8)
                }
            }
            .skyBackground()
            .navigationTitle(Text(verbatim: sheet.level.title))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", systemImage: "xmark") { dismiss() }
                }
            }
        }
        .fontDesign(.rounded)
        .presentationDetents([.large])
    }
}

#Preview("Section") {
    ScrollView {
        CheatSheetsSection(level: .a2)
            .padding(Spacing.screen)
    }
    .skyBackground()
    .fontDesign(.rounded)
}

#Preview("Sheet") {
    CheatSheetDetail(sheet: CheatSheet.prepositions)
}
