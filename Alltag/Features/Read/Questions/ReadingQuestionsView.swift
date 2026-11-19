//
//  ReadingQuestionsView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The three questions after a text, one at a time, and the result. Shown on
/// a sheet (answers one under the other) or on a card at the bottom of the
/// reader (answers as chips).
struct ReadingQuestionsView: View {
    enum Style {
        /// Full-width answers, the app's big button: for the sheet.
        case rows
        /// Answers as chips, the small button: for the card at the bottom.
        case chips
    }

    let quiz: ReadingQuiz
    let style: Style
    let onNext: () -> Void
    let onClose: () -> Void

    var body: some View {
        Group {
            if quiz.isFinished {
                ReadingQuizResult(quiz: quiz, style: style, onClose: onClose)
            } else if let question = quiz.current {
                questionView(question)
            }
        }
        .animation(.easeOut(duration: 0.25), value: quiz.index)
        .animation(.easeOut(duration: 0.25), value: quiz.isFinished)
        .sensoryFeedback(.success, trigger: quiz.isAnswered) { _, answered in answered }
        .sensoryFeedback(.error, trigger: quiz.wrongPicks.count) { old, new in new > old }
    }

    private func questionView(_ question: ReadingQuestion) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Question \(quiz.index + 1) of \(quiz.questions.count)")
                    .font(.footnote.weight(.heavy))
                    .textCase(.uppercase)
                    .foregroundStyle(.accent)
                Spacer()
                QuizPips(count: quiz.questions.count, done: quiz.firstTries.count)
            }
            Text(verbatim: question.prompt)
                .font(.title3.weight(.bold))
                .fixedSize(horizontal: false, vertical: true)
            options(question)
            if quiz.isAnswered {
                nextButton
            } else if !quiz.wrongPicks.isEmpty {
                Label("The answer is in the lit sentence. Try again.", systemImage: "arrow.up")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .id(quiz.index)
        .transition(.opacity.combined(with: .move(edge: .trailing)))
    }

    @ViewBuilder
    private func options(_ question: ReadingQuestion) -> some View {
        switch style {
        case .rows:
            GlassEffectContainer(spacing: 10) {
                VStack(spacing: 10) {
                    ForEach(question.options.indices, id: \.self) { option in
                        QuizOption(text: question.options[option], status: status(of: option, in: question),
                                   isChip: false) { quiz.pick(option) }
                    }
                }
            }
        case .chips:
            GlassEffectContainer(spacing: 8) {
                FlowLayout(spacing: 8) {
                    ForEach(question.options.indices, id: \.self) { option in
                        QuizOption(text: question.options[option], status: status(of: option, in: question),
                                   isChip: true) { quiz.pick(option) }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var nextButton: some View {
        let title: LocalizedStringKey = quiz.isLastQuestion ? "See the result" : "Next question"
        switch style {
        case .rows:
            Button(action: onNext) { Text(title) }
                .buttonStyle(.primary)
        case .chips:
            Button(action: onNext) { Text(title) }
                .buttonStyle(.primaryCompact)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    private func status(of option: Int, in question: ReadingQuestion) -> QuizOption.Status {
        if quiz.wrongPicks.contains(option) { return .wrong }
        if quiz.isAnswered { return option == question.answer ? .right : .dimmed }
        return .open
    }
}

/// One answer on glass: green once it is the right one, coral when it was a wrong pick.
private struct QuizOption: View {
    enum Status { case open, right, wrong, dimmed }

    let text: String
    let status: Status
    let isChip: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                switch status {
                case .right: Image(systemName: "checkmark").foregroundStyle(.success)
                case .wrong: Image(systemName: "xmark").foregroundStyle(.mistake)
                case .open, .dimmed: EmptyView()
                }
                Text(verbatim: text)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .font(isChip ? .subheadline.weight(.semibold) : .body.weight(.semibold))
            .foregroundStyle(.primary)
            .padding(.horizontal, isChip ? 14 : 18)
            .padding(.vertical, isChip ? 9 : 15)
            .frame(maxWidth: isChip ? nil : .infinity, alignment: .leading)
            .background(tint.opacity(0.16), in: shape)
            .overlay { shape.strokeBorder(tint.opacity(status == .right || status == .wrong ? 0.6 : 0), lineWidth: 1.5) }
            .glassEffect(status == .open ? .regular.interactive() : .regular, in: shape)
            .opacity(status == .dimmed ? 0.45 : 1)
            .contentShape(shape)
        }
        .buttonStyle(.plain)
        // Not `.disabled`, which would dim the right and wrong answers too.
        .allowsHitTesting(status == .open)
        .accessibilityValue(accessibilityValue)
        .animation(.easeOut(duration: 0.2), value: status)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: isChip ? 18 : 22, style: .continuous)
    }

    private var tint: Color {
        switch status {
        case .right: .success
        case .wrong: .mistake
        case .open, .dimmed: .clear
        }
    }

    private var accessibilityValue: Text {
        switch status {
        case .right: Text("Right")
        case .wrong: Text("Wrong")
        case .open, .dimmed: Text(verbatim: "")
        }
    }
}

/// A short bar per question, lit once it is answered.
private struct QuizPips: View {
    let count: Int
    let done: Int

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(index < done ? Color.accentFill : Color.primary.opacity(0.18))
                    .frame(width: 22, height: 5)
            }
        }
        .accessibilityHidden(true)
    }
}

/// After the last question: read, or once more.
private struct ReadingQuizResult: View {
    let quiz: ReadingQuiz
    let style: ReadingQuestionsView.Style
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: quiz.isPassed ? "checkmark.seal.fill" : "arrow.counterclockwise.circle.fill")
                .font(.system(size: style == .rows ? 52 : 38))
                .foregroundStyle(.accent)
                .symbolEffect(.bounce, value: quiz.isFinished)
                .accessibilityHidden(true)
            VStack(spacing: 4) {
                if quiz.isPassed {
                    Text("All three right")
                        .font(.title3.weight(.bold))
                    Text("This text counts as read.")
                        .foregroundStyle(.secondary)
                } else {
                    Text("\(quiz.score) of \(quiz.questions.count) right at the first try")
                        .font(.title3.weight(.bold))
                    Text("Read the text once more, then try again.")
                        .foregroundStyle(.secondary)
                }
            }
            .multilineTextAlignment(.center)
            .accessibilityElement(children: .combine)
            if quiz.isPassed {
                button("Done", action: onClose)
            } else {
                button("Try again") { quiz.restart() }
            }
        }
        .frame(maxWidth: .infinity)
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }

    @ViewBuilder
    private func button(_ title: LocalizedStringKey, action: @escaping () -> Void) -> some View {
        if style == .rows {
            Button(action: action) { Text(title) }
                .buttonStyle(.primary)
        } else {
            Button(action: action) { Text(title) }
                .buttonStyle(.primaryCompact)
        }
    }
}
