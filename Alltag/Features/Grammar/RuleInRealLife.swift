//
//  RuleInRealLife.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A German sentence from daily life that uses a rule, with the words that
/// show the rule marked.
struct RealLifeSentence: Identifiable {
    /// Where you'd meet it, e.g. "Station announcement".
    let place: LocalizedStringResource
    let systemImage: String
    let german: String
    let english: LocalizedStringResource
    /// The words that show the rule, in the order they appear.
    let marked: [String]

    var id: String { german }

    /// The sentence for `ruleID` on `date`: a different one each day, the same all day.
    static func sentence(for ruleID: String, on date: Date = .now, calendar: Calendar = .current) -> RealLifeSentence? {
        guard let sentences = byRule[ruleID], !sentences.isEmpty else { return nil }
        let day = calendar.ordinality(of: .day, in: .era, for: date) ?? 0
        return sentences[day % sentences.count]
    }

    /// The sentence with the marked words bold in the theme colour.
    var highlighted: AttributedString {
        var text = AttributedString(german)
        var searchStart = text.startIndex
        for word in marked {
            guard let range = text[searchStart...].range(of: word) else { continue }
            text[range].foregroundColor = AppTheme.shared.palette.accent
            text[range].inlinePresentationIntent = .stronglyEmphasized
            searchStart = range.upperBound
        }
        return text
    }
}

/// "The rule in real life": today's sentence for the learner's next rule, on
/// glass. Three shorter designs to choose from, behind a temporary switcher.
struct RuleInRealLifeSection: View {
    let sentence: RealLifeSentence

    @State private var design = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text("The rule in real life")
                    .textRole(.sectionHeader)
                Spacer()
                DesignSwitcher(selection: $design, count: 3)
            }
            .padding(.horizontal, 4)
            Group {
                switch design {
                case 0: RealLifeCompactCard(sentence: sentence)
                case 1: RealLifeRowCard(sentence: sentence)
                default: RealLifeRevealCard(sentence: sentence)
                }
            }
            .transition(.opacity)
        }
        .animation(.easeOut(duration: 0.2), value: design)
    }
}

/// Design 1: the place on a small line, the sentence, and the English under it.
private struct RealLifeCompactCard: View {
    let sentence: RealLifeSentence

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label { Text(sentence.place) } icon: { Image(systemName: sentence.systemImage) }
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            RealLifeGerman(sentence: sentence, font: .headline)
            Text(sentence.english)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Spacing.card)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

/// Design 2: a row, with the place's artwork on the left.
private struct RealLifeRowCard: View {
    let sentence: RealLifeSentence

    var body: some View {
        HStack(spacing: 14) {
            ScenarioArtwork(systemImage: sentence.systemImage, symbolSize: 22, cornerRadius: 12)
                .frame(width: 52, height: 52)
            VStack(alignment: .leading, spacing: 3) {
                RealLifeGerman(sentence: sentence, font: .headline)
                Text(sentence.english)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(Spacing.card)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

/// Design 3: only the German and the place; a tap shows the English, so the
/// learner tries to understand it first.
private struct RealLifeRevealCard: View {
    let sentence: RealLifeSentence

    @State private var showsEnglish = false

    var body: some View {
        Button { showsEnglish.toggle() } label: {
            VStack(alignment: .leading, spacing: 6) {
                RealLifeGerman(sentence: sentence, font: .headline)
                if showsEnglish {
                    Text(sentence.english)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .transition(.opacity)
                } else {
                    Label { Text(sentence.place) } icon: { Image(systemName: sentence.systemImage) }
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .transition(.opacity)
                }
            }
            .multilineTextAlignment(.leading)
            .padding(Spacing.card)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(.rect(cornerRadius: Radius.card, style: .continuous))
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: Radius.card, style: .continuous))
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: 0.2), value: showsEnglish)
        .sensoryFeedback(.impact(weight: .medium), trigger: showsEnglish)
        .accessibilityHint(Text("Shows the English"))
    }
}

/// The German sentence with the rule's words marked.
private struct RealLifeGerman: View {
    let sentence: RealLifeSentence
    let font: Font

    var body: some View {
        Text(sentence.highlighted)
            .font(font.weight(.medium))
            .environment(\.locale, Locale(identifier: "de_DE"))
            .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    if let sentence = RealLifeSentence.sentence(for: "weil") {
        RuleInRealLifeSection(sentence: sentence)
            .padding(Spacing.screen)
            .skyBackground()
            .fontDesign(.rounded)
    }
}
