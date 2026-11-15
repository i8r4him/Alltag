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

/// "The rule in real life": today's sentence for the learner's next rule, on glass.
struct RuleInRealLifeCard: View {
    let sentence: RealLifeSentence

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: sentence.systemImage)
                    .font(.subheadline)
                    .foregroundStyle(.accent)
                    .frame(width: 36, height: 36)
                    .glassEffect(.regular, in: .circle)
                    .accessibilityHidden(true)
                Text(sentence.place)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            Text(sentence.highlighted)
                .font(.title3.weight(.medium))
                .environment(\.locale, Locale(identifier: "de_DE"))
                .fixedSize(horizontal: false, vertical: true)
            Text(sentence.english)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    if let sentence = RealLifeSentence.sentence(for: "weil") {
        RuleInRealLifeCard(sentence: sentence)
            .padding(Spacing.screen)
            .skyBackground()
            .fontDesign(.rounded)
    }
}
