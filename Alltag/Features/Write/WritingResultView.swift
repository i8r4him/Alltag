//
//  WritingResultView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The correction: the teacher's summary, the sentences (in one of the designs
/// on trial), the text as it should read, and whether each point was covered.
struct WritingResultView: View {
    let model: WriteModel
    @AppStorage(WritingDesignSwitcher.key) private var design = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let check = model.check {
                WritingSummaryCard(check: check, savedMistakes: model.savedMistakes)
            } else {
                WritingCheckingCard(checked: model.sentences.count)
            }
            switch design {
            case 1: MarkedTextDesign(sentences: model.sentences)
            case 2: BeforeAfterDesign(model: model)
            default: SentenceCardsDesign(sentences: model.sentences)
            }
            if let check = model.check {
                if design != 2 { CorrectedTextCard(text: model.correctedText) }
                WritingPointsCard(task: model.task, points: check.points)
            }
        }
        .animation(.easeOut(duration: 0.3), value: model.sentences.count)
        .animation(.snappy, value: design)
    }
}

/// Temporary: "‹ n / 3 ›" to compare the three designs of the correction on the iPhone.
/// Removed with the two designs that aren't chosen.
struct WritingDesignSwitcher: View {
    static let key = "write.resultDesign"
    @AppStorage(key) private var design = 0

    var body: some View {
        HStack(spacing: 4) {
            Button("Previous design", systemImage: "chevron.left") { design = (design + 2) % 3 }
            Text(verbatim: "\(design + 1) / 3")
                .font(.subheadline.weight(.semibold))
                .monospacedDigit()
            Button("Next design", systemImage: "chevron.right") { design = (design + 1) % 3 }
        }
        .labelStyle(.iconOnly)
        .sensoryFeedback(.selection, trigger: design)
    }
}

// MARK: - Shared cards

private struct WritingCheckingCard: View {
    let checked: Int

