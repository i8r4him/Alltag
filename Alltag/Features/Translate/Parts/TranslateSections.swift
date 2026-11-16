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

/// Word by word, tone and in context: each part on its own glass card, its
/// symbol in the header. A part slides in when it arrives; with `unfolds`
/// (opened by a tap, on "How do I say …?") the parts unfold one after another.
struct TranslateDetails: View {
    let result: TranslationResult
    var unfolds = false
    let onListen: (String) -> Void

    private var sections: [TranslateSection] { TranslateSection.allCases.filter { !$0.isEmpty(in: result) } }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(Array(sections.enumerated()), id: \.element) { index, section in
                VStack(alignment: .leading, spacing: 10) {
                    Label { Text(section.title) } icon: {
                        Image(systemName: section.systemImage).foregroundStyle(.accent)
                    }
                    .textRole(.sectionHeader)
                    .padding(.horizontal, 4)
                    TranslateSectionRows(section: section, result: result, onListen: onListen)
                        .padding(.horizontal, Spacing.cardLarge)
                        .padding(.vertical, 6)
                        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
                }
                .modifier(UnfoldIn(index: index, isOn: unfolds))
                .transition(unfolds ? .opacity : .move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeOut(duration: 0.3), value: sections)
    }
}

/// A detail card that unfolds when it first appears: it fades in and drops a
/// few points into place, a moment after the one above it. A plain fade with
/// Reduce Motion.
private struct UnfoldIn: ViewModifier {
    let index: Int
    let isOn: Bool
    @State private var isShown = false
    @Environment(\.reducesMotion) private var reduceMotion

    private var isHidden: Bool { isOn && !isShown }

    func body(content: Content) -> some View {
        content
            .opacity(isHidden ? 0 : 1)
            .offset(y: isHidden && !reduceMotion ? -10 : 0)
            .scaleEffect(isHidden && !reduceMotion ? 0.97 : 1, anchor: .top)
            .onAppear {
                guard isOn else { return }
                let animation: Animation = reduceMotion
                    ? .easeInOut(duration: 0.2)
                    : Motion.easeOut(duration: 0.45).delay(0.05 + Double(index) * 0.08)
                withAnimation(animation) { isShown = true }
            }
    }
}
