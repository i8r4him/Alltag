//
//  DailyTimeStep.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Step 4: daily practice time and when the reminder comes.
struct DailyTimeStep: View {
    @Bindable var model: OnboardingModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                StepHeader(title: "How much time on a normal day?",
                           subtitle: "Most of it happens in small moments anyway.")
                VStack(spacing: 10) {
                    ForEach(DailyTime.allCases) { time in
                        OptionCard(title: time.title, subtitle: time.subtitle, systemImage: time.systemImage,
                                   isSelected: model.dailyTime == time) {
                            model.dailyTime = time
                        }
                    }
                }
                Text("Best time for a nudge")
                    .textRole(.bodySmall)
                    .foregroundStyle(.secondary)
                HStack(spacing: 10) {
                    ForEach(NudgeTime.allCases) { time in
                        OptionCard(title: time.title, isSelected: model.nudgeTime == time) {
                            model.nudgeTime = time
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DailyTimeStep(model: OnboardingModel())
        .padding(.horizontal, Spacing.onboarding)
        .background(.screenBackground)
}
