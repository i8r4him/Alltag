//
//  TranslateStart.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftUI

/// Something to try before the learner has typed anything.
struct TranslatePrompt: Identifiable {
    let title: LocalizedStringResource
    let systemImage: String
    /// What goes in the field. Content, not UI text.
    let text: String

    var id: String { text }

    static let all = [
        TranslatePrompt(title: "Ask to meet later", systemImage: "calendar", text: "Could we meet half an hour later?"),
        TranslatePrompt(title: "Understand a word", systemImage: "text.magnifyingglass", text: "Kündigungsfrist")
    ]
}

/// Where to start: what Translate does and two prompts to try. It has no card
/// of its own: it fills the input card's lower half until there is a translation.
struct TranslateWelcomeContent: View {
    let onChoose: (String) -> Void

    @ScaledMetric(relativeTo: .title3) private var artworkSize: CGFloat = 88

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Find the words")
                        .font(.title3.weight(.semibold))
                    Text("Say it naturally in German, or understand something you’ve read, with the words, tone and examples.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                ScenarioArtwork(systemImage: "translate")
                    .frame(width: artworkSize, height: artworkSize)
            }
            GlassEffectContainer(spacing: 8) {
                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 8) { prompts }
                    VStack(alignment: .leading, spacing: 8) { prompts }
                }
            }
        }
    }

    private var prompts: some View {
        ForEach(TranslatePrompt.all) { prompt in
            Button { onChoose(prompt.text) } label: {
                Label { Text(prompt.title) } icon: { Image(systemName: prompt.systemImage) }
            }
            .buttonStyle(.glass)
        }
    }
}

/// The lower half before there is a translation.
struct TranslateEmptyResult: View {
    let label: LocalizedStringResource

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TranslateLanguageChip(label: label, isResult: true)
            Text("The translation appears here.")
                .font(.title3)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
