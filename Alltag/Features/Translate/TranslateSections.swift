//
//  TranslateSections.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The three parts that explain a translation: word by word, tone, in context.
enum TranslateSection: String, CaseIterable, Identifiable {
    case words, tone, context

    var id: Self { self }

    var title: LocalizedStringResource {
        switch self {
        case .words: "Word by word"
        case .tone: "Tone"
        case .context: "In context"
        }
    }

    var systemImage: String {
        switch self {
        case .words: "text.word.spacing"
        case .tone: "theatermasks.fill"
        case .context: "text.bubble.fill"
        }
    }

    func isEmpty(in result: TranslationResult) -> Bool {
        switch self {
        case .words: result.words.isEmpty
        case .tone: result.tones.isEmpty
        case .context: result.examples.isEmpty
        }
    }
}

extension TranslationResult.ToneVariant.Tone {
    var title: LocalizedStringResource {
        switch self {
        case .formal: "Formal"
        case .neutral: "Neutral"
        case .casual: "Casual"
        }
    }

    var systemImage: String {
        switch self {
        case .formal: "briefcase.fill"
        case .neutral: "person.fill"
        case .casual: "face.smiling"
        }
    }
}

/// The rows of one section, without a card around them.
struct TranslateSectionRows: View {
    let section: TranslateSection
    let result: TranslationResult
    let onListen: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            switch section {
            case .words:
                ForEach(Array(result.words.enumerated()), id: \.offset) { index, word in
                    if index > 0 { Divider() }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(verbatim: word.word)
                            .font(.headline)
                            .foregroundStyle(.accent)
                        Text(verbatim: word.meaning)
                        Text(verbatim: word.grammar)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                    .accessibilityElement(children: .combine)
                }
            case .tone:
                // The note gets its own row, with room above and below, not squeezed into the card's edge.
                if !result.note.isEmpty {
                    Label {
                        Text(verbatim: result.note)
                    } icon: {
                        Image(systemName: "info.circle.fill").foregroundStyle(.accent)
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                }
                ForEach(Array(result.tones.enumerated()), id: \.offset) { index, tone in
                    if index > 0 || !result.note.isEmpty { Divider() }
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        Label { Text(tone.tone.title) } icon: { Image(systemName: tone.tone.systemImage) }
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.accent)
                            .frame(width: 104, alignment: .leading)
                        Text(verbatim: tone.german)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical, 12)
                    .accessibilityElement(children: .combine)
                }
            case .context:
                ForEach(Array(result.examples.enumerated()), id: \.offset) { index, example in
                    if index > 0 { Divider() }
                    Button { onListen(example.german) } label: {
                        HStack(alignment: .top, spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(verbatim: example.german).foregroundStyle(.primary)
                                Text(verbatim: example.english)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "speaker.wave.2.fill")
                                .foregroundStyle(.accent)
                                .accessibilityHidden(true)
                        }
                        .padding(.vertical, 12)
                        .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .accessibilityElement(children: .combine)
                    .accessibilityHint(Text("Plays the sentence."))
                }
            }
        }
    }
}

/// Word by word, tone and in context.
///
/// TEMPORARY (#296): four designs to choose from.
/// 1 a glass card each; 2 one card with a segmented picker; 3 cards that fold,
/// the first one open; 4 as 1, with the tones as chips in the result instead
/// (`hidesTone`).
struct TranslateDetails: View {
    let design: Int
    let result: TranslationResult
    /// The tones are shown as chips in the result card.
    var hidesTone = false
    let onListen: (String) -> Void

    /// The segment shown in design 2; the first one until the learner picks.
    @State private var picked: TranslateSection?
    /// The cards unfolded in design 3; `nil` until the learner folds one: the first is open.
    @State private var unfolded: Set<TranslateSection>?

    private var sections: [TranslateSection] {
        TranslateSection.allCases.filter { !$0.isEmpty(in: result) && !(hidesTone && $0 == .tone) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: design == 3 ? Spacing.grid : 24) {
            switch design {
            case 2: segmented
            case 3: ForEach(sections) { folding($0) }
            default: ForEach(sections) { stacked($0) }
            }
        }
        .animation(.easeOut(duration: 0.3), value: sections)
    }

    private func header(_ section: TranslateSection) -> some View {
        Label { Text(section.title) } icon: {
            Image(systemName: section.systemImage).foregroundStyle(.accent)
        }
        .textRole(.sectionHeader)
    }

    private func rows(_ section: TranslateSection) -> some View {
        TranslateSectionRows(section: section, result: result, onListen: onListen)
            .padding(.horizontal, Spacing.cardLarge)
            .padding(.vertical, 6)
    }

    // MARK: 1 · A card each

    private func stacked(_ section: TranslateSection) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            header(section).padding(.horizontal, 4)
            rows(section)
                .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    // MARK: 2 · Segmented

    @ViewBuilder
    private var segmented: some View {
        if let shown = sections.first(where: { $0 == picked }) ?? sections.first {
            VStack(alignment: .leading, spacing: 4) {
                if sections.count > 1 {
                    Picker("Details", selection: Binding { shown } set: { picked = $0 }) {
                        ForEach(sections) { Text($0.title).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, Spacing.card)
                    .padding(.top, Spacing.card)
                } else {
                    header(shown)
                        .padding(.horizontal, Spacing.cardLarge)
                        .padding(.top, Spacing.card)
                }
                rows(shown)
            }
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
            .sensoryFeedback(.selection, trigger: picked)
        }
    }

    // MARK: 3 · Folding

    private func folding(_ section: TranslateSection) -> some View {
        let open = unfolded ?? Set(sections.prefix(1))
        let isOpen = open.contains(section)
        return VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeOut(duration: 0.25)) { unfolded = open.symmetricDifference([section]) }
            } label: {
                HStack {
                    header(section)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(isOpen ? 180 : 0))
                        .accessibilityHidden(true)
                }
                .padding(.horizontal, Spacing.cardLarge)
                .frame(minHeight: 60)
                .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .accessibilityAddTraits(isOpen ? .isSelected : [])
            if isOpen {
                rows(section).transition(.opacity)
            }
        }
        .glassEffect(.regular, in: .rect(cornerRadius: isOpen ? Radius.hero : 30, style: .continuous))
        .sensoryFeedback(.impact(weight: .medium), trigger: isOpen)
    }
}
