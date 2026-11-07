//
//  WordOrderTask.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// "Try it": build the sentence from tiles, check it, then mark the rule solved.
struct WordOrderTask: View {
    let model: RuleModel
    @Environment(\.modelContext) private var modelContext
    @Query private var solved: [SolvedRule]
    @State private var toast: ToastMessage?

    private var isSolved: Bool { model.isSolved(in: solved) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 14) {
                Text(verbatim: model.rule.taskPrompt)
                    .textRole(.bodySmall)
                    .foregroundStyle(.secondary)
                answerArea
                bank
                feedback
                HStack(spacing: 8) {
                    Button("Reset") { model.reset() }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .controlSize(.large)
                        .tint(.primary)
                    Button { model.check() } label: { Text("Check").frame(maxWidth: .infinity) }
                        .buttonStyle(.primaryCompact)
                        .disabled(!model.canCheck)
                }
            }
            .padding(18)
            .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))

            if model.result == .right {
                solveButton.transition(.opacity)
            }
        }
        .animation(.easeOut(duration: 0.25), value: model.result)
        .animation(.easeOut(duration: 0.2), value: model.placed)
        .sensoryFeedback(trigger: model.result) { _, result in
            switch result {
            case .right: .success
            case .wrong: .error
            case nil: nil
            }
        }
        .toast($toast)
    }

    // MARK: Parts

    private var answerArea: some View {
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
                .strokeBorder(borderColor, style: StrokeStyle(lineWidth: 1, dash: model.result == nil ? [4, 3] : []))
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Your sentence")
    }

    private var bank: some View {
        FlowLayout(spacing: 6) {
            ForEach(model.words.indices, id: \.self) { index in
                Button { model.place(index) } label: { WordTile(model.words[index]) }
                    .buttonStyle(.plain)
                    .opacity(model.isUsed(index) ? 0.2 : 1)
                    .allowsHitTesting(!model.isUsed(index))
                    .accessibilityHidden(model.isUsed(index))
            }
        }
    }

    @ViewBuilder
    private var feedback: some View {
        switch model.result {
        case .right:
            Label("Exactly right.", systemImage: "checkmark.circle.fill")
                .textRole(.bodySmall)
                .foregroundStyle(.success)
        case .wrong:
            Text("Not quite. Look where the highlighted word sits in step 2.")
                .textRole(.bodySmall)
                .foregroundStyle(.mistake)
        case nil:
            EmptyView()
        }
    }

    private var solveButton: some View {
        Button {
            if model.toggleSolved(in: modelContext) {
                toast = ToastMessage(text: "Marked as solved")
            }
        } label: {
            Text(isSolved ? "Solved ✓" : "Mark as solved")
                .textRole(.cardTitle)
                // The green is light in dark mode and dark in light mode.
                .foregroundStyle(isSolved ? AnyShapeStyle(.primary) : AnyShapeStyle(Color(uiColor: .systemBackground)))
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(isSolved ? AnyShapeStyle(.controlFill) : AnyShapeStyle(.success), in: .capsule)
                .contentShape(.capsule)
        }
        .buttonStyle(.card)
        .accessibilityHint(isSolved ? Text("Marks the rule as not solved.") : Text("Marks the rule as solved."))
    }

    private var borderColor: AnyShapeStyle {
        switch model.result {
        case .right: AnyShapeStyle(.success)
        case .wrong: AnyShapeStyle(.mistake)
        case nil: AnyShapeStyle(.separator)
        }
    }
}
