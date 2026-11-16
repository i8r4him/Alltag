//
//  LevelStep.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Step 3: the learner's level, picked directly or found with one question.
struct LevelStep: View {
    @Bindable var model: OnboardingModel
    var question: PlacementQuestion = MockPlacement.question

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                StepHeader(title: "How is your German today?",
                           subtitle: "A rough guess is fine — we adjust as you go.")
                if model.isPlacing {
                    placement
                        .transition(.opacity)
                } else {
                    levels
                        .transition(.opacity)
                }
            }
            .animation(.easeOut(duration: 0.3), value: model.isPlacing)
            .animation(.easeOut(duration: 0.3), value: model.placementAnswer)
        }
        .scrollEdgeEffectStyle(.soft, for: .all)
    }

    private var levels: some View {
        VStack(spacing: 10) {
            ForEach(Level.selectable) { level in
                OptionCard(title: Text(verbatim: level.title), subtitle: Text(level.selfDescription),
                           isSelected: model.level == level) {
                    model.level = level
                }
            }
            Button("Not sure? Find out in one question", systemImage: "bubble.left.and.text.bubble.right") {
                model.startPlacement()
            }
            .buttonStyle(.outline)
            .padding(.top, 12)
        }
    }

    private var placement: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Companion")
                    .textRole(.caption)
                    .textCase(.uppercase)
                    .tracking(0.8)
                    .foregroundStyle(.tertiary)
                Text(verbatim: question.question)
                    .textRole(.aiLine)
                Text(question.instruction)
                    .textRole(.bodySmall)
                    .foregroundStyle(.secondary)
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
            .accessibilityElement(children: .combine)

            ForEach(question.answers, id: \.self) { answer in
                OptionCard(title: Text(verbatim: answer.german), isSelected: model.placementAnswer == answer) {
                    model.choosePlacement(answer)
                }
            }

            if let answer = model.placementAnswer {
                Text(MockPlacement.confirmation(for: answer.level))
                    .textRole(.bodySmall)
                    .foregroundStyle(.success)
                    .padding(.top, 4)
                    .transition(.opacity)
            }
        }
    }
}

#Preview("Levels") {
    LevelStep(model: OnboardingModel())
        .padding(.horizontal, Spacing.onboarding)
        .background(.screenBackground)
}

#Preview("Placement") {
    let model = OnboardingModel()
    model.startPlacement()
    return LevelStep(model: model)
        .padding(.horizontal, Spacing.onboarding)
        .background(.screenBackground)
}
