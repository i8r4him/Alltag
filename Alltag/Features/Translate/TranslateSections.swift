//
//  TranslateSections.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// "Word by word": each word or phrase with its grammar and meaning.
struct WordByWordSection: View {
    let words: [TranslationResult.WordBreakdown]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader("Word by word").padding(.horizontal, 4)
            VStack(spacing: 0) {
                ForEach(Array(words.enumerated()), id: \.offset) { index, word in
                    if index > 0 { Divider().padding(.leading, 18) }
                    VStack(alignment: .leading, spacing: 8) {
                        Text(verbatim: word.word)
                            .font(.headline)
                            .foregroundStyle(.accent)
                        Text(verbatim: word.meaning)
                            .font(.body)
                        Text(verbatim: word.grammar)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(Spacing.card)
                    .accessibilityElement(children: .combine)
                }
            }
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        }
        .fontDesign(.rounded)
    }
}

/// "Tone": a note on register, and the sentence formal, neutral and casual.
struct ToneSection: View {
    let note: String
    let tones: [TranslationResult.ToneVariant]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader("Tone").padding(.horizontal, 4)
            if !note.isEmpty { Text(verbatim: note)
                .textRole(.bodySmall)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
            }
            VStack(spacing: 0) {
                ForEach(Array(tones.enumerated()), id: \.offset) { index, tone in
                    if index > 0 { Divider().padding(.leading, 18) }
                    VStack(alignment: .leading, spacing: 8) {
                        Text(label(for: tone.tone))
                            .textRole(.meta)
                            .fontWeight(.semibold)
                            .foregroundStyle(.accent)
                        Text(verbatim: tone.german)
                            .textRole(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(Spacing.card)
                    .accessibilityElement(children: .combine)
                }
            }
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        }
        .fontDesign(.rounded)
    }

    private func label(for tone: TranslationResult.ToneVariant.Tone) -> LocalizedStringResource {
        switch tone {
        case .formal: "Formal"
        case .neutral: "Neutral"
        case .casual: "Casual"
        }
    }
}

/// "In context": example sentences; tap one to hear it.
struct InContextSection: View {
    let examples: [TranslationResult.Example]
    let onListen: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader("In context").padding(.horizontal, 4)
            ForEach(Array(examples.enumerated()), id: \.offset) { _, example in
                Button { onListen(example.german) } label: {
                    HStack(alignment: .top, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(verbatim: example.german).textRole(.body).foregroundStyle(.primary)
                            Text(verbatim: example.english).textRole(.bodySmall).foregroundStyle(.secondary)
                        }
                        .multilineTextAlignment(.leading)
                        Spacer(minLength: 8)
                        Image(systemName: "speaker.wave.2")
                            .foregroundStyle(.tertiary)
                            .accessibilityHidden(true)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
                    .contentShape(.rect(cornerRadius: Radius.innerCard, style: .continuous))
                }
                .buttonStyle(.card)
                .accessibilityElement(children: .combine)
                .accessibilityHint("Plays the sentence.")
            }
        }
    }
}
