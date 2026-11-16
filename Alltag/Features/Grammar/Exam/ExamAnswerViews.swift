//
//  ExamAnswerViews.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The answers of a choice question, one under the other on glass. The
/// picked one carries the theme colour; after checking, the right one turns
/// green, a wrong pick coral, and the rest fade.
struct ExamOptions: View {
    let model: ExamModel
    let options: [String]
    let answer: Int

    var body: some View {
        GlassEffectContainer(spacing: 12) {
            VStack(spacing: 12) {
                ForEach(options.indices, id: \.self) { index in
                    ExamOption(text: options[index], status: status(of: index)) { model.pick(index) }
                }
            }
        }
        .sensoryFeedback(.selection, trigger: model.picked)
    }

    private func status(of index: Int) -> ExamOption.Status {
        guard model.checked != nil else { return index == model.picked ? .picked : .open }
        if index == answer { return .right }
        return index == model.picked ? .wrong : .dimmed
    }
}

private struct ExamOption: View {
    enum Status { case open, picked, right, wrong, dimmed }

    let text: String
    let status: Status
    let action: () -> Void

    @ScaledMetric(relativeTo: .title3) private var minHeight: CGFloat = 60

    var body: some View {
        Button(action: action) {
            Text(verbatim: text)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)
                .environment(\.locale, Locale(identifier: "de"))
                .padding(.horizontal, 44)
                .frame(maxWidth: .infinity, minHeight: minHeight)
                .overlay(alignment: .trailing) {
                    Group {
                        switch status {
                        case .right: Image(systemName: "checkmark.circle.fill").foregroundStyle(.success)
                        case .wrong: Image(systemName: "xmark.circle.fill").foregroundStyle(.mistake)
                        case .open, .picked, .dimmed: EmptyView()
                        }
                    }
                    .font(.title3)
                    .padding(.trailing, 16)
                    .transition(.scale.combined(with: .opacity))
                }
                .background(background, in: shape)
                .overlay { shape.strokeBorder(border, lineWidth: 1.5) }
                .glassEffect(isOpen ? .regular.interactive() : .regular, in: shape)
                .opacity(status == .dimmed ? 0.45 : 1)
                .contentShape(shape)
        }
        .buttonStyle(.plain)
        // Not `.disabled`, which would dim the right and wrong answers too.
        .allowsHitTesting(isOpen)
        .accessibilityAddTraits(status == .picked ? .isSelected : [])
        .accessibilityValue(accessibilityValue)
        .animation(.easeOut(duration: 0.2), value: status)
    }

    private var isOpen: Bool { status == .open || status == .picked }
    private var shape: RoundedRectangle { RoundedRectangle(cornerRadius: 26, style: .continuous) }

    private var background: AnyShapeStyle {
        switch status {
        case .picked: AnyShapeStyle(.accentFill.opacity(0.18))
        case .right: AnyShapeStyle(.success.opacity(0.22))
        case .wrong: AnyShapeStyle(.mistake.opacity(0.22))
        case .open, .dimmed: AnyShapeStyle(.clear)
        }
    }

    private var border: AnyShapeStyle {
        switch status {
        case .picked: AnyShapeStyle(.accentFill.opacity(0.7))
        case .right: AnyShapeStyle(.success.opacity(0.6))
        case .wrong: AnyShapeStyle(.mistake.opacity(0.6))
        case .open, .dimmed: AnyShapeStyle(.clear)
        }
    }

    private var accessibilityValue: Text {
        switch status {
        case .right: Text("Correct")
        case .wrong: Text("Wrong")
        case .open, .picked, .dimmed: Text(verbatim: "")
        }
    }
}

/// The build question: tap tiles from the bank into the sentence, as in a
/// rule's "Try it". Not every tile belongs in the sentence.
struct ExamTiles: View {
    let model: ExamModel

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            sentence
            bank
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
        .animation(.easeOut(duration: 0.2), value: model.placed)
        .sensoryFeedback(.selection, trigger: model.placed)
    }

    private var sentence: some View {
        FlowLayout(spacing: 6) {
            if model.placed.isEmpty {
                Text("Tap the words in order")
                    .textRole(.bodySmall)
                    .foregroundStyle(.tertiary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 10)
            }
            ForEach(Array(model.placedWords.enumerated()), id: \.offset) { position, word in
                Button { model.remove(at: position) } label: { WordTile(word, style: .placed) }
                    .buttonStyle(.plain)
                    .accessibilityHint("Removes the word.")
                    .transition(.scale(scale: 0.8).combined(with: .opacity))
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, minHeight: 54, alignment: .leading)
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(borderColour, style: StrokeStyle(lineWidth: 1, dash: model.checked == nil ? [4, 3] : []))
        }
        .allowsHitTesting(model.checked == nil)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Your sentence")
    }

    private var bank: some View {
        FlowLayout(spacing: 6) {
            ForEach(model.words.indices, id: \.self) { index in
                Button { model.place(index) } label: { WordTile(model.words[index]) }
                    .buttonStyle(.plain)
                    .opacity(model.isUsed(index) ? 0.2 : 1)
                    .allowsHitTesting(!model.isUsed(index) && model.checked == nil)
                    .accessibilityHidden(model.isUsed(index))
            }
        }
    }

    private var borderColour: AnyShapeStyle {
        switch model.checked {
        case true?: AnyShapeStyle(.success)
        case false?: AnyShapeStyle(.mistake)
        case nil: AnyShapeStyle(.separator)
        }
    }
}

/// After checking: right or not, the right answer when it was missed, and why.
struct ExamFeedback: View {
    let question: ExamQuestion
    let isRight: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label {
                if isRight { Text("Right") } else { Text("Not quite") }
            } icon: {
                Image(systemName: isRight ? "checkmark.circle.fill" : "xmark.circle.fill")
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(isRight ? Color.success : Color.mistake)
            if !isRight, case let .build(_, answers) = question.kind, let answer = answers.first {
                Text(verbatim: "\(answer).")
                    .font(.title3.weight(.semibold))
                    .environment(\.locale, Locale(identifier: "de"))
            }
            Text(verbatim: question.explanation)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}
