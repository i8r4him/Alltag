//
//  NameStep.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Step 1: the learner's first name (required) and native language.
struct NameStep: View {
    @Bindable var model: OnboardingModel
    /// Return in the name field continues, like the main button.
    let onSubmit: () -> Void

    @FocusState private var isNameFocused: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                StepHeader(title: "First, what should we call you?")

                TextField("Your first name", text: $model.name)
                    .font(.title3)
                    .textContentType(.givenName)
                    .autocorrectionDisabled()
                    .submitLabel(.continue)
                    .focused($isNameFocused)
                    .onSubmit(onSubmit)
                    .padding(.horizontal, Spacing.card)
                    .frame(minHeight: 56)
                    .background(.surface, in: .rect(cornerRadius: Radius.tile, style: .continuous))

                Text("You're learning **German**. What do you speak already?")
                    .textRole(.bodySmall)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                    ForEach(NativeLanguage.allCases) { language in
                        OptionCard(title: language.title, isSelected: model.nativeLanguage == language) {
                            model.nativeLanguage = language
                        }
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .onAppear {
            if model.trimmedName.isEmpty { isNameFocused = true }
        }
    }
}

#Preview {
    NameStep(model: OnboardingModel()) {}
        .padding(.horizontal, Spacing.onboarding)
        .background(.screenBackground)
}
