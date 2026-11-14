//
//  WritingSessionView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Writing one text: the task on top, the text below it, the big button above
/// the keyboard. Checking turns the page into the correction, which arrives
/// sentence by sentence; the fixes are saved as soon as it is complete.
struct WritingSessionView: View {
    @State private var model: WriteModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @FocusState private var isEditing: Bool
    @State private var isConfirmingClose = false
    @State private var checkTaps = 0

    init(task: WritingTask, service: any WritingService) {
        _model = State(initialValue: WriteModel(task: task, service: service))
    }

    private var isShowingResult: Bool { model.phase == .checking || model.phase == .checked }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if isShowingResult {
                        WritingResultView(model: model)
                            .transition(.opacity)
                    } else {
                        WritingTaskCard(task: model.task) { phrase in add(phrase) }
                        WritingEditor(model: model, isEditing: $isEditing)
                        if case .failed(let failure) = model.phase {
                            CloudFailureCard(failure: failure, failedTitle: Text("Couldn’t check your text")) { check() }
                        }
                    }
                }
                .padding(.horizontal, Spacing.screen)
                .padding(.top, 8)
                .padding(.bottom, 24)
                .animation(.easeOut(duration: 0.25), value: isShowingResult)
            }
            .scrollDismissesKeyboard(.interactively)
            .readableContentMargins()
            .skyBackground()
            .fontDesign(.rounded)
            .navigationTitle(Text(verbatim: model.task.title))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbar }
            .safeAreaInset(edge: .bottom) { bottomBar }
        }
        .onChange(of: model.phase) { _, phase in
            if phase == .checked { model.save(in: modelContext) }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: checkTaps)
        .sensoryFeedback(.success, trigger: model.phase) { _, phase in phase == .checked }
        .confirmationDialog("Leave without checking?", isPresented: $isConfirmingClose, titleVisibility: .visible) {
            Button("Leave", role: .destructive) { dismiss() }
        } message: {
            Text("Your text isn’t saved until it is checked.")
        }
    }

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button("Close", systemImage: "xmark") {
                if model.phase == .checked || model.text.isEmpty { dismiss() } else { isConfirmingClose = true }
            }
        }
        if isShowingResult {
            ToolbarItem(placement: .topBarTrailing) { WritingDesignSwitcher() }
        }
    }

    @ViewBuilder
    private var bottomBar: some View {
        GlassEffectContainer(spacing: 12) {
            switch model.phase {
            case .writing, .failed:
                Button(action: check) {
                    Label("Check my text", systemImage: "checkmark.circle")
                }
                .buttonStyle(.primary)
                .disabled(!model.canCheck)
            case .checking:
                Button {} label: {
                    Label("Checking …", systemImage: "ellipsis")
                }
                .buttonStyle(.primary)
                .disabled(true)
            case .checked:
                HStack(spacing: 12) {
                    Button { model.edit() } label: {
                        Label("Edit", systemImage: "pencil")
                            .font(.headline)
                            .frame(height: 56)
                            .padding(.horizontal, 8)
                    }
                    .buttonStyle(.glass)
                    Button("Done", systemImage: "checkmark") { dismiss() }
                        .buttonStyle(.primary)
                }
            }
        }
        .padding(.horizontal, Spacing.screen)
        .padding(.bottom, 8)
    }

    private func check() {
        checkTaps += 1
        isEditing = false
        Task { await model.runCheck() }
    }

    /// A tapped phrase goes at the end of the text, on its own line after a greeting.
    private func add(_ phrase: WritingTask.Phrase) {
        let german = phrase.german.replacingOccurrences(of: " …", with: " ")
        if model.text.isEmpty {
            model.text = german
        } else {
            let separator = model.text.hasSuffix("\n") || model.text.hasSuffix(" ") ? "" : (model.text.hasSuffix(",") ? "\n" : " ")
            model.text += separator + german
        }
        isEditing = true
    }
}

/// The task: the situation, who it is to, the three points and the phrases.
private struct WritingTaskCard: View {
    let task: WritingTask
    let onPhrase: (WritingTask.Phrase) -> Void

    @State private var showsPhrases = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(verbatim: task.situation)
                .font(.title3)
                .fixedSize(horizontal: false, vertical: true)
            if !task.recipient.isEmpty {
                HStack(spacing: 8) {
                    Label { Text(verbatim: task.recipient) } icon: { Image(systemName: "person.crop.circle") }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                    Spacer(minLength: 0)
                    RegisterBadge(register: task.register)
                }
            }
            if !task.points.isEmpty {
                Divider()
                points
            }
            if !task.phrases.isEmpty {
                Divider()
                DisclosureGroup(isExpanded: $showsPhrases.animation(.snappy)) {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(task.phrases, id: \.german) { phrase in
                            Button { onPhrase(phrase) } label: {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(verbatim: phrase.german)
                                        .font(.body.weight(.medium))
                                        .foregroundStyle(.primary)
                                    Text(verbatim: phrase.english)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(.rect)
                            }
                            .buttonStyle(.plain)
                            .accessibilityHint(Text("Adds it to your text."))
                        }
                        Text("Tap a phrase to add it to your text.")
                            .font(.footnote)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.top, 10)
                } label: {
                    Label("Useful phrases", systemImage: "text.quote")
                        .font(.subheadline.weight(.semibold))
                }
                .sensoryFeedback(.selection, trigger: showsPhrases)
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    private var points: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your text should")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            ForEach(Array(task.points.enumerated()), id: \.offset) { index, point in
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Text(verbatim: "\(index + 1)")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.accent)
                        .frame(width: 24, height: 24)
                        .background(.accent.opacity(0.14), in: .circle)
                    Text(verbatim: point)
                }
                .accessibilityElement(children: .combine)
            }
        }
    }
}

/// The learner's text, in a field that grows, with its word count.
private struct WritingEditor: View {
    @Bindable var model: WriteModel
    var isEditing: FocusState<Bool>.Binding

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextEditor(text: $model.text)
                .focused(isEditing)
                .font(.title3)
                .frame(minHeight: 200)
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                // The learner's own mistakes are the point: no autocorrect fixing them first.
                .autocorrectionDisabled()
                .textInputAutocapitalization(.sentences)
                .environment(\.locale, Locale(identifier: "de"))
                .overlay(alignment: .topLeading) {
                    if model.text.isEmpty {
                        Text("Write in German here.")
                            .font(.title3)
                            .foregroundStyle(.tertiary)
                            .padding(.top, 8)
                            .padding(.leading, 5)
                            .allowsHitTesting(false)
                    }
                }
                .accessibilityLabel(Text("Your text"))
            HStack {
                Text("^[\(model.wordCount) word](inflect: true)")
                    .foregroundStyle(model.isInRange ? Color.accent : Color.secondary)
                    .contentTransition(.numericText())
                Spacer()
                Text("Aim for \(model.task.minWords)–\(model.task.maxWords)")
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline.weight(.medium))
            .monospacedDigit()
            .animation(.snappy, value: model.wordCount)
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

#Preview {
    WritingSessionView(task: WritingTasks.a2[2], service: MockWritingService())
        .modelContainer(AlltagStore.preview)
}
