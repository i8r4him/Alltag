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
    /// Today's orb, when the learner tapped it to come here: it moves to its place as the page fades in.
    var launch: OrbLaunch?
    @Environment(\.services) private var services
    @Environment(AppState.self) private var appState
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.modelContext) private var modelContext
    @State private var model: ConversationModel?
    /// Today's orb has reached its place, so the page's own orb shows.
    @State private var hasLanded = false
    /// The page fades in around the moving orb.
    @State private var isShown = false

    var body: some View {
        Group {
            if let model {
                ConversationContent(model: model)
            } else {
                Color.clear
            }
        }
        .background(.screenBackground)
        .opacity(launch != nil && !isShown ? 0 : 1)
        .overlayPreferenceValue(OrbSlotKey.self) { slot in
            if let launch, !hasLanded {
                OrbFlight(launch: launch, target: slot) { hasLanded = true }
            }
        }
        .environment(\.orbIsLanding, launch != nil && !hasLanded)
        .presentationBackground(.clear)
        .onAppear {
            withAnimation(.easeOut(duration: 0.55).delay(0.1)) { isShown = true }
            if model == nil {
                let model = ConversationModel(scenario: scenario, services: services,
                                              usesCloudVoice: appState.settings.usesCloudForPro, level: level)
                model.holdsToTalk = appState.settings.holdsToTalk
                self.model = model
                // Free talk starts straight away: the learner tapped the companion to talk.
                // A soft chime first, before the microphone takes over the audio.
                if scenario.isLiveOnly, model.canRespond {
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
        .onChange(of: appState.settings.holdsToTalk) { _, holds in
            model?.holdsToTalk = holds
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

                if let problem = model.problem {
                    LiveProblemView(problem: problem, onRetry: { model.retryLive() }, onDone: { appState.dismissFullScreen() })
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
            guard review == .done else { return }
            model.saveMistakes(in: modelContext)
            model.updateHistory()
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
        if !model.scenario.isLiveOnly {
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
                if model.scenario.isLiveOnly {
                    Color.clear.frame(width: 48, height: 48)
                } else {
                    CircleGlassButton(title: "Type instead", systemImage: "keyboard", size: 48) { model.mode = .text }
                }
                Spacer()
                TalkOrb(model: model)
                    .anchorPreference(key: OrbSlotKey.self, value: .bounds) { $0 }
                Spacer()
                if model.showsFinishButton {
                    CircleGlassButton(title: "Finish", systemImage: "checkmark", size: 48) { model.finishCloudConversation() }
                } else if model.scenario.isLiveOnly {
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
            if !model.isFinished {
                TalkModePicker()
            }
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

/// Hands-free or hold to talk, remembered for the next conversation.
private struct TalkModePicker: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        Picker("How you talk", selection: Bindable(appState.settings).holdsToTalk) {
            Text("Hands-free").tag(false)
            Text("Hold to talk").tag(true)
        }
        .pickerStyle(.segmented)
        .frame(maxWidth: 260)
        .sensoryFeedback(.selection, trigger: appState.settings.holdsToTalk)
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
/// learner's voice goes to Google.
private struct CloudConsentCard: View {
    let onAllow: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label { Text("Talk with the live voice") } icon: { Image(systemName: "waveform") }
                .font(.headline)
                .foregroundStyle(.accent)
            Text("To hear and answer you, Alltag sends your voice to Google while you talk. You can turn this off in Settings.")
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
