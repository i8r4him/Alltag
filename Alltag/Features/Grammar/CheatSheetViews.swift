//
//  CheatSheetViews.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// "Cheat sheets": the sheets of one level as glass tiles, the learner's own
/// level first, with a menu for the others. A sheet grows out of its tile.
struct CheatSheetsSection: View {
    /// The learner's level, shown until they pick another.
    let learnerLevel: Level

    @State private var picked: Level?
    @State private var open: CheatSheet.ID?
    @Namespace private var transition

    private var level: Level { picked ?? learnerLevel }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text("Cheat sheets")
                    .textRole(.sectionHeader)
                Spacer()
                Picker("Level", selection: Binding(get: { level }, set: { picked = $0 })) {
                    ForEach(Level.selectable) { level in
                        Text(verbatim: level.title).tag(level)
                    }
                }
                .pickerStyle(.menu)
                .fixedSize()
            }
            .padding(.horizontal, 4)

            GlassEffectContainer(spacing: Spacing.grid) {
                HStack(alignment: .top, spacing: Spacing.grid) {
                    ForEach(CheatSheet.sheets(for: level)) { sheet in
                        CheatSheetTile(sheet: sheet) { open = sheet.id }
                            .matchedTransitionSource(id: sheet.id, in: transition)
                    }
                }
            }
            .id(level)
            .transition(.opacity)
        }
        .animation(.easeOut(duration: 0.2), value: level)
        .sheet(item: Binding(get: { CheatSheet.all.first { $0.id == open } }, set: { open = $0?.id })) { sheet in
            CheatSheetDetail(sheet: sheet)
                .navigationTransition(.zoom(sourceID: sheet.id, in: transition))
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: open) { _, opened in opened != nil }
        .sensoryFeedback(.selection, trigger: level)
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

                    ForEach(Array(sheet.parts.enumerated()), id: \.offset) { _, part in
                        CheatSheetPartCard(part: part)
                    }
                }
                .padding(.horizontal, Spacing.onboarding)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
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

/// One part of a sheet: its title, then each German form with what it means.
private struct CheatSheetPartCard: View {
    let part: CheatSheet.Part

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(part.title)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .accessibilityAddTraits(.isHeader)
                .padding(.bottom, 6)
            ForEach(Array(part.rows.enumerated()), id: \.offset) { index, row in
                if index > 0 { Divider() }
                VStack(alignment: .leading, spacing: 3) {
                    Text(verbatim: row.german)
                        .font(.title3.weight(.medium))
                        .foregroundStyle(.accent)
                        .environment(\.locale, Locale(identifier: "de_DE"))
                    Text(row.meaning)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 12)
                .accessibilityElement(children: .combine)
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

#Preview("Section") {
    ScrollView {
        CheatSheetsSection(learnerLevel: .a2)
            .padding(Spacing.screen)
    }
    .skyBackground()
    .fontDesign(.rounded)
}

#Preview("Sheet") {
    CheatSheetDetail(sheet: CheatSheet.cases)
}
