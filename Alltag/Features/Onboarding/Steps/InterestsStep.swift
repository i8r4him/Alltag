//
//  InterestsStep.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Step 5: topics for briefings and examples. Shared with Profile.
struct InterestsStep: View {
    @Bindable var model: OnboardingModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                StepHeader(title: "What do you care about?",
                           subtitle: "Your briefings and examples will be about these.")
                FlowLayout(spacing: 8) {
                    ForEach(Interest.allCases) { interest in
                        Button {
                            model.toggle(interest)
                        } label: {
                            Label {
                                Text(interest.title)
                            } icon: {
                                Image(systemName: interest.systemImage)
                            }
                        }
                        .buttonStyle(.toggleChip(isOn: model.interests.contains(interest)))
                    }
                }
                .sensoryFeedback(.selection, trigger: model.interests)
            }
        }
    }
}

#Preview {
    InterestsStep(model: OnboardingModel())
        .padding(.horizontal, Spacing.onboarding)
        .background(.screenBackground)
}
