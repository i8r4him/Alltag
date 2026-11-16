//
//  WordParts.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The four ways to show a collection's words, to choose from (#386). Temporary.
enum CollectionWordsLayout: Int, CaseIterable {
    case flashcards, tiles, grouped, sentences
}

/// The temporary ‹ n / 4 › glass switcher between the word layouts.
struct WordsLayoutSwitcher: View {
    @Binding var layout: CollectionWordsLayout

    var body: some View {
        let all = CollectionWordsLayout.allCases
        GlassEffectContainer(spacing: 4) {
            HStack(spacing: 4) {
                Button("Previous design", systemImage: "chevron.left") {
                    layout = all[(layout.rawValue + all.count - 1) % all.count]
                }
                Text(verbatim: "\(layout.rawValue + 1) / \(all.count)")
                    .font(.subheadline.weight(.semibold).monospacedDigit())
                    .frame(minWidth: 40)
                Button("Next design", systemImage: "chevron.right") {
                    layout = all[(layout.rawValue + 1) % all.count]
                }
            }
            .labelStyle(.iconOnly)
            .buttonStyle(.glass)
        }
        .sensoryFeedback(.selection, trigger: layout)
    }
}

/// A small glass speaker that reads German aloud with the system voice.
struct SpeakButton: View {
    let text: String

    @Environment(\.services) private var services
    @State private var taps = 0

    var body: some View {
        Button {
            taps += 1
            Task { await services.voice.speak(text, rate: .normal) }
        } label: {
            Image(systemName: "speaker.wave.2.fill")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.accent)
                .frame(width: 40, height: 40)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .circle)
        .accessibilityLabel(Text("Listen"))
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
    }
}

/// The word with its article in the theme colour: "die" Praxis.
struct ArticleWord: View {
    let word: CollectionWord
    var font: Font = .headline

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            if !word.article.isEmpty {
                Text(verbatim: word.article)
                    .foregroundStyle(.accent)
            }
            Text(verbatim: word.word)
        }
        .font(font)
        .lineLimit(1)
        .minimumScaleFactor(0.6)
        .accessibilityElement(children: .combine)
    }
}

extension CollectionWord {
    /// The example with the word in bold and the theme colour where it appears as written.
    var highlightedExample: AttributedString {
        var text = AttributedString(example)
        if let range = text.range(of: word, options: .caseInsensitive) {
            text[range].inlinePresentationIntent = .stronglyEmphasized
            text[range].foregroundColor = Color.accent
        }
        return text
    }

    /// Nouns have an article; verbs and other words don't.
    var isNoun: Bool { !article.isEmpty }
}
