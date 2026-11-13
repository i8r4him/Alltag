//
//  TranslateWelcome.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import SwiftUI

/// A starting point for Translate, with prompts the learner can choose to edit.
struct TranslateWelcome: View {
    let onChoose: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(systemName: "translate")
                .font(.largeTitle)
                .foregroundStyle(.accent)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 8) {
                Text("Find the words")
                    .font(.largeTitle.bold())
                Text("Say it naturally in German, or understand something you’ve read. Get the words, tone and examples along the way.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 8) { prompts }
                VStack(alignment: .leading, spacing: 8) { prompts }
            }
        }
        .fontDesign(.rounded)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var prompts: some View {
        Button("Ask to meet later") {
            onChoose("Could we meet half an hour later?")
        }
        .buttonStyle(.glass)
        Button("Understand a word") {
            onChoose("Kündigungsfrist")
        }
        .buttonStyle(.glass)
    }
}

#Preview {
    TranslateWelcome { _ in }
        .padding(Spacing.screen)
        .skyBackground()
}
