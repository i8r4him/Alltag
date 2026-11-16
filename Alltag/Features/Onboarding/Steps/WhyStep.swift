//
//  WhyStep.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Step 2: why the learner is learning German.
struct WhyStep: View {
    @Bindable var model: OnboardingModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                StepHeader(title: "What brings you to German?",
                           subtitle: "This shapes the situations you rehearse and the words we notice.")
                VStack(spacing: 10) {
                    ForEach(Goal.allCases) { goal in
                        OptionCard(title: goal.title, subtitle: goal.subtitle,
                                   systemImage: goal.systemImage, isSelected: model.goal == goal) {
                            model.goal = goal
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
    }
}

#Preview {
    WhyStep(model: OnboardingModel())
        .padding(.horizontal, Spacing.onboarding)
        .background(.screenBackground)
}
