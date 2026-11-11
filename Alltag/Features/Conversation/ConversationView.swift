//
//  ConversationView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// A full-screen conversation for one scenario.
struct ConversationView: View {
    let scenario: Scenario
    var level: Level = .a1
    @Environment(\.services) private var services
    @Environment(AppState.self) private var appState
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.modelContext) private var modelContext
    @State private var model: ConversationModel?

    var body: some View {
        Group {
            if let model {
                ConversationContent(model: model)
            } else {
                Color.clear
            }
        }
        .background(.screenBackground)
        .onAppear {
            if model == nil {
                let model = ConversationModel(scenario: scenario, services: services,
                                              usesCloudVoice: appState.settings.usesCloudForPro, level: level)
                self.model = model
                // Free talk starts straight away: the learner tapped the companion to talk.
                // A soft chime first, before the microphone takes over the audio.
                if scenario.isFreeTalk, model.canRespond {
                    SoundEffects.play(.focus)
                    Task {
                        try? await Task.sleep(for: .milliseconds(450))
                        if model.canRespond { model.orbTapped() }
                    }
                }
            }
        }
        .onChange(of: appState.settings.usesCloudForPro) { _, allowed in
            model?.setCloudVoiceConsent(allowed)
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .background { model?.suspendCloudVoice() }
        }
        .onDisappear {
            model?.stop()
            model?.recordPractice(in: modelContext)
        }
    }
}

private struct ConversationContent: View {
    @Bindable var model: ConversationModel
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    @FocusState private var isFieldFocused: Bool
    @State private var showsSummary = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if !model.scenario.goal.isEmpty {
                    Text(verbatim: model.scenario.goal)
                        .textRole(.meta)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .glassEffect(.regular, in: .capsule)
                        .padding(.top, 8)
                }

