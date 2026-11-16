//
//  MistakeQuestionViews.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftData
import SwiftUI

/// One mistake to write correctly: what was said, with the wrong words underlined
/// in coral, and a field that starts with it, so the learner only changes what was
/// wrong. Checking shows the correct sentence and why; "Show the fix" counts as
/// not yet.
struct MistakeQuestionView: View {
    let model: MistakeRoundModel
    @Environment(\.modelContext) private var context
    @State private var written: String
    /// The learner asked for the fix instead of writing it.
    @State private var gaveUp = false
    @FocusState private var isFieldFocused: Bool

    init(model: MistakeRoundModel) {
        self.model = model
        _written = State(initialValue: model.question.said)
    }

    private var question: MistakeQuestion { model.question }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow(title: "FIX YOUR MISTAKES", tone: .mistake)
                    Text("Write it correctly")
                        .textRole(.title2)
                        .accessibilityAddTraits(.isHeader)
                    hint
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                said
                if model.hasAnswered {
                    fix
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    if let outcome = model.outcome {
                        MistakeAnswerCard(outcome: outcome)
                            .transition(.opacity)
                    }
                } else {
                    field
                    Button("Show the fix", systemImage: "eye", action: showFix)
                        .font(.subheadline.weight(.semibold))
                        .buttonStyle(.glass)
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 16)
            .animation(.easeOut(duration: 0.25), value: model.hasAnswered)
        }
        .scrollEdgeEffectStyle(.soft, for: .all)
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            Group {
                if model.hasAnswered {
                    Button { model.next() } label: { Text("Continue") }
                } else {
                    Button(action: check) { Text("Check") }
                        .disabled(written.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .buttonStyle(.primary)
            .padding(.bottom, 8)
        }
        .sensoryFeedback(trigger: model.wasRight) { _, right in
            right.map { $0 ? .success : .error }
        }
        .task { isFieldFocused = true }
    }

    private var hint: Text {
        MistakePractice.wrongWords(said: question.said, correction: question.correction).isEmpty
            ? Text("Write what you said the right way.")
            : Text("Change the underlined words.")
    }

    /// What was said, and where.
    private var said: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label {
                Text(verbatim: question.source).lineLimit(1)
            } icon: {
                Image(systemName: "waveform")
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.accent)
            MistakePractice.quote(said: question.said, correction: question.correction)
                .font(.title2.weight(.semibold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .environment(\.locale, Locale(identifier: "de"))
        .accessibilityElement(children: .combine)
    }

    /// The field, starting with what was said. Return checks it.
    private var field: some View {
        TextField("Your sentence", text: $written, axis: .vertical)
            .font(.title3)
            .lineLimit(1...5)
            .focused($isFieldFocused)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.sentences)
            .submitLabel(.done)
            .onChange(of: written) { _, text in
                // A vertical field takes Return as a new line; here it means "check".
                guard text.contains("\n") else { return }
                written = text.replacingOccurrences(of: "\n", with: "")
                check()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: Radius.hero, style: .continuous))
            .environment(\.locale, Locale(identifier: "de"))
    }

    /// After checking: the correct sentence, and what was written when it wasn't it.
    private var fix: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label {
                Text(verbatim: question.correction)
            } icon: {
                Image(systemName: "checkmark.circle.fill").foregroundStyle(.success)
            }
            .font(.title2.weight(.semibold))
            if model.wasRight == false, !gaveUp {
                Divider()
                VStack(alignment: .leading, spacing: 4) {
                    Text("You wrote")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.secondary)
                    MistakePractice.quote(said: written, correction: question.correction)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .environment(\.locale, Locale(identifier: "de"))
        .accessibilityElement(children: .combine)
    }

    private func check() {
        guard !model.hasAnswered, !written.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        isFieldFocused = false
        model.answer(MistakePractice.isFixed(written, correction: question.correction), in: context)
    }

    private func showFix() {
        guard !model.hasAnswered else { return }
        gaveUp = true
        isFieldFocused = false
        model.answer(false, in: context)
    }
}
