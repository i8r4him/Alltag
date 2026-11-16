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
    /// Counts Translate, swap, prompt, clear, paste and copy taps, for the medium haptic.
    @State private var taps = 0
    /// Set by swap: translate the new text once changing it has cleared the old result.
    @State private var translatesAfterSwap = false
    @State private var isShowingHistory = false
    /// The screen has appeared before: text another screen supplied is translated only the first time.
    @State private var hasOpened = false
    @Namespace private var transition

    private var isEmpty: Bool { model.input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    private var prompt: LocalizedStringResource { isAsking ? "How do I say …?" : "Type or paste text" }
    /// Nothing has been asked yet: the welcome, or whatever takes its place.
    private var isStart: Bool { !isAsking && !model.hasAttempted && model.result == nil }
    private var isLoadingResult: Bool { model.isTranslating && model.result == nil }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.grid) {
                input
                states
                details
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.bottom, 32)
            .animation(.easeOut(duration: 0.25), value: model.result)
        }
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            // Like a message composer: the button stays above the keyboard.
            translateButton
                .padding(.horizontal, Spacing.screen)
                .padding(.vertical, 8)
        }
        .skyBackground()
        .fontDesign(.rounded)
        // A title like Learn's other screens; the languages and the swap are in the card.
        .navigationTitle(isAsking ? Text("How do I say …?") : Text("Translate"))
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("History", systemImage: "clock.arrow.circlepath") { isShowingHistory = true }
            }
            .matchedTransitionSource(id: Self.historyTransition, in: transition)
        }
        // The history grows out of its button and shrinks back into it.
        .sheet(isPresented: $isShowingHistory) {
            TranslateHistorySheet(history: model.history, onChoose: show)
                .navigationTransition(.zoom(sourceID: Self.historyTransition, in: transition))
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: isShowingHistory) { _, isShowing in isShowing }
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
            // Once, for text another screen supplied. Not again when the tab comes back:
            // that would ask the server a second time and write the details afresh.
            // Not awaited here either: leaving the tab cancels this task, not the translation.
            guard !hasOpened else { return }
            hasOpened = true
            if !model.input.isEmpty { translationTask = Task { await model.translate() } }
        }
        .onChange(of: model.input) { _, input in inputChanged(to: input) }
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
        .toast($toast)
    }

    private static let historyTransition = "history"
}

// MARK: - Input and result

extension TranslateContent {
    /// The languages, the field and the swap, with the translation in the lower half.
    private var input: some View {
        TranslateInputCard(text: $model.input, sourceLabel: model.sourceLabel, prompt: prompt,
                           isFocused: $isFieldFocused, onSwap: swap, onEdit: { taps += 1 }, lower: { lower })
    }

    /// Under the field: the translation, the wait for it, or what stands there before.
    @ViewBuilder
    private var lower: some View {
        if isLoadingResult {
            TranslateLoadingResult(label: model.resultLabel)
        } else if let text = model.resultText {
            TranslateResultBlock(label: model.resultLabel, text: text,
                                 isSaved: model.isSaved(in: savedTranslations), handlers: handlers)
        } else if isStart {
            TranslateWelcomeContent(onChoose: use)
        } else {
            TranslateEmptyResult(label: model.resultLabel)
        }
    }

    private var translateButton: some View {
        Button(isAsking ? "Say it in German" : "Translate", systemImage: isAsking ? "quote.bubble.fill" : "translate") {
            translate()
        }
        .buttonStyle(.primary)
        .disabled(isEmpty || model.isTranslating)
    }

    private var handlers: TranslateResultHandlers {
        TranslateResultHandlers { slowly in
            Task { await model.listen(slowly: slowly) }
        } copy: {
            UIPasteboard.general.string = model.resultText
            toast = ToastMessage(text: "Copied", systemImage: "doc.on.doc.fill")
        } toggleSave: {
            let saved = model.toggleSave(in: modelContext)
            toast = saved ? ToastMessage(text: "Saved to Memory", systemImage: "bookmark.fill")
                : ToastMessage(text: "Removed from Memory", systemImage: "bookmark.slash.fill")
        }
    }

    /// The languages to download, or why it didn't work.
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

    /// Word by word, tone and in context, and what is still on its way.
    @ViewBuilder
    private var details: some View {
        if let result = model.result {
            VStack(alignment: .leading, spacing: Spacing.grid) {
                TranslateDetails(result: result) { german in
                    Task { await model.listen(to: german) }
                }
                if model.isExplaining || model.isTranslating {
                    TranslateLoadingDetails(pending: TranslateSection.allCases.filter { $0.isEmpty(in: result) })
                }
            }
            .padding(.top, 14)
        }
    }
}

// MARK: - Actions

extension TranslateContent {
    private func inputChanged(to input: String) {
        // Put there from the history, with its translation: nothing to clear.
        if input == model.restoredInput { return }
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

    /// A prompt was tapped: its text goes in the field.
    private func use(_ text: String) {
        taps += 1
        model.input = text
    }

    /// A translation from the history: shown again as it was.
    private func show(_ lookup: TranslationLookup) {
        translationTask?.cancel()
        isFieldFocused = false
        model.show(lookup)
    }
}

#Preview {
    NavigationStack {
        TranslateView(initialText: nil)
    }
    .modelContainer(AlltagStore.preview)
}
