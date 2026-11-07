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
    @Environment(\.services) private var services
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
            if model == nil { model = ConversationModel(scenario: scenario, services: services) }
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
                Text(verbatim: model.scenario.goal)
                    .textRole(.meta)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.surface, in: .capsule)
                    .padding(.top, 8)

                TranscriptView(messages: model.messages, heardText: model.heardText)

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
            .readableWidth(Spacing.focusedWidth)
            .background(.screenBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbar }
            .animation(.easeOut(duration: 0.25), value: model.showsHint)
            .animation(.easeOut(duration: 0.25), value: model.mode)
        }
        .onChange(of: model.stateLabel) { _, label in
            if let label { AccessibilityNotification.Announcement(String(localized: label)).post() }
        }
        .onChange(of: model.mode) { _, mode in isFieldFocused = mode == .text }
        .onChange(of: model.isFinished) { _, finished in
            guard finished else { return }
            model.savePhrases(in: modelContext)
            showsSummary = true
        }
        .sheet(isPresented: $showsSummary) {
            SummarySheet(scenario: model.scenario, turns: model.turnCount, fixes: model.fixCount,
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
        ToolbarItem(placement: .topBarTrailing) {
            Picker("Mode", selection: $model.mode) {
                Label("Voice", systemImage: "mic").tag(ConversationModel.Mode.voice)
                Label("Keyboard", systemImage: "keyboard").tag(ConversationModel.Mode.text)
            }
            .pickerStyle(.segmented)
            .labelStyle(.iconOnly)
            .frame(width: 96)
        }
    }

    // MARK: Bottom controls

    private var voiceControls: some View {
        VStack(spacing: 12) {
            HStack {
                CircleGlassButton(title: "Type instead", systemImage: "keyboard", size: 48) { model.mode = .text }
                Spacer()
                Button { model.orbTapped() } label: {
                    VoiceOrb(state: model.phase, isFinished: model.isFinished)
                }
                .buttonStyle(.plain)
                // Not `.disabled`: that would dim the orb while thinking and speaking.
                .allowsHitTesting(model.canRespond || model.phase == .listening)
                .accessibilityLabel(Text(model.stateLabel ?? "Voice"))
                Spacer()
                hintButton(size: 48)
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
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.surface, in: .rect(cornerRadius: Radius.tile, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ConversationView(scenario: MockScenarios.dentist)
        .environment(AppState())
}
