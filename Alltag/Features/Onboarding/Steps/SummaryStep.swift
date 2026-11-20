//
//  SummaryStep.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Step 7: a summary of the answers before starting.
struct SummaryStep: View {
    let model: OnboardingModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                Image(systemName: "sunset.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.accentFill)
                    .padding(.top, 32)
                    .accessibilityHidden(true)

                Text("You're set, \(model.trimmedName).")
                    .textRole(.title2)
                    .accessibilityAddTraits(.isHeader)

                VStack(spacing: 0) {
                    row("Learning", value: Text("German · \(model.level.title)"))
                    Divider()
                    row("Focus", value: Text(model.goal.title))
                    Divider()
                    row("Daily", value: dailyValue)
                    Divider()
                    row("From your day", value: Text("\(model.allowedCount) of 2 allowed"))
                }
                .padding(.horizontal, Spacing.card)
                .background(.surface, in: .rect(cornerRadius: Radius.innerCard, style: .continuous))

                Text("Your first step is waiting on Home. From now on, Alltag starts noticing words from your day.")
                    .textRole(.bodySmall)
                    .foregroundStyle(.secondary)
            }
        }
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
    }

    /// "10 min · evening"
    private var dailyValue: Text {
        let nudge = String(localized: model.nudgeTime.title).localizedLowercase
        return Text("\(Text(model.dailyTime.title)) · \(nudge)")
    }

    private func row(_ label: LocalizedStringResource, value: Text) -> some View {
        HStack {
            Text(label).foregroundStyle(.secondary)
            Spacer(minLength: 12)
            value.multilineTextAlignment(.trailing)
        }
        .textRole(.bodySmall)
        .frame(minHeight: 44)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    let model = OnboardingModel()
    model.name = "Mara"
    model.allowsNotifications = true
    return SummaryStep(model: model)
        .padding(.horizontal, Spacing.onboarding)
        .background(.screenBackground)
}
