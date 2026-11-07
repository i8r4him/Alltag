//
//  OnboardingFlow.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// The full-screen onboarding: top bar (back, progress, Skip), the current
/// step, and the main button.
struct OnboardingFlow: View {
    /// Called after the profile is saved (Skip or "Start learning").
    var onFinish: () -> Void = {}

    @State private var model: OnboardingModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.services) private var services
    @Environment(AppState.self) private var appState
    @Environment(\.accessibilityReduceMotion) private var systemReduceMotion
    @Query private var profiles: [UserProfile]

    init(model: OnboardingModel = OnboardingModel(), onFinish: @escaping () -> Void = {}) {
        _model = State(initialValue: model)
        self.onFinish = onFinish
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
                .opacity(model.showsTopBar ? 1 : 0)
                .disabled(!model.showsTopBar)
                .accessibilityHidden(!model.showsTopBar)

            ZStack {
                stepView
                    .padding(.top, 28)
                    .id(model.step)
                    .transition(transition)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .clipped()

            Button(action: continueTapped) {
                Text(model.continueTitle)
            }
            .buttonStyle(.primary)
            .disabled(!model.canContinue)
            .padding(.bottom, 8)
        }
        .padding(.horizontal, Spacing.onboarding)
        .background(.screenBackground)
        .animation(Motion.push(reduceMotion: reducesMotion), value: model.step)
        .sensoryFeedback(.selection, trigger: model.step)
    }

    private var topBar: some View {
        HStack(spacing: 12) {
            GlassButton(systemImage: "chevron.left", accessibilityLabel: "Back", diameter: 40) {
                model.goBack()
            }
            ProgressSegments(total: OnboardingModel.segmentCount, completed: model.completedSegments, height: 4)
            Button("Skip", action: finish)
                .textRole(.bodySmall)
                .foregroundStyle(.secondary)
                .frame(minHeight: Spacing.minTouchTarget)
        }
        .padding(.top, 4)
    }

    @ViewBuilder
    private var stepView: some View {
        switch model.step {
        case .welcome: WelcomeStep()
        case .name: NameStep(model: model, onSubmit: continueTapped)
        case .why: WhyStep(model: model)
        case .level: LevelStep(model: model)
        case .dailyTime: DailyTimeStep(model: model)
        case .interests: InterestsStep(model: model)
        case .permissions: PermissionsStep(model: model)
        case .summary: SummaryStep(model: model)
        }
    }

    private var reducesMotion: Bool {
        appState.reducesMotion(system: systemReduceMotion)
    }

    private var transition: AnyTransition {
        guard !reducesMotion else { return .opacity }
        let offset = Motion.pushOffset
        return .asymmetric(
            insertion: .offset(x: model.isMovingForward ? offset : -offset).combined(with: .opacity),
            removal: .opacity
        )
    }

    private func continueTapped() {
        if model.advance() { finish() }
    }

    private func finish() {
        model.save(in: modelContext, existing: profiles.first)
        let model = model
        let notifications = services.notifications
        Task { try? await model.scheduleReminder(with: notifications) }
        appState.dismissFullScreen()
        onFinish()
    }
}

#Preview("First run") {
    OnboardingFlow()
        .environment(AppState())
        .modelContainer(try! AlltagStore.makeContainer(inMemory: true)) // swiftlint:disable:this force_try
}