                if model.hasReachedLimit {
                    LiveLimitView { appState.dismissFullScreen() }
                } else {
                    talking
                }
            }
            .readableWidth(Spacing.focusedWidth)
            .fontDesign(.rounded)
            .skyBackground()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbar }
            .animation(.easeOut(duration: 0.25), value: model.showsHint)
            .animation(.easeOut(duration: 0.25), value: model.mode)
        }
        .onChange(of: model.stateLabel) { _, label in
            if let label { AccessibilityNotification.Announcement(String(localized: label)).post() }
        }
        .onChange(of: model.mode) { _, mode in isFieldFocused = mode == .text }
        .toast($model.notice)
        .onChange(of: model.isFinished) { _, finished in
            guard finished else { return }
            if model.finishedLiveConversation, model.turnCount == 0 {
                appState.dismissFullScreen()
                return
            }
            model.savePhrases(in: modelContext)
            model.saveMistakes(in: modelContext)
            model.recordPractice(in: modelContext)
            showsSummary = true
        }
        .onChange(of: model.liveReview) { _, review in
            if review == .done { model.saveMistakes(in: modelContext) }
        }
        .sheet(isPresented: $showsSummary) {
            SummarySheet(scenario: model.scenario, turns: model.turnCount, fixes: model.fixCount,
                         wasLive: model.finishedLiveConversation,
                         review: model.liveReview,
                         onPractise: {
                             showsSummary = false
                             appState.present(.activity(.mistakes))
                         },
                         onDone: {
                             showsSummary = false
                             appState.dismissFullScreen()
                         })
        }
    }

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("End conversation", systemImage: "xmark") {
                model.stop()
                appState.dismissFullScreen()
            }
        }
        ToolbarItem(placement: .principal) {
            VStack(spacing: 1) {
                Text(verbatim: model.scenario.title)
                    .textRole(.bodySmall)
                    .fontWeight(.semibold)
                Text(verbatim: model.scenario.meta)
                    .textRole(.caption)
                    .foregroundStyle(.secondary)
            }
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isHeader)
        }
        if !model.scenario.isFreeTalk {
            ToolbarItem(placement: .topBarTrailing) {
                modePicker
            }
        }
    }

    /// Voice or keyboard. Free talk is voice only, so it has none.
    private var modePicker: some View {
        Picker("Mode", selection: $model.mode) {
            Label("Voice", systemImage: "mic").tag(ConversationModel.Mode.voice)
            Label("Keyboard", systemImage: "keyboard").tag(ConversationModel.Mode.text)
        }
        .pickerStyle(.segmented)
        .labelStyle(.iconOnly)
        .frame(width: 96)
    }

    /// The transcript and the controls under it.
    @ViewBuilder private var talking: some View {
        TranscriptView(messages: model.messages, heardText: model.heardText)

        if model.needsCloudConsent {
            CloudConsentCard {
                appState.settings.usesCloudForPro = true
                model.setCloudVoiceConsent(true)
                SoundEffects.play(.focus)
                Task {
                    try? await Task.sleep(for: .milliseconds(450))
                    model.orbTapped()
                }
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 12)
        }

        if model.showsHint, let line = model.expectedLine {
            HintCard(german: line.german)
                .padding(.horizontal, 22)
                .padding(.bottom, 12)
                .transition(.opacity)
        }

        switch model.mode {
        case .voice: voiceControls
        case .text: textControls
        }
    }

    // MARK: Bottom controls

    private var voiceControls: some View {
        VStack(spacing: 12) {
            HStack {
                if model.scenario.isFreeTalk {
                    Color.clear.frame(width: 48, height: 48)
                } else {
                    CircleGlassButton(title: "Type instead", systemImage: "keyboard", size: 48) { model.mode = .text }
                }
                Spacer()
                Button { model.orbTapped() } label: {
                    CompanionOrb(dynamics: OrbDynamics(state: model.phase), isLive: !model.isFinished)
                        .frame(width: 150, height: 150)
                        .scaleEffect(model.phase == .listening ? 1.06 : 1)
                        .animation(.spring(duration: 0.5), value: model.phase)
                }
                .buttonStyle(.plain)
                // Not `.disabled`: that would dim the orb while thinking and speaking.
                .allowsHitTesting(model.isUsingCloudVoice || model.canRespond || model.phase == .listening)
                .accessibilityLabel(Text(model.isUsingCloudVoice ? "End conversation" : model.stateLabel ?? "Voice"))
                Spacer()
                if model.scenario.isFreeTalk {
                    Color.clear.frame(width: 48, height: 48)
                } else {
                    hintButton(size: 48)
                }
            }
            Group {
                if let label = model.stateLabel { Text(label) }
            }
            .textRole(.bodySmall)
            .foregroundStyle(.secondary)
            .frame(height: 20)
            .accessibilityHidden(true)
        }
        .padding(.horizontal, 28)
        .padding(.top, 4)
        .padding(.bottom, 12)
    }

    private var textControls: some View {
        HStack(spacing: 8) {
            hintButton(size: 44)
            HStack(spacing: 6) {
                TextField("Antworte auf Deutsch…", text: $model.draft)
                    .textRole(.body)
                    .focused($isFieldFocused)
                    .submitLabel(.send)
                    .onSubmit(send)
                    .environment(\.locale, Locale(identifier: "de"))
                Button("Send", systemImage: "arrow.up", action: send)
                    .labelStyle(.iconOnly)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.onAccent)
                    .frame(width: 36, height: 36)
                    .background(.accentFill, in: .circle)
                    .disabled(!model.canRespond)
                    .opacity(model.canRespond ? 1 : 0.4)
            }
            .padding(.leading, 16)
            .padding(.trailing, 6)
            .frame(minHeight: 48)
            .glassEffect(.regular, in: .capsule)
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 12)
    }

    private func hintButton(size: CGFloat) -> some View {
        CircleGlassButton(title: "Show a hint", systemImage: "lightbulb", size: size) { model.showsHint.toggle() }
            .disabled(model.expectedLine == nil)
    }

    private func send() {
        Task { await model.send() }
    }
}

/// A round button in the native glass style, sized by its icon frame.
private struct CircleGlassButton: View {
    let title: LocalizedStringResource
    let systemImage: String
    let size: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.title3)
                // `.glass` adds its own padding around the label.
                .frame(width: size - 14, height: size - 14)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        .accessibilityLabel(Text(title))
    }
}

/// "TRY SAYING" with the expected German line.
/// Free talk needs the live voice: asks once, in the conversation, before the
/// learner's voice goes to OpenAI.
private struct CloudConsentCard: View {
    let onAllow: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label { Text("Talk with the live voice") } icon: { Image(systemName: "waveform") }
                .font(.headline)
                .foregroundStyle(.accent)
            Text("To hear and answer you, Alltag sends your voice to OpenAI while you talk. You can turn this off in Settings.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Button(action: onAllow) {
                Text("Allow and start")
            }
            .buttonStyle(.primary)
        }
        .padding(Spacing.card)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }
}

private struct HintCard: View {
    let german: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Try saying")
                .textRole(.caption)
                .textCase(.uppercase)
                .tracking(0.6)
                .foregroundStyle(.accent)
            Text(verbatim: german)
                .textRole(.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.card)
        .background {
            RoundedRectangle(cornerRadius: Radius.card, style: .continuous)
                .fill(.surface)
                .overlay {
                    RoundedRectangle(cornerRadius: Radius.card, style: .continuous)
                        .strokeBorder(.white.opacity(0.06), lineWidth: 1)
                }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ConversationView(scenario: MockScenarios.dentist)
        .environment(AppState())
}
