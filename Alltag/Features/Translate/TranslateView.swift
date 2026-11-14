//
//  TranslateView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI
import Translation

/// Translate: English ⇄ German with word-by-word, tone and examples.
///
/// Opened from "How do I say …?" (`isAsking`), it is the same screen ready to
/// be asked: the keyboard is up, there is no welcome, and Return translates.
struct TranslateView: View {
    let initialText: String?
    var isAsking = false
    @Environment(\.services) private var services
    @State private var model: TranslateModel?

    var body: some View {
        Group {
            if let model {
                TranslateContent(model: model, isAsking: isAsking)
            } else {
                Color.clear
            }
        }
        .readableContentMargins()
        .background(.screenBackground)
        .onAppear {
            if model == nil { model = TranslateModel(text: initialText, services: services) }
        }
    }
}

private struct TranslateContent: View {
    @Bindable var model: TranslateModel
    var isAsking = false
    @FocusState private var isFieldFocused: Bool
    @Environment(\.modelContext) private var modelContext
    @Query private var savedTranslations: [SavedTranslation]
    @State private var toast: ToastMessage?
    /// Set to ask the system to download the translation languages.
    @State private var download: TranslationSession.Configuration?
    @State private var translationTask: Task<Void, Never>?
    /// Counts Translate, swap and prompt taps, for the medium haptic.
    @State private var taps = 0
    /// Set by swap: translate the new text once changing it has cleared the old result.
    @State private var translatesAfterSwap = false

    private var isEmpty: Bool { model.input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    private var prompt: LocalizedStringResource { isAsking ? "How do I say …?" : "Type or paste text" }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.grid) {
                if !isAsking, !model.hasAttempted, model.result == nil {
                    TranslateWelcome { text in
                        taps += 1
                        model.input = text
                    }
                }
                input
                states
                if let result = model.result {
                    VStack(alignment: .leading, spacing: Spacing.grid) {
                        TranslateDetails(result: result) { german in
                            Task { await model.listen(to: german) }
                        }
                        if model.isExplaining || model.isTranslating {
                            Label("Adding word by word, tone and examples…", systemImage: "sparkles")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 4)
                        }
                    }
                    .padding(.top, 14)
                }
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.bottom, 32)
            .animation(.easeOut(duration: 0.25), value: model.result)
        }
        .scrollDismissesKeyboard(.interactively)
        .skyBackground()
        .fontDesign(.rounded)
        // A title like Learn's other screens; the languages and the swap are in the card.
        .navigationTitle(isAsking ? Text("How do I say …?") : Text("Translate"))
        .toolbarTitleDisplayMode(.inlineLarge)
        .onAppear { if isAsking { isFieldFocused = true } }
        .translationTask(download) { session in
            do {
                try await session.prepareTranslation()
                await model.languagesDownloaded()
            } catch {
                toast = ToastMessage(text: "The languages couldn't be downloaded. Try again later.",
                                     systemImage: "exclamationmark.triangle")
            }
            download = nil
        }
        .task {
            if !model.input.isEmpty { await model.translate() }
        }
        .onChange(of: model.input) { _, input in
            translationTask?.cancel()
            model.clearResult()
            if translatesAfterSwap {
                translatesAfterSwap = false
                translate()
                return
            }
            // When asking, Return sends the question: the field grows with the text,
            // so Return would otherwise only start a new line.
            if isAsking, input.hasSuffix("\n") {
                model.input = input.trimmingCharacters(in: .newlines)
                isFieldFocused = false
                translate()
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
        .toast($toast)
    }

    // MARK: Input and result

    /// Both languages on one card with the swap between them, and the big button under it.
    @ViewBuilder
    private var input: some View {
        TranslatePairCard(text: $model.input, sourceLabel: model.sourceLabel, resultLabel: model.resultLabel,
                          prompt: prompt, isFocused: $isFieldFocused, result: model.resultText,
                          isTranslating: model.isTranslating, actions: actions, onSwap: swap)
        translateButton
    }

    private var translateButton: some View {
        Button(isAsking ? "Say it in German" : "Translate", systemImage: isAsking ? "quote.bubble.fill" : "translate") {
            translate()
        }
        .buttonStyle(.primary)
        .disabled(isEmpty || model.isTranslating)
    }

    private var actions: TranslateResultActions {
        TranslateResultActions(isSaved: model.isSaved(in: savedTranslations)) { slowly in
            Task { await model.listen(slowly: slowly) }
        } onToggleSave: {
            let saved = model.toggleSave(in: modelContext)
            toast = saved ? ToastMessage(text: "Saved to Memory", systemImage: "bookmark.fill")
                : ToastMessage(text: "Removed from Memory", systemImage: "bookmark.slash.fill")
        }
    }

    /// The languages to download, or why it didn't work. While it translates, the card shows a spinner.
    @ViewBuilder
    private var states: some View {
        if let languages = model.missingLanguages {
            StateCard(systemImage: "arrow.down.circle", title: Text("Download the languages"),
                      explanation: Text("Download English and German once to translate privately on your iPhone."),
                      action: StateCard.Action(title: "Download languages", systemImage: "arrow.down.circle") {
                          download = TranslationSession.Configuration(source: languages.source, target: languages.target)
                      })
        } else if let failure = model.failure {
            CloudFailureCard(failure: failure, failedTitle: Text("Couldn’t translate it"), onRetry: translate)
                .transition(.opacity)
        }
    }

    private func translate() {
        guard !isEmpty else { return }
        taps += 1
        isFieldFocused = false
        translationTask?.cancel()
        translationTask = Task { await model.translate() }
    }

    /// Swaps the languages and, when there was a translation, translates the other way at once.
    private func swap() {
        taps += 1
        translatesAfterSwap = model.result != nil
        model.swap()
    }
}

#Preview {
    NavigationStack {
        TranslateView(initialText: nil)
    }
    .modelContainer(AlltagStore.preview)
}
