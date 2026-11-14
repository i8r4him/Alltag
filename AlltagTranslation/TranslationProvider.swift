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

/// The panel other apps show for "Translate": the selected text, its
/// translation, and word by word, tone and in context, in the look of the
/// app's Translate screen.
struct TranslationPanel: View {
    let context: any TranslationUIProviderContext
    /// What was saved from this panel, and the inbox entry it went into, so it can be taken out again.
    @State private var saved: [String: UUID] = [:]
    @State private var saveFailed = false
    @State private var retryAttempt = 0
    @State private var model = TranslationPanelModel()
    /// Counts the taps that save, copy, replace or start something, for the medium haptic.
    @State private var taps = 0
    @State private var showsWholeSource = false
    @State private var copied = false
    @AppStorage("extensionCloudConsent") private var cloudAllowed = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var source: String {
        (context.inputText.map { String($0.characters) } ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canTranslate: Bool { cloudAllowed && !source.isEmpty && source.utf16.count <= 600 }
    private var translation: String? { canTranslate ? model.translation : nil }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                top
                if source.isEmpty {
                    ContentUnavailableView("No text selected", systemImage: "text.cursor",
                                           description: Text("Select a word or sentence, then choose Translate."))
                } else if source.utf16.count > 600 {
                    Text("Select up to 600 characters to translate at once.")
                        .foregroundStyle(.secondary)
                } else if !cloudAllowed {
                    consent
                } else {
                    states
                    details
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
            guard canTranslate else { return }
            context.expandSheet()
            saved = [:]
            saveFailed = false
            await model.translate(source)
        }
        .animation(reduceMotion ? nil : .easeOut(duration: 0.25), value: model.result)
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
    }
}

// MARK: - The selected text and its translation

extension TranslationPanel {
    /// The selected text and its translation, on a card each.
    @ViewBuilder
    private var top: some View {
        PanelSection(kind: .source) { sourceText }
        if let translation {
            PanelSection(kind: .translation) { translated(translation) }
        }
    }

    /// The selected text; a long one shows its first lines until it is opened.
    private var sourceText: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(verbatim: source)
                .font(.body)
                .lineLimit(showsWholeSource ? nil : 4)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
            if source.count > 200 {
                Button(showsWholeSource ? "Show less" : "Show all") {
                    withAnimation(reduceMotion ? nil : .easeOut(duration: 0.2)) { showsWholeSource.toggle() }
                }
                .font(.subheadline.weight(.semibold))
            }
        }
    }

    private func translated(_ translation: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            PanelTranslationText(text: translation)
            HStack(spacing: 10) {
                Button {
                    UIPasteboard.general.string = translation
                    copied = true
                    taps += 1
                } label: {
                    Image(systemName: copied ? "checkmark" : "doc.on.doc")
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .contentTransition(.symbolEffect(.replace))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.interactive(), in: .circle)
                .accessibilityLabel(copied ? Text("Copied") : Text("Copy"))
                if context.allowsReplacement && !model.isLoading && !model.failed {
                    Button("Replace selection", systemImage: "arrow.triangle.2.circlepath") {
                        taps += 1
                        context.finish(translation: AttributedString(translation))
                    }
                    .buttonStyle(.glass)
                }
                Spacer(minLength: 0)
                PanelBookmark(isSaved: saved[translation] != nil) {
                    if let result = model.result { toggleSave(german: result.german, meaning: result.english, key: translation) }
                }
                .disabled(model.isLoading || model.failed)
            }
            if !saved.isEmpty {
                Text("Open Alltag to find it in Memory.").font(.caption).foregroundStyle(.secondary)
            }
            if saveFailed {
                Text("Couldn’t save. Try again.").font(.caption).foregroundStyle(.secondary)
            }
        }
        .onChange(of: translation) { _, _ in copied = false }
    }

    private var consent: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Translate with Alltag")
                .font(.title2.bold())
            Text("Selected text is sent through Alltag’s server to OpenAI to translate and explain it. Only text you select is sent.")
                .foregroundStyle(.secondary)
            Button("Allow cloud translation", systemImage: "translate") { cloudAllowed = true }
                .buttonStyle(.primary)
        }
        .panelCard()
    }
}

// MARK: - Waiting, failing, and the details

extension TranslationPanel {
    @ViewBuilder
    private var states: some View {
        if model.isLoading {
            if model.result == nil {
                // A blank line in the shape of the answer, as in the app.
                VStack(alignment: .leading, spacing: 10) {
                    Text(verbatim: "Können wir uns eine halbe Stunde später treffen?")
                        .font(.title2.weight(.semibold))
                        .redacted(reason: .placeholder)
                        .accessibilityHidden(true)
                    Label { Text("Translating…") } icon: { ProgressView().controlSize(.small) }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                .panelCard()
            } else {
                Label("Adding word by word, tone and examples…", systemImage: "sparkles")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
            }
        }
        if model.failed {
            VStack(alignment: .leading, spacing: 12) {
                Label("Couldn’t translate it", systemImage: "exclamationmark.triangle")
                    .font(.title3.weight(.semibold))
                Text("Translation couldn’t finish. Check your connection and try again.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Button {
                    taps += 1
                    retryAttempt += 1
                } label: {
                    Label("Try again", systemImage: "arrow.clockwise")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 34)
                }
                .buttonStyle(.glass)
            }
            .panelCard()
        }
    }

