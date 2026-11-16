//
//  TranslateLoading.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftUI

/// The lower half while the translation is on its way: a blank line in the
/// shape of the answer.
struct TranslateLoadingResult: View {
    let label: LocalizedStringResource

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TranslateLanguageChip(label: label, isResult: true)
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
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Under the details that have arrived, while the rest is still being
/// written: a blank card for each part still to come.
struct TranslateLoadingDetails: View {
    /// The parts that haven't arrived yet.
    let pending: [TranslateSection]

    var body: some View {
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
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("Adding word by word, tone and examples…"))
    }
}
