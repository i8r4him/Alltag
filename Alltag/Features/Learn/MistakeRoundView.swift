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

/// One mistake: the task, the way to fix it, and the explanation after the answer.
private struct MistakeQuestionView: View {
    let model: MistakeRoundModel
    @Environment(\.modelContext) private var context
    // TEMPORARY (#251): the way the mistake is fixed.
    @AppStorage(MistakeDesign.question.key) private var stored = 1

    /// The chosen way, where this mistake allows it: a missing word can't be
    /// tapped, a long sentence makes too many tiles, a rewording has no gap.
    /// Then it is the two choices.
    private var design: Int {
        let question = model.question
        return switch MistakeDesign.question.clamped(stored) {
        case 2 where question.canSpot: 2
        case 3 where question.canBuild: 3
        case 4 where question.canFill: 4
        case 5 where question.canType: 5
        case 6: 6
        default: 1
        }
    }

    private var title: LocalizedStringResource {
        switch design {
        case 2: "Tap the word that’s wrong"
        case 3: "Put it right"
        case 4: "Fill the gap"
        case 5: "Type what’s missing"
        case 6: "Do you know the fix?"
        default: "Which sounds natural?"
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow(title: "FIX YOUR MISTAKES", tone: .mistake)
                    Text(title)
                        .textRole(.title2)
                        .accessibilityAddTraits(.isHeader)
                }
                // Not once answered: the answer belongs to the design it was given in.
                if !model.hasAnswered { MistakeDesignSwitcher(.question) }
                Group {
                    switch design {
                    case 2: MistakeSpot(question: model.question, onAnswer: answer)
                    case 3: MistakeBuild(question: model.question, onAnswer: answer)
                    case 4: MistakeFill(question: model.question, onAnswer: answer)
                    case 5: MistakeType(question: model.question, onAnswer: answer)
                    case 6: MistakeFlash(question: model.question, onAnswer: answer)
                    default: MistakeChoice(question: model.question, onAnswer: answer)
                    }
                }
                .id(design)
                if let outcome = model.outcome {
                    MistakeAnswerCard(outcome: outcome)
                        .transition(.opacity)
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 16)
            .animation(.easeOut(duration: 0.25), value: model.hasAnswered)
        }
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

/// After the answer: whether it was fixed, the correction, why, and when it comes back.
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
            Text(verbatim: outcome.question.correction)
                .font(.title3.weight(.semibold))
                .environment(\.locale, Locale(identifier: "de"))
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
