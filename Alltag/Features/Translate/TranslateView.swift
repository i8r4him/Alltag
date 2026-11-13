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
struct TranslateView: View {
    let initialText: String?
    @Environment(\.services) private var services
    @State private var model: TranslateModel?

    var body: some View {
        Group {
            if let model {
                TranslateContent(model: model)
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
    @Environment(\.modelContext) private var modelContext
    @Query private var savedTranslations: [SavedTranslation]
    @State private var toast: ToastMessage?
    /// Set to ask the system to download the translation languages.
    @State private var download: TranslationSession.Configuration?
    @State private var translationTask: Task<Void, Never>?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if !model.hasAttempted && model.result == nil {
                    TranslateWelcome { model.input = $0 }
                        .padding(.vertical, Spacing.card)
                }
                sourceCard
                Button("Translate", systemImage: "translate") {
                    translationTask?.cancel()
                    translationTask = Task { await model.translate() }
                }
                .buttonStyle(.primary)
                .disabled(model.input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || model.isTranslating)
                if model.hasAttempted || model.result != nil { resultCard }
                if let result = model.result {
                    VStack(alignment: .leading, spacing: 24) {
                        if !result.words.isEmpty { WordByWordSection(words: result.words) }
                        if !result.tones.isEmpty { ToneSection(note: result.note, tones: result.tones) }
                        if !result.examples.isEmpty {
                            InContextSection(examples: result.examples) { german in
                                Task { await model.listen(to: german) }
                            }
                        }
                        if model.isExplaining || model.isTranslating {
                            Label("Adding word by word, tone and examples…", systemImage: "sparkles")
                                .textRole(.meta)
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) { languageCapsule }
        }
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
        .onChange(of: model.input) { _, _ in
            translationTask?.cancel()
            model.clearResult()
        }
        .toast($toast)
    }

    // MARK: Header

    private var languageCapsule: some View {
        HStack(spacing: 4) {
            Text(model.sourceLabel)
                .padding(.horizontal, 10)
            Button("Swap languages", systemImage: "arrow.left.arrow.right") {
                model.swap()
            }
                .labelStyle(.iconOnly)
                .font(.footnote.weight(.semibold))
                .frame(width: 32, height: 32)
                .background(.controlFill, in: .circle)
            Text(model.resultLabel)
                .padding(.horizontal, 10)
        }
        .textRole(.bodySmall)
        .fontWeight(.medium)
        .accessibilityElement(children: .contain)
    }

    // MARK: Cards

    private var sourceCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(model.sourceLabel)
                .textRole(.meta)
                .foregroundStyle(.secondary)
            TextField("Type or paste text", text: $model.input, axis: .vertical)
                .font(.title3)
                .lineLimit(2...6)
                .accessibilityLabel(Text(model.sourceLabel))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    private var resultCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(model.resultLabel)
                .textRole(.meta)
                .foregroundStyle(.accent)
            if let text = model.resultText {
                Text(verbatim: text)
                    .font(.system(.title2, weight: .semibold))
                    .textSelection(.enabled)
                resultActions
            } else if model.isTranslating {
                ProgressView()
            } else {
                unknownNote
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    private var resultActions: some View {
        let isSaved = model.isSaved(in: savedTranslations)
        return HStack(spacing: 8) {
            Button("Listen", systemImage: "speaker.wave.2") { Task { await model.listen() } }
                .buttonStyle(.chip(isSelected: false))
            Button("Slowly", systemImage: "tortoise") { Task { await model.listen(slowly: true) } }
                .buttonStyle(.chip(isSelected: false))
            Spacer()
            Button {
                if model.toggleSave(in: modelContext) {
                    toast = ToastMessage(text: "Saved to Memory", systemImage: "bookmark.fill")
                }
            } label: {
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 17))
                    .foregroundStyle(isSaved ? AnyShapeStyle(.accent) : AnyShapeStyle(.primary))
                    .frame(width: 40, height: 40)
                    .background(.controlFill, in: .circle)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isSaved ? Text("Remove from Memory") : Text("Save to Memory"))
            .sensoryFeedback(.selection, trigger: isSaved)
        }
    }

    /// Shown when there's no translation: download the languages, or try a sample.
    @ViewBuilder
    private var unknownNote: some View {
        if let languages = model.missingLanguages {
            VStack(alignment: .leading, spacing: 12) {
                Text("Download English and German once to translate privately on your iPhone.")
                    .textRole(.bodySmall)
                    .foregroundStyle(.secondary)
                Button("Download languages", systemImage: "arrow.down.circle") {
                    download = TranslationSession.Configuration(source: languages.source, target: languages.target)
                }
                .buttonStyle(.primaryCompact)
            }
        } else if !model.hasAttempted {
            Text("Type or paste text to translate.")
                .foregroundStyle(.secondary)
        } else {
            Text("Translation is unavailable. Check your connection and cloud setting, then try again.")
                .textRole(.bodySmall)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        TranslateView(initialText: nil)
    }
    .modelContainer(AlltagStore.preview)
}
