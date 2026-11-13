//
//  TranslationProvider.swift
//  AlltagTranslation
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import ExtensionKit
import SwiftUI
import TranslationUIProvider

@main
final class AlltagTranslationExtension: TranslationUIProviderExtension {
    required init() {}

    var body: some TranslationUIProviderExtensionScene {
        TranslationUIProviderSelectedTextScene { context in
            TranslationPanel(context: context)
        }
    }
}

struct TranslationPanel: View {
    let context: any TranslationUIProviderContext
    @State private var saved = Set<String>()
    @State private var saveFailed = false
    @State private var retryAttempt = 0
    @State private var model = TranslationPanelModel()
    @AppStorage("extensionCloudConsent") private var cloudAllowed = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var source: String {
        (context.inputText.map { String($0.characters) } ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                sourceCard
                if source.isEmpty {
                    ContentUnavailableView("No text selected", systemImage: "text.cursor",
                                           description: Text("Select a word or sentence, then choose Translate."))
                } else if source.utf16.count > 600 {
                    Text("Select up to 600 characters to translate at once.")
                        .foregroundStyle(.secondary)
                } else if !cloudAllowed {
                    consent
                } else {
                    answer
                    Button("Turn off cloud translation") { cloudAllowed = false }
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(Spacing.screen)
        }
        .fontDesign(.rounded)
        .tint(Color.accent)
        .background {
            Color.screenBackground.overlay(alignment: .top) {
                RadialGradient(colors: [Color.accentFill.opacity(0.12), .clear],
                               center: .topTrailing, startRadius: 0, endRadius: 340)
            }.ignoresSafeArea()
        }
        .task(id: source + String(cloudAllowed) + String(retryAttempt)) {
            if let raw = UserDefaults(suiteName: TranslationInbox.group)?.string(forKey: CompanionLook.Key.palette),
               let palette = CompanionPalette(rawValue: raw) { AppTheme.shared.palette = palette }
            guard cloudAllowed, !source.isEmpty, source.utf16.count <= 600 else { return }
            context.expandSheet()
            saved = []
            saveFailed = false
            await model.translate(source)
        }
        .animation(reduceMotion ? nil : .easeOut(duration: 0.25), value: model.result)
    }

    private var sourceCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Selected text", systemImage: "text.quote")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(verbatim: source)
                .font(.body)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(Spacing.card)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.card))
    }

    private var consent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Translate with Alltag")
                .font(.title2.bold())
            Text("Selected text is sent through Alltag’s server to OpenAI to translate and explain it. Only text you select is sent.")
                .foregroundStyle(.secondary)
            Button("Allow cloud translation", systemImage: "translate") { cloudAllowed = true }
                .buttonStyle(.glassProminent)
        }
    }

    @ViewBuilder
    private var answer: some View {
        if let translation = model.translation {
            VStack(alignment: .leading, spacing: 16) {
                Label("Translation", systemImage: "translate")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.accent)
                Text(verbatim: translation)
                    .font(.title2.weight(.semibold))
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(saved.contains(translation) ? "Saved for Memory" : "Save to Memory", systemImage: "bookmark") {
                    if let result = model.result { save(german: result.german, meaning: result.english, key: translation) }
                }
                .buttonStyle(.glassProminent)
                .disabled(model.isLoading || model.failed || saved.contains(translation))
                if saved.contains(translation) {
                    Text("Open Alltag to find it in Memory.").font(.caption).foregroundStyle(.secondary)
                }
                if saveFailed {
                    Text("Couldn’t save. Try again.").foregroundStyle(.secondary)
                }
                if context.allowsReplacement && !model.isLoading && !model.failed {
                    Button("Replace selection", systemImage: "arrow.triangle.2.circlepath") {
                        context.finish(translation: AttributedString(translation))
                    }.buttonStyle(.glassProminent)
                }
            }
            .padding(Spacing.cardLarge)
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero))
        }
        if model.isLoading { ProgressView(model.result == nil ? "Translating…" : "Adding explanations…") }
        if model.failed {
            VStack(alignment: .leading, spacing: 8) {
                Text("Translation couldn’t finish. Check your connection and try again.")
                    .foregroundStyle(.secondary)
                Button("Try again", systemImage: "arrow.clockwise") {
                    retryAttempt += 1
                }.buttonStyle(.glass)
            }
        }
        if let result = model.result {
            if !result.words.isEmpty {
                details("Word by word") {
                    ForEach(Array(result.words.enumerated()), id: \.offset) { _, word in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(verbatim: word.word).font(.headline).foregroundStyle(.accent)
                            Text(verbatim: word.meaning)
                            Text(verbatim: word.grammar).font(.subheadline).foregroundStyle(.secondary)
                            Button(saved.contains(word.word) ? "Saved" : "Save word", systemImage: "bookmark") {
                                save(german: word.word, meaning: word.meaning, key: word.word)
                            }.buttonStyle(.glass).disabled(saved.contains(word.word))
                        }
                    }
                }
            }
            if !result.tones.isEmpty {
                details("Tone") {
                    ForEach(Array(result.tones.enumerated()), id: \.offset) { _, tone in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(tone.tone.rawValue).font(.subheadline.weight(.semibold)).foregroundStyle(.accent)
                            Text(verbatim: tone.german)
                        }
                    }
                }
            }
            if !result.examples.isEmpty {
                details("In context") {
                    ForEach(Array(result.examples.enumerated()), id: \.offset) { _, example in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(verbatim: example.german)
                            Text(verbatim: example.english).foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }

    private func save(german: String, meaning: String, key: String) {
        do {
            try TranslationInbox.save(.init(german: german, meaning: meaning))
            saved.insert(key)
            saveFailed = false
        } catch { saveFailed = true }
    }

    private func details(_ title: LocalizedStringKey, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title).font(.headline)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero))
    }
}
