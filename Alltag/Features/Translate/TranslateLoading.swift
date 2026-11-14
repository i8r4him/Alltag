//
//  TranslateLoading.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftUI

/// The lower half while the translation is on its way.
///
/// TEMPORARY (#296): three designs to choose from.
/// 1 a spinner; 2 a blank line in the shape of the answer; 3 three dots that light up in turn.
struct TranslateLoadingResult: View {
    let design: Int
    let label: LocalizedStringResource

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TranslateLanguageChip(label: label, isResult: true)
            switch design {
            case 2:
                Text(verbatim: "Können wir uns eine halbe Stunde später treffen?")
                    .font(.title2.weight(.semibold))
                    .redacted(reason: .placeholder)
                    .accessibilityHidden(true)
                Label {
                    Text("Translating…")
                } icon: {
                    ProgressView().controlSize(.small)
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            case 3:
                Image(systemName: "ellipsis")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.accent)
                    .symbolEffect(.variableColor.iterative, options: .repeat(.continuous))
                    .frame(height: 44)
                    .accessibilityLabel(Text("Translating…"))
            default:
                ProgressView()
                    .frame(height: 44)
                    .accessibilityLabel(Text("Translating…"))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Under the details that have arrived, while the rest is still being written.
///
/// TEMPORARY (#296): three designs to choose from.
/// 1 one line of text; 2 a blank card for each part still to come;
/// 3 a chip for each part still to come, pulsing (the parts slide in as they arrive).
struct TranslateLoadingDetails: View {
    let design: Int
    /// The parts that haven't arrived yet.
    let pending: [TranslateSection]

    var body: some View {
        switch design {
        case 2: placeholders
        case 3: chips
        default:
            Label("Adding word by word, tone and examples…", systemImage: "sparkles")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
        }
    }

    private var placeholders: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(pending) { section in
                VStack(alignment: .leading, spacing: 10) {
                    Label { Text(section.title) } icon: {
                        Image(systemName: section.systemImage).foregroundStyle(.accent)
                    }
                    .textRole(.sectionHeader)
                    .padding(.horizontal, 4)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(verbatim: "verschieben").font(.headline)
                        Text(verbatim: "to move, to postpone something")
                        Text(verbatim: "verb · separable").font(.subheadline)
                    }
                    .redacted(reason: .placeholder)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(Spacing.cardLarge)
                    .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
                    .accessibilityHidden(true)
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Adding word by word, tone and examples…"))
    }

    private var chips: some View {
        FlowLayout(spacing: 8) {
            ForEach(pending) { section in
                Label { Text(section.title) } icon: {
                    Image(systemName: section.systemImage)
                        .foregroundStyle(.accent)
                        .symbolEffect(.pulse, options: .repeat(.continuous))
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 14)
                .frame(minHeight: 40)
                .glassEffect(.regular, in: .capsule)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Adding word by word, tone and examples…"))
    }
}
