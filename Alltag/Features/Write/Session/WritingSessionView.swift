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

    init(brief: WritingBrief, service: any WritingService) {
        _model = State(initialValue: WriteModel(brief: brief, service: service))
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
                        WritingTaskCard(model: model)
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
            .scrollEdgeEffectStyle(.soft, for: .all)
            .scrollIndicators(.hidden)
            .readableContentMargins()
            .skyBackground()
            .fontDesign(.rounded)
            .navigationTitle(Text(verbatim: model.brief.title))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "xmark") {
                        if model.phase == .checked || model.text.isEmpty { dismiss() } else { isConfirmingClose = true }
                    }
                }
            }
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
}

/// The task: the email to answer, the situation or question, the points, and a form's short fields.
private struct WritingTaskCard: View {
    @Bindable var model: WriteModel

    private var brief: WritingBrief { model.brief }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            TopicLengthText(level: brief.level, words: brief.words)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.accent)
            if let email = brief.email {
                ReceivedEmail(email: email, lineLimit: nil)
            }
            if !brief.situation.isEmpty {
                Text(verbatim: brief.situation)
                    .font(.title3.weight(.semibold))
                    .environment(\.locale, Locale(identifier: "de_DE"))
                    .fixedSize(horizontal: false, vertical: true)
            }
            if !brief.points.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(Array(brief.points.enumerated()), id: \.offset) { index, point in
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
            if brief.kind == .formalEmail {
                Text(verbatim: "Anrede und Gruß nicht vergessen.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            ForEach(brief.fields, id: \.self) { field in
                VStack(alignment: .leading, spacing: 6) {
                    Text(verbatim: field)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                    TextField(text: binding(for: field)) { Text(verbatim: field) }
                        .padding(.horizontal, 12)
                        .frame(height: 40)
                        .background(.fill.tertiary, in: .rect(cornerRadius: Radius.tile, style: .continuous))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    private func binding(for field: String) -> Binding<String> {
        Binding { model.fields[field] ?? "" } set: { model.fields[field] = $0 }
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
                    .foregroundStyle(model.hasEnoughWords ? Color.accent : Color.secondary)
                    .contentTransition(.numericText())
                Spacer()
                Text("Aim for about \(model.brief.words)")
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
    WritingSessionView(brief: WritingBrief(WritingContent.formalTasks[1], level: .a2), service: MockWritingService())
        .modelContainer(AlltagStore.preview)
}