    @ViewBuilder
    private var details: some View {
        if let result = model.result {
            if !result.words.isEmpty {
                PanelSection(kind: .words) {
                    PanelRows(items: result.words) { word in
                        HStack(alignment: .center, spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(verbatim: word.word).font(.headline).foregroundStyle(.accent)
                                Text(verbatim: word.meaning)
                                Text(verbatim: word.grammar).font(.subheadline).foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .accessibilityElement(children: .combine)
                            PanelBookmark(isSaved: saved[word.word] != nil) {
                                toggleSave(german: word.word, meaning: word.meaning, key: word.word)
                            }
                        }
                    }
                }
            }
            if !result.tones.isEmpty {
                PanelSection(kind: .tone) {
                    PanelRows(items: result.tones) { tone in
                        HStack(alignment: .firstTextBaseline, spacing: 12) {
                            Label { Text(tone.tone.panelTitle) } icon: { Image(systemName: tone.tone.panelSymbol) }
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.accent)
                                .frame(width: 104, alignment: .leading)
                            Text(verbatim: tone.german).frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .accessibilityElement(children: .combine)
                    }
                }
            }
            if !result.examples.isEmpty {
                PanelSection(kind: .context) {
                    PanelRows(items: result.examples) { example in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(verbatim: example.german)
                            Text(verbatim: example.english).font(.subheadline).foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityElement(children: .combine)
                    }
                }
            }
        }
    }

    /// Saves to the inbox the app reads, or takes it out again if it is still there.
    private func toggleSave(german: String, meaning: String, key: String) {
        taps += 1
        do {
            if let id = saved[key] {
                try TranslationInbox.remove(id)
                saved[key] = nil
            } else {
                let entry = TranslationInbox.Entry(german: german, meaning: meaning)
                try TranslationInbox.save(entry)
                saved[key] = entry.id
            }
            saveFailed = false
        } catch { saveFailed = true }
    }
}

// MARK: - Parts

/// The cards of the panel, each with its symbol.
enum PanelKind {
    case source, translation, words, tone, context

    var title: LocalizedStringResource {
        switch self {
        case .source: "Selected text"
        case .translation: "Translation"
        case .words: "Word by word"
        case .tone: "Tone"
        case .context: "In context"
        }
    }

    var systemImage: String {
        switch self {
        case .source: "text.quote"
        case .translation: "translate"
        case .words: "text.word.spacing"
        case .tone: "theatermasks.fill"
        case .context: "text.bubble.fill"
        }
    }
}

/// A header above its glass card: large, with the symbol in the accent
/// colour, like the detail headers of the app's Translate screen.
struct PanelSection<Content: View>: View {
    let kind: PanelKind
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label { Text(kind.title) } icon: { Image(systemName: kind.systemImage).foregroundStyle(.accent) }
                .textRole(.sectionHeader)
                .padding(.horizontal, 4)
            content.panelCard()
        }
    }
}

/// Rows with a line between them, as in the app's detail cards.
struct PanelRows<Item, Row: View>: View {
    let items: [Item]
    @ViewBuilder let row: (Item) -> Row

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                if index > 0 { Divider() }
                row(item).padding(.vertical, 12)
            }
        }
    }
}

/// The bookmark on a glass circle: saves, and takes out again.
struct PanelBookmark: View {
    let isSaved: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.accent)
                .contentTransition(.symbolEffect(.replace))
                .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .circle)
        .accessibilityLabel(isSaved ? Text("Remove from Memory") : Text("Save to Memory"))
    }
}

/// The translation: a short phrase large; a long text in body size, arranged
/// for reading with a heading, its facts and paragraphs.
struct PanelTranslationText: View {
    let text: String

    var body: some View {
        let layout = TranslationLayout(text)
        Group {
            if layout.isLong {
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(Array(layout.blocks.enumerated()), id: \.offset) { _, block in
                        switch block {
                        case .heading(let heading):
                            Text(verbatim: heading).font(.title3.weight(.semibold))
                        case .facts(let facts):
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(Array(facts.enumerated()), id: \.offset) { _, fact in
                                    Text(verbatim: fact).foregroundStyle(.secondary)
                                }
                            }
                        case .paragraph(let paragraph):
                            Text(verbatim: paragraph).lineSpacing(3)
                        }
                    }
                }
            } else {
                Text(verbatim: text).font(.title2.weight(.semibold))
            }
        }
        .textSelection(.enabled)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension TranslationResult.ToneVariant.Tone {
    fileprivate var panelTitle: LocalizedStringResource {
        switch self {
        case .formal: "Formal"
        case .neutral: "Neutral"
        case .casual: "Casual"
        }
    }

    fileprivate var panelSymbol: String {
        switch self {
        case .formal: "briefcase.fill"
        case .neutral: "person.fill"
        case .casual: "face.smiling"
        }
    }
}

extension View {
    /// The clear glass card every part of the panel sits on.
    fileprivate func panelCard() -> some View {
        frame(maxWidth: .infinity, alignment: .leading)
            .padding(Spacing.cardLarge)
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}
