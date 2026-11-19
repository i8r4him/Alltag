//
//  WritingResultView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The correction: the teacher's summary, a card for each sentence, the text as
/// it should read, and whether each point was covered.
struct WritingResultView: View {
    let model: WriteModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let check = model.check {
                WritingSummaryCard(check: check, savedMistakes: model.savedMistakes)
            } else {
                WritingCheckingCard(checked: model.sentences.count)
            }
            ForEach(model.sentences) { sentence in
                SentenceCard(sentence: sentence)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            if let check = model.check {
                CorrectedTextCard(text: model.correctedText)
                if !model.brief.points.isEmpty { WritingPointsCard(points: model.brief.points, covered: check.points) }
            }
        }
        .animation(.easeOut(duration: 0.3), value: model.sentences.count)
    }
}

private struct WritingCheckingCard: View {
    let checked: Int

    var body: some View {
        HStack(spacing: 14) {
            ProgressView()
            VStack(alignment: .leading, spacing: 2) {
                Text("Checking your text")
                    .font(.headline)
                Group {
                    if checked == 0 {
                        Text("Reading it like a teacher …")
                    } else {
                        Text("^[\(checked) sentence](inflect: true) checked")
                    }
                }
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
                if check.fixCount == 0 {
                    Text("No mistakes")
                } else {
                    Text("^[\(check.fixCount) thing](inflect: true) to fix")
                }
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

/// A sentence that is right gets a green tick; one to fix or improve shows what was
/// written, the correction with the changed words marked, and why.
private struct SentenceCard: View {
    let sentence: WritingSentence

    var body: some View {
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
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

private struct WritingPointsCard: View {
    let points: [String]
    let covered: [WritingCheck.Point]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("The task", systemImage: "checklist")
                .textRole(.sectionHeader)
            ForEach(Array(zip(points, covered).enumerated()), id: \.offset) { _, pair in
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