    var body: some View {
        HStack(spacing: 14) {
            ProgressView()
            VStack(alignment: .leading, spacing: 2) {
                Text("Checking your text")
                    .font(.headline)
                (checked == 0 ? Text("Reading it like a teacher …") : Text("^[\(checked) sentence](inflect: true) checked"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .contentTransition(.numericText())
            }
            Spacer(minLength: 0)
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

private struct WritingSummaryCard: View {
    let check: WritingCheck
    let savedMistakes: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label {
                check.fixCount == 0 ? Text("No mistakes") : Text("^[\(check.fixCount) thing](inflect: true) to fix")
            } icon: {
                Image(systemName: check.fixCount == 0 ? "checkmark.seal.fill" : "pencil.circle.fill")
                    .foregroundStyle(check.fixCount == 0 ? Color.success : Color.mistake)
            }
            .font(.title3.weight(.semibold))
            Text(verbatim: check.summary)
                .fixedSize(horizontal: false, vertical: true)
            if savedMistakes > 0 {
                Label("Saved to Fix your mistakes", systemImage: "arrow.uturn.backward.circle")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.accent)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

private struct CorrectedTextCard: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("As it should read", systemImage: "text.badge.checkmark")
                    .textRole(.sectionHeader)
                Spacer()
                ShareLink(item: text) { Image(systemName: "square.and.arrow.up") }
                    .accessibilityLabel(Text("Share the corrected text"))
            }
            Text(verbatim: text)
                .font(.title3)
                .textSelection(.enabled)
                .environment(\.locale, Locale(identifier: "de"))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

private struct WritingPointsCard: View {
    let task: WritingTask
    let points: [WritingCheck.Point]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("The task", systemImage: "checklist")
                .textRole(.sectionHeader)
            ForEach(Array(zip(task.points, points).enumerated()), id: \.offset) { _, pair in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: pair.1.covered ? "checkmark.circle.fill" : "circle.dashed")
                        .foregroundStyle(pair.1.covered ? Color.success : Color.secondary)
                        .accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(verbatim: pair.0)
                            .font(.body.weight(.medium))
                        Text(verbatim: pair.1.note)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(Text("\(pair.1.covered ? Text("Done") : Text("Missing")): \(pair.0). \(pair.1.note)"))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// The correction with the words that changed in the theme colour.
func changedWords(said: String, correction: String) -> Text {
    let changed = MistakePractice.wrongWords(said: correction, correction: said)
    var text = AttributedString()
    for (index, word) in correction.split(whereSeparator: \.isWhitespace).enumerated() {
        if index > 0 { text += AttributedString(" ") }
        var part = AttributedString(String(word))
        if changed.contains(index) {
            part.foregroundColor = .accent
            part.inlinePresentationIntent = .stronglyEmphasized
        }
        text += part
    }
    return Text(text)
}

// MARK: - Design 1: a card for each sentence

private struct SentenceCardsDesign: View {
    let sentences: [WritingSentence]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(sentences) { sentence in
                Group {
                    if sentence.feedback.kind == .good {
                        Label { Text(verbatim: sentence.original) } icon: {
                            Image(systemName: "checkmark.circle.fill").foregroundStyle(Color.success)
                        }
                        .font(.body)
                    } else {
                        VStack(alignment: .leading, spacing: 10) {
                            MistakePractice.quote(said: sentence.original, correction: sentence.feedback.correction ?? sentence.original)
                                .font(.title3)
                            if let correction = sentence.feedback.correction {
                                Label { changedWords(said: sentence.original, correction: correction) } icon: {
                                    Image(systemName: "arrow.turn.down.right").foregroundStyle(.accent)
                                }
                                .font(.title3)
                            }
                            FeedbackCard(feedback: sentence.feedback)
                        }
                    }
                }
                .environment(\.locale, Locale(identifier: "de"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Spacing.card)
                .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

// MARK: - Design 2: the text marked like an exam, the fixes numbered below

private struct MarkedTextDesign: View {
    let sentences: [WritingSentence]

    private var marked: [WritingSentence] { sentences.filter { $0.feedback.kind != .good } }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !sentences.isEmpty {
                Text(markedText)
                    .font(.title3)
                    .lineSpacing(4)
                    .environment(\.locale, Locale(identifier: "de"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(Spacing.cardLarge)
                    .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
            }
            ForEach(Array(marked.enumerated()), id: \.element.id) { number, sentence in
                HStack(alignment: .top, spacing: 12) {
                    Text(verbatim: "\(number + 1)")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 26, height: 26)
                        .background(sentence.feedback.kind == .fix ? Color.mistake : Color.secondary, in: .circle)
                        .accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: 8) {
                        if let correction = sentence.feedback.correction {
                            changedWords(said: sentence.original, correction: correction)
                                .font(.title3)
                                .environment(\.locale, Locale(identifier: "de"))
                        }
                        FeedbackCard(feedback: sentence.feedback)
                    }
                }
                .padding(Spacing.card)
                .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }

    /// The sentences as one text: a fix underlined in coral, a note dotted, each with its number.
    private var markedText: AttributedString {
        var text = AttributedString()
        var number = 0
        for (index, sentence) in sentences.enumerated() {
            if index > 0 { text += AttributedString(" ") }
            var part = AttributedString(sentence.original)
            if sentence.feedback.kind != .good {
                number += 1
                let isFix = sentence.feedback.kind == .fix
                part.underlineStyle = Text.LineStyle(pattern: isFix ? .solid : .dot, color: isFix ? .mistake : .secondary)
                var mark = AttributedString(" \(number)")
                mark.foregroundColor = isFix ? .mistake : .secondary
                mark.inlinePresentationIntent = .stronglyEmphasized
                part += mark
            }
            text += part
        }
        return text
    }
}

// MARK: - Design 3: yours and corrected, side by side in one card

private struct BeforeAfterDesign: View {
    let model: WriteModel
    @State private var showsCorrected = true

    private var marked: [WritingSentence] { model.sentences.filter { $0.feedback.kind != .good } }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 14) {
                Picker("Text", selection: $showsCorrected) {
                    Text("Yours").tag(false)
                    Text("Corrected").tag(true)
                }
                .pickerStyle(.segmented)
                .disabled(model.check == nil)
                Text(verbatim: showsCorrected && model.check != nil ? model.correctedText : model.checkedText)
                    .font(.title3)
                    .textSelection(.enabled)
                    .environment(\.locale, Locale(identifier: "de"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentTransition(.opacity)
            }
            .padding(Spacing.cardLarge)
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
            .animation(.easeOut(duration: 0.2), value: showsCorrected)
            .sensoryFeedback(.selection, trigger: showsCorrected)

            ForEach(marked) { sentence in
                VStack(alignment: .leading, spacing: 6) {
                    MistakePractice.quote(said: sentence.original, correction: sentence.feedback.correction ?? sentence.original)
                    if let correction = sentence.feedback.correction {
                        changedWords(said: sentence.original, correction: correction)
                    }
                    Text(verbatim: "\(sentence.feedback.title) · \(sentence.feedback.note)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .environment(\.locale, Locale(identifier: "de"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 12)
                .overlay(alignment: .leading) {
                    Capsule().fill(sentence.feedback.kind == .fix ? Color.mistake : Color.secondary).frame(width: 3)
                }
                .accessibilityElement(children: .combine)
                .transition(.opacity)
            }
        }
    }
}
