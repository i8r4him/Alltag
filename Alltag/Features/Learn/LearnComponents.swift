//
//  LearnComponents.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import SwiftUI

/// The Focus card's layout for Learn's screens: title and line on the left,
/// artwork on the right, a full-width button below.
struct LearnHeroCard: View {
    let title: Text
    let detail: Text
    let systemImage: String
    let buttonTitle: LocalizedStringResource
    let buttonImage: String
    /// The app's big button, for the screen's main action.
    var isProminent = false
    let action: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    title
                        .font(.title3.weight(.semibold))
                        .fixedSize(horizontal: false, vertical: true)
                    detail
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                ScenarioArtwork(systemImage: systemImage)
                    .frame(width: 88, height: 88)
            }
            if isProminent {
                Button(action: action) { buttonLabel }
                    .buttonStyle(.primary)
            } else {
                Button(action: action) {
                    buttonLabel
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 34)
                }
                .buttonStyle(.glass)
            }
        }
        .padding(Spacing.cardLarge)
        .learnSurface()
    }

    private var buttonLabel: some View {
        Label { Text(buttonTitle) } icon: { Image(systemName: buttonImage) }
    }
}

/// A section on Learn's screens: a header, an optional note on the right, and its content.
struct LearnSection<Content: View>: View {
    let title: LocalizedStringResource
    var note: Text?
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .textRole(.sectionHeader)
                Spacer()
                if let note {
                    note
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 4)
            content
        }
    }
}

/// A row in a Learn list: artwork, title, a line, and something on the right.
struct LearnRow<Trailing: View>: View {
    let systemImage: String
    let title: Text
    let detail: Text
    let action: () -> Void
    @ViewBuilder var trailing: Trailing

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ScenarioArtwork(systemImage: systemImage, symbolSize: 22, cornerRadius: 12)
                    .frame(width: 52, height: 52)
                VStack(alignment: .leading, spacing: 3) {
                    title
                        .font(.headline)
                    detail
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                trailing
            }
            .multilineTextAlignment(.leading)
            .padding(Spacing.card)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}

extension LearnRow where Trailing == LearnChevron {
    init(systemImage: String, title: Text, detail: Text, action: @escaping () -> Void) {
        self.init(systemImage: systemImage, title: title, detail: detail, action: action) { LearnChevron() }
    }
}

/// The grey chevron at the end of a row that opens something.
struct LearnChevron: View {
    var body: some View {
        Image(systemName: "chevron.right")
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.tertiary)
            .accessibilityHidden(true)
    }
}

/// Rows on one Focus-style surface, with dividers between them.
struct LearnList<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 0) {
            Group(subviews: content) { rows in
                ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                    if index > 0 { Divider().padding(.leading, 82) }
                    row
                }
            }
        }
        .learnSurface(radius: Radius.card)
    }
}

/// The screen frame shared by Learn's screens: scrolling, the sky, rounded type.
struct LearnScreen<Content: View>: View {
    let title: LocalizedStringResource
    @ViewBuilder let content: Content

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.section) {
                content
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .fontDesign(.rounded)
        .readableContentMargins()
        .skyBackground()
        .navigationTitle(Text(title))
        .toolbarTitleDisplayMode(.inlineLarge)
        .scrollEdgeEffectStyle(.soft, for: .all)
    }
}
