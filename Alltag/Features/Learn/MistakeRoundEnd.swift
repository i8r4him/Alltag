//
//  MistakeRoundEnd.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftUI

/// The end of a round, before and after: every mistake as a card with what
/// was said, the correction under it, and when it comes back.
struct MistakeRoundEnd: View {
    let model: MistakeRoundModel
    /// More mistakes are due: offer another round.
    let hasMore: Bool
    let onAgain: () -> Void
    let onDone: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(model.fixed.count) of \(model.total) fixed")
                        .font(.title2.weight(.bold))
                        .accessibilityAddTraits(.isHeader)
                    Group {
                        if model.comingBack.isEmpty {
                            Text("Each one comes back a little later, until you know it.")
                        } else {
                            Text("The ones you missed come back next time.")
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 4)
                .padding(.top, 24)
                VStack(spacing: Spacing.grid) {
                    ForEach(model.outcomes) { card(for: $0) }
                }
            }
            .padding(.bottom, 16)
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                if hasMore {
                    Button(action: onAgain) { Text("Another round") }
                        .buttonStyle(.primary)
                    Button(action: onDone) {
                        Text("Done").font(.headline).frame(maxWidth: .infinity, minHeight: 34)
                    }
                    .buttonStyle(.glass)
                } else {
                    Button(action: onDone) { Text("Done") }
                        .buttonStyle(.primary)
                }
            }
            .padding(.bottom, 12)
        }
        .sensoryFeedback(.success, trigger: true)
    }

    private func card(for outcome: MistakeRoundModel.Outcome) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            MistakePractice.quote(said: outcome.question.said, correction: outcome.question.correction)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Label {
                Text(verbatim: outcome.question.correction)
            } icon: {
                Image(systemName: "arrow.turn.down.right").foregroundStyle(.accent)
            }
            .font(.title3.weight(.semibold))
            Label {
                MistakeWhen.outcome(outcome)
            } icon: {
                Image(systemName: outcome.wasRight ? "checkmark.circle.fill" : "arrow.uturn.backward.circle.fill")
                    .foregroundStyle(outcome.wasRight ? AnyShapeStyle(.success) : AnyShapeStyle(.mistake))
            }
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.secondary)
            .padding(.horizontal, 12)
            .frame(minHeight: 32)
            .background(.controlFill, in: .capsule)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .environment(\.locale, Locale(identifier: "de"))
        .accessibilityElement(children: .combine)
    }
}
