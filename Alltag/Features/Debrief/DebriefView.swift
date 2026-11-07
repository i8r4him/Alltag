//
//  DebriefView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Debrief a moment from the learner's day: find the words they were missing.
///
/// The model is created up front (not in `onAppear`) so the first frame
/// already contains the ScrollView; otherwise the navigation bar settles on
/// a small inline title instead of the large one.
struct DebriefView: View {
    @State private var model: DebriefModel

    init(services: AppServices) {
        _model = State(initialValue: DebriefModel(services: services))
    }

    var body: some View {
        DebriefContent(model: model)
    }
}

private struct DebriefContent: View {
    @Bindable var model: DebriefModel
    @Environment(\.services) private var services
    @Environment(\.modelContext) private var modelContext
    @Query private var phrases: [Phrase]
    @State private var toast: ToastMessage?
    @FocusState private var isEditing: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                inputCard
                switch model.phase {
                case .input:
                    Button { find() } label: { Text("Find the words") }
                        .buttonStyle(.primary)
                        .disabled(!model.canFind)
                case .thinking:
                    HStack(spacing: 10) {
                        ProgressView().tint(.accentFill)
                        Text("Finding the words…")
                            .textRole(.bodySmall)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, minHeight: 50)
                case .result:
                    if let result = model.result {
                        resultSection(result).transition(.opacity)
                    }
                }
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.bottom, 32)
            .animation(.easeOut(duration: 0.3), value: model.phase)
        }
        .scrollDismissesKeyboard(.interactively)
        .readableContentMargins()
        .background(.screenBackground)
        .navigationTitle("Debrief")
        .navigationBarTitleDisplayMode(.large)
        // The navigation subtitle can't show inline images, so no calendar symbol here.
        .navigationSubtitle(Text("\(model.moment.event) · \(model.moment.time)"))
        .toast($toast)
    }

    private var inputCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("What did you want to say? Any language is fine.")
                .textRole(.meta)
                .foregroundStyle(.secondary)
            TextField("Type what you wanted to say", text: $model.input, axis: .vertical)
                .font(.title3)
                .lineLimit(3...8)
                .focused($isEditing)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }

    @ViewBuilder
    private func resultSection(_ result: Debrief) -> some View {
        let isSaved = model.isSaved(in: phrases)
        VStack(alignment: .leading, spacing: 12) {
            Eyebrow(title: "Next time, say")
                .padding(.horizontal, 4)
                .padding(.top, 8)
            ForEach(result.phrases, id: \.german) { phrase in
                PhraseCard(phrase: phrase) {
                    Task { await services.voice.speak(phrase.german, rate: .normal) }
                }
            }

            Text(tipText(result.grammarTip))
                .textRole(.bodySmall)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay {
                    RoundedRectangle(cornerRadius: Radius.innerCard, style: .continuous)
                        .strokeBorder(.separator, lineWidth: 0.5)
                }

            Button {
                if model.toggleSave(in: modelContext) {
                    toast = ToastMessage(text: "Added to your phrasebook", systemImage: "text.book.closed.fill")
                }
            } label: {
                Text(isSaved ? "Saved to phrasebook ✓" : "Save to phrasebook")
                    .textRole(.cardTitle)
                    .foregroundStyle(isSaved ? AnyShapeStyle(.primary) : AnyShapeStyle(.onAccent))
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(isSaved ? AnyShapeStyle(.controlFill) : AnyShapeStyle(.accentFill), in: .capsule)
                    .contentShape(.capsule)
            }
            .buttonStyle(.card)

            Text("A sample answer for now. Live debriefs will use on-device language models.")
                .textRole(.caption)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
        }
    }

    /// The bold part of the tip in the primary colour, the rest secondary.
    private func tipText(_ text: String) -> AttributedString {
        var tip = DebriefModel.styledTip(text)
        for run in tip.runs where run.inlinePresentationIntent == .stronglyEmphasized {
            tip[run.range].foregroundColor = .primary
        }
        return tip
    }

    private func find() {
        isEditing = false
        Task { await model.findWords() }
    }
}

/// A suggested phrase; tap to hear it.
private struct PhraseCard: View {
    let phrase: Debrief.Example
    let onListen: () -> Void

    var body: some View {
        Button(action: onListen) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(verbatim: phrase.german)
                        .font(.system(.title3, weight: .semibold))
                        .foregroundStyle(.primary)
                    Text(verbatim: phrase.english)
                        .textRole(.bodySmall)
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.leading)
                Spacer(minLength: 8)
                Image(systemName: "speaker.wave.2")
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(.surface, in: .rect(cornerRadius: Radius.innerCard, style: .continuous))
            .contentShape(.rect(cornerRadius: Radius.innerCard, style: .continuous))
        }
        .buttonStyle(.card)
        .accessibilityHint("Plays the phrase.")
    }
}

#Preview {
    NavigationStack { DebriefView(services: .mock()) }
        .modelContainer(AlltagStore.preview)
}
