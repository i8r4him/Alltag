//
//  ExamView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// A rule's exam, full screen like a round of Articles: an easy, a medium
/// and a hard question, each checked once, and the result at the end. All
/// three right solves the rule and opens the next one.
struct ExamView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var model: ExamModel

    init(rule: GrammarRule) {
        _model = State(initialValue: ExamModel(rule: rule))
    }

    var body: some View {
        NavigationStack {
            Group {
                if model.showsResult {
                    ExamResult(model: model) { dismiss() }
                        .transition(.opacity)
                } else if let question = model.current {
                    ExamQuestionView(model: model, question: question)
                        .id(model.index)
                        .transition(.opacity)
                }
            }
            .animation(.easeOut(duration: 0.3), value: model.index)
            .animation(.easeOut(duration: 0.3), value: model.showsResult)
            .padding(.horizontal, Spacing.onboarding)
            .readableWidth(Spacing.focusedWidth)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .fontDesign(.rounded)
            .skyBackground()
            .navigationTitle(Text("Exam"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "xmark") { dismiss() }
                }
                ToolbarItem(placement: .principal) {
                    if !model.showsResult {
                        ProgressSegments(total: model.questions.count, completed: model.results.count, height: 4)
                            .frame(width: 220)
                    }
                }
            }
        }
    }
}

extension ExamQuestion.Difficulty {
    var label: LocalizedStringResource {
        switch self {
        case .easy: "Easy"
        case .medium: "Medium"
        case .hard: "Hard"
        }
    }
}

/// One question: how hard it is, what to do, the German, the answer, and
/// after checking why the right answer is right.
private struct ExamQuestionView: View {
    let model: ExamModel
    let question: ExamQuestion
    @Environment(\.modelContext) private var context

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                header
                switch question.kind {
                case let .choice(options, answer):
                    ExamOptions(model: model, options: options, answer: answer)
                case .build:
                    ExamTiles(model: model)
                }
                if let isRight = model.checked {
                    ExamFeedback(question: question, isRight: isRight)
                        .transition(.opacity)
                }
            }
            .padding(.bottom, 16)
            .animation(.easeOut(duration: 0.25), value: model.checked)
        }
        .scrollEdgeEffectStyle(.soft, for: .all)
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            button
                .buttonStyle(.primary)
                .padding(.bottom, 8)
        }
        .sensoryFeedback(trigger: model.checked) { _, checked in
            guard let checked else { return nil }
            return checked ? .success : .error
        }
    }

    private var header: some View {
        VStack(spacing: 10) {
            Text("Question \(model.index + 1) of \(model.questions.count) · \(Text(question.difficulty.label))")
                .textRole(.eyebrow)
                .foregroundStyle(.accent)
                .accessibilityAddTraits(.isHeader)
            Text(verbatim: question.prompt)
                .font(.title3)
                .foregroundStyle(.secondary)
            if let sentence = question.sentence {
                Text(verbatim: sentence)
                    .font(.title.weight(.bold))
                    .fixedSize(horizontal: false, vertical: true)
                    .environment(\.locale, Locale(identifier: "de"))
            }
            if let hint = question.hint {
                Text(verbatim: hint)
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)
                    .frame(minHeight: 32)
                    .background(.controlFill, in: .capsule)
                    .environment(\.locale, Locale(identifier: "de"))
            }
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(.top, 28)
    }

    /// "Check" until the answer is checked, then on to the next question or the result.
    @ViewBuilder
    private var button: some View {
        if model.checked == nil {
            Button { model.check(in: context) } label: { Text("Check") }
                .disabled(!model.canCheck)
        } else if model.isFinished {
            Button { model.next() } label: { Text("See the result") }
        } else {
            Button { model.next() } label: { Text("Next question") }
        }
    }
}

/// The end of the exam, laid out like the end of a round of Articles: the
/// score, each question with how it went, and the big button for what comes next.
private struct ExamResult: View {
    let model: ExamModel
    let onDone: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(model.score) of \(model.questions.count) right")
                        .font(.title2.weight(.bold))
                        .accessibilityAddTraits(.isHeader)
                    summary
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 4)
                .padding(.top, 24)

                if model.isPassed {
                    ScenarioArtwork(systemImage: "checkmark.seal.fill")
                        .frame(width: 120, height: 120)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }

                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(model.questions.enumerated()), id: \.element.id) { index, question in
                        if index > 0 { Divider() }
                        row(for: question, isRight: model.results.indices.contains(index) && model.results[index])
                    }
                }
                .padding(.horizontal, Spacing.cardLarge)
                .padding(.vertical, 6)
                .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
            }
            .padding(.bottom, 16)
        }
        .scrollEdgeEffectStyle(.soft, for: .all)
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                if model.isPassed {
                    Button(action: onDone) { Text("Done") }
                        .buttonStyle(.primary)
                } else {
                    Button { model.restart() } label: { Text("Try again") }
                        .buttonStyle(.primary)
                    Button(action: onDone) {
                        Text("Read the rule again").font(.headline).frame(maxWidth: .infinity, minHeight: 34)
                    }
                    .buttonStyle(.glass)
                }
            }
            .padding(.bottom, 12)
        }
    }

    @ViewBuilder
    private var summary: some View {
        if !model.isPassed {
            Text("Get all three right to solve the rule.")
        } else if let next = GrammarProgress.rule(after: model.rule) {
            Text("The rule is solved. “\(next.title)” is open now.")
        } else {
            Text("The rule is solved.")
        }
    }

    private func row(for question: ExamQuestion, isRight: Bool) -> some View {
        HStack(spacing: 12) {
            Text(question.difficulty.label)
                .font(.title3.weight(.semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: isRight ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.title3)
                .foregroundStyle(isRight ? AnyShapeStyle(.success) : AnyShapeStyle(.mistake))
                .accessibilityLabel(isRight ? Text("Right") : Text("Wrong"))
        }
        .padding(.vertical, 14)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ExamView(rule: MockRules.accusative)
        .modelContainer(AlltagStore.preview)
}
