//
//  MistakeRoundView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftData
import SwiftUI

/// Fix your mistakes, full screen: the mistakes due now, one at a time, the
/// explanation after each answer, and what was fixed at the end. With
/// nothing due it says so, and when the next one comes back.
struct MistakeRoundView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppState.self) private var appState
    @State private var model: MistakeRoundModel?
    /// Counts the rounds, so "Another round" starts with fresh views.
    @State private var round = 0

    var body: some View {
        NavigationStack {
            Group {
                if let model, model.total > 0 {
                    if model.isDone {
                        MistakeRoundEnd(model: model, hasMore: !MistakePractice.round(in: context).isEmpty,
                                        onAgain: start, onDone: appState.dismissFullScreen)
                    } else {
                        MistakeQuestionView(model: model)
                            .id(model.index)
                            .transition(.opacity)
                    }
                } else if model != nil {
                    nothingDue
                }
            }
            .id(round)
            .padding(.horizontal, Spacing.onboarding)
            .readableWidth(Spacing.focusedWidth)
            .frame(maxHeight: .infinity, alignment: .top)
            .fontDesign(.rounded)
            .skyBackground()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "xmark") { appState.dismissFullScreen() }
                }
                if let model, model.total > 0 {
                    ToolbarItem(placement: .principal) { progress(model) }
                }
            }
            .animation(.easeOut(duration: 0.3), value: model?.isDone)
        }
        .onAppear { if model == nil { start() } }
        // Another round answers the tap; the first one was started by the card's own.
        .sensoryFeedback(.impact(weight: .medium), trigger: round) { _, round in round > 1 }
    }

    /// Starts a round with the mistakes due now.
    private func start() {
        model = MistakeRoundModel(items: MistakePractice.round(in: context))
        round += 1
    }

    private func progress(_ model: MistakeRoundModel) -> some View {
        HStack(spacing: 4) {
            ForEach(0..<model.total, id: \.self) { segment in
                Capsule()
                    .fill(model.isSegmentFilled(segment) ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.surfaceTertiary))
                    .frame(height: 4)
            }
        }
        .frame(width: 220)
        .animation(.easeOut(duration: 0.3), value: model.hasAnswered)
        .accessibilityElement()
        .accessibilityLabel("Progress")
        .accessibilityValue(Text("\(model.index + 1) of \(model.total)"))
    }

    /// Opened with nothing due (from Memory, a session, the end of 60 seconds).
    private var nothingDue: some View {
        let all = (try? context.fetch(MistakePractice.practisable)) ?? []
        return Group {
            if all.isEmpty {
                StateCard(systemImage: "checkmark.seal", title: Text("Nothing to fix"),
                          explanation: Text("Mistakes from your conversations and 60 seconds land here."))
            } else {
                StateCard(systemImage: "checkmark.seal", title: Text("All fixed for now"),
                          explanation: MistakeWhen.nextReturn(MistakePractice.nextReturn(all)))
            }
        }
        .padding(.top, 24)
    }
}

/// One mistake as a flashcard, and the explanation after the answer.
private struct MistakeQuestionView: View {
    let model: MistakeRoundModel
    @Environment(\.modelContext) private var context
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow(title: "FIX YOUR MISTAKES", tone: .mistake)
                    Text("Do you know the fix?")
                        .textRole(.title2)
                        .accessibilityAddTraits(.isHeader)
                }
                MistakeFlash(question: model.question, onAnswer: answer)
                if let outcome = model.outcome {
                    MistakeAnswerCard(outcome: outcome)
                        .transition(.opacity)
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 16)
            .animation(.easeOut(duration: 0.25), value: model.hasAnswered)
        }
        .scrollEdgeEffectStyle(.soft, for: .all)
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            if model.hasAnswered {
                Button { model.next() } label: { Text("Continue") }
                    .buttonStyle(.primary)
                    .padding(.bottom, 8)
                    .transition(.opacity)
            }
        }
        .sensoryFeedback(trigger: model.wasRight) { _, right in
            right.map { $0 ? .success : .error }
        }
    }

    private func answer(_ right: Bool) {
        model.answer(right, in: context)
    }
}

/// After the answer: whether it was fixed, why it is said that way, and when it comes back.
/// The correction itself is on the card above.
struct MistakeAnswerCard: View {
    let outcome: MistakeRoundModel.Outcome

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label {
                Text(outcome.wasRight ? "Fixed" : "Not yet")
            } icon: {
                Image(systemName: outcome.wasRight ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(outcome.wasRight ? AnyShapeStyle(.success) : AnyShapeStyle(.mistake))
            }
            .font(.headline)
            if !outcome.question.explanation.isEmpty {
                Text(verbatim: outcome.question.explanation)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Label { MistakeWhen.outcome(outcome) } icon: { Image(systemName: "calendar") }
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.top, 2)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    MistakeRoundView()
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
