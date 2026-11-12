//
//  SixtySecondsView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 12.11.26.
//

import SwiftData
import SwiftUI

/// 60 seconds: a topic is chosen at random, the learner talks about it for a
/// minute, and then sees what they said with the mistakes fixed.
struct SixtySecondsView: View {
    var level: Level = .a1
    @Environment(\.services) private var services
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @State private var model: SixtySecondsModel?

    var body: some View {
        NavigationStack {
            Group {
                if let model {
                    SixtySecondsContent(model: model,
                                        onPractise: { appState.present(.activity(.mistakes)) },
                                        onDone: { appState.dismissFullScreen() })
                } else {
                    Color.clear
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .readableWidth(Spacing.focusedWidth)
            .fontDesign(.rounded)
            .skyBackground()
            .navigationTitle("60 seconds")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "xmark") { appState.dismissFullScreen() }
                }
            }
        }
        .onAppear {
            if model == nil { model = SixtySecondsModel(services: services, level: level) }
        }
        .onChange(of: model?.phase) { _, phase in
            if phase == .done { model?.save(in: modelContext) }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .background { model?.finish() }
        }
        .onDisappear { model?.stop() }
    }
}

private struct SixtySecondsContent: View {
    @Bindable var model: SixtySecondsModel
    let onPractise: () -> Void
    let onDone: () -> Void

    var body: some View {
        Group {
            switch model.phase {
            case .picking, .ready: choosing
            case .talking, .checking: talking
            case .done: SixtySecondsResult(model: model, onPractise: onPractise, onDone: onDone)
            }
        }
        .animation(.easeOut(duration: 0.3), value: model.phase)
        .toast($model.notice)
    }

    // MARK: Choosing the topic

    private var choosing: some View {
        VStack(spacing: 0) {
            Spacer()
            Text("Your topic")
                .font(.subheadline.weight(.semibold))
                .textCase(.uppercase)
                .tracking(0.8)
                .foregroundStyle(.accent)
            TopicReel(titles: model.reelTitles) { model.topicChosen() }
                .id(model.topic.id)
                .padding(.horizontal, 24)
            VStack(spacing: 6) {
                Text(model.topic.english)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                Text(verbatim: model.topic.question)
                    .font(.body)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
                    .environment(\.locale, Locale(identifier: "de"))
            }
            .padding(.horizontal, 24)
            .opacity(model.phase == .ready ? 1 : 0)
            Spacer()
            Spacer()
            VStack(spacing: 12) {
                Button { model.start() } label: {
                    Label("Start talking", systemImage: "waveform")
                }
                .buttonStyle(.primary)
                Button { model.pickAnother() } label: {
                    Label("Another topic", systemImage: "shuffle")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 34)
                }
                .buttonStyle(.glass)
                Text("You have 60 seconds. Say whatever comes to mind.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .disabled(model.phase != .ready)
            .opacity(model.phase == .ready ? 1 : 0.35)
            .padding(.horizontal, 22)
            .padding(.bottom, 12)
        }
    }

    // MARK: Talking

    private var talking: some View {
        VStack(spacing: 0) {
            VStack(spacing: 4) {
                Text(verbatim: model.topic.title)
                    .font(.title2.weight(.bold))
                    .multilineTextAlignment(.center)
                Text(verbatim: model.topic.question)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .environment(\.locale, Locale(identifier: "de"))
            .padding(.horizontal, 24)
            .padding(.top, 12)

            Spacer()
            ZStack {
                CompanionOrb(dynamics: OrbDynamics(state: model.phase == .talking ? .listening : .thinking), isLive: true)
                    .frame(width: 190, height: 190)
                Circle()
                    .trim(from: 0, to: 1 - model.progress)
                    .stroke(.accent, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 214, height: 214)
                    .animation(.linear(duration: 1), value: model.secondsLeft)
                    .opacity(model.phase == .talking ? 1 : 0)
            }
            .accessibilityHidden(true)
            Group {
                if model.phase == .talking {
                    Text(model.secondsLeft, format: .number)
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .contentTransition(.numericText(countsDown: true))
                        .animation(.default, value: model.secondsLeft)
                        .accessibilityLabel(Text("\(model.secondsLeft) seconds left"))
                } else {
                    Label { Text("Checking your German…") } icon: { ProgressView() }
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(height: 70)
            .padding(.top, 8)

            // The last words heard, so the learner sees that it is listening.
            Text(verbatim: model.transcript)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .truncationMode(.head)
                .frame(maxWidth: .infinity, minHeight: 72, alignment: .top)
                .padding(.horizontal, 24)
                .environment(\.locale, Locale(identifier: "de"))
            Spacer()

            Button { model.finish() } label: {
                Label("I'm done", systemImage: "checkmark")
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 34)
            }
            .buttonStyle(.glass)
            .disabled(model.phase != .talking)
            .opacity(model.phase == .talking ? 1 : 0)
            .padding(.horizontal, 22)
            .padding(.bottom, 12)
        }
    }
}

/// After the minute: every sentence, with its fix where there is one.
private struct SixtySecondsResult: View {
    let model: SixtySecondsModel
    let onPractise: () -> Void
    let onDone: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(verbatim: model.topic.title)
                        .font(.title2.weight(.bold))
                        .accessibilityAddTraits(.isHeader)
                    summary
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 4)

                VStack(alignment: .leading, spacing: 14) {
                    ForEach(model.lines) { line in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(verbatim: line.german)
                                .font(.title3)
                                .textSelection(.enabled)
                                .environment(\.locale, Locale(identifier: "de"))
                            if let feedback = line.feedback, feedback.kind != .good {
                                FeedbackCard(feedback: feedback)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(Spacing.cardLarge)
                .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))

                if !model.canCheck {
                    Label("Turn on Apple Intelligence to have your mistakes fixed.", systemImage: "sparkles")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 4)
                }
            }
            .padding(Spacing.screen)
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                if model.fixCount > 0 {
                    Button(action: onPractise) { Text("Practise your fixes") }
                        .buttonStyle(.primary)
                    Button(action: onDone) {
                        Text("Done")
                            .font(.headline)
                            .frame(maxWidth: .infinity, minHeight: 34)
                    }
                    .buttonStyle(.glass)
                } else {
                    Button(action: onDone) { Text("Done") }
                        .buttonStyle(.primary)
                }
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 12)
        }
    }

    private var summary: Text {
        if model.fixCount > 0 {
            Text("""
                ^[\(model.lines.count) sentence](inflect: true) · \
                ^[\(model.fixCount) thing](inflect: true) to fix, saved to Fix your mistakes
                """)
        } else {
            Text("^[\(model.lines.count) sentence](inflect: true)")
        }
    }
}

#Preview {
    SixtySecondsView(level: .b1)
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
