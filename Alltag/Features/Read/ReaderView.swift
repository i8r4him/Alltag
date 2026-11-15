//
//  ReaderView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI
import Translation

/// Learn › Read › a text: the German in large type on a glass card. Tapping a
/// word translates it and offers to save it to Memory; the speaker in the
/// toolbar reads the whole text aloud.
struct ReaderView: View {
    @State private var model: ReaderModel
    @Environment(\.services) private var services
    @Environment(\.modelContext) private var context
    @State private var download: TranslationSession.Configuration?
    /// Counts the speaker's taps, for the medium haptic tap.
    @State private var listenTaps = 0

    init(text: ReadingText) {
        _model = State(initialValue: ReaderModel(text: text))
    }

    var body: some View {
        @Bindable var model = model
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.section) {
                ReaderHeader(text: model.text)
                page
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .fontDesign(.rounded)
        .readableContentMargins()
        .skyBackground()
        .navigationTitle(Text(model.text.title))
        .toolbarTitleDisplayMode(.inline)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    listenTaps += 1
                    Task { await model.toggleListening(with: services.voice) }
                } label: {
                    if model.isListening {
                        Label("Stop", systemImage: "stop.fill")
                    } else {
                        Label("Listen", systemImage: "speaker.wave.2.fill")
                    }
                }
                .contentTransition(.symbolEffect(.replace))
            }
        }
        .safeAreaInset(edge: .bottom) { wordCard }
        .animation(.easeOut(duration: 0.25), value: model.selected)
        .sensoryFeedback(.selection, trigger: model.selected)
        .sensoryFeedback(.impact(weight: .medium), trigger: listenTaps)
        .onChange(of: model.meaning) { _, _ in model.refreshSaved(in: context) }
        .onAppear { model.resume(with: services.translation) }
        .onDisappear { model.stop(services.voice) }
        .translationTask(download) { session in
            do {
                try await session.prepareTranslation()
                await model.languagesDownloaded()
            } catch {
                await model.downloadFailed()
            }
            download = nil
        }
        .toast($model.notice)
    }

    /// The text on a clear glass card, a paragraph at a time.
    private var page: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(model.paragraphs) { paragraph in
                ReaderParagraphText(paragraph: paragraph, selectedID: model.selected?.id) { id in
                    if let word = model.word(id: id) { model.select(word, with: services.translation) }
                }
                .padding(.top, paragraph.id == 0 ? 0 : paragraph.startsBlock ? 18 : 4)
            }
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    /// The tapped word on a glass card above the tab bar; the text scrolls behind it.
    @ViewBuilder
    private var wordCard: some View {
        if let word = model.selected, let lookup = model.lookup {
            ReaderWordCard(word: word, lookup: lookup, isSaved: model.meaning.map(model.isSaved) ?? false,
                           onListen: { german in Task { await model.listen(to: german, with: services.voice) } },
                           onToggleSave: { model.toggleSave(in: context) },
                           onRetry: { model.retry(with: services.translation) },
                           onDownload: { download = downloadConfiguration(for: lookup) },
                           onClose: { model.close() })
                .padding(Spacing.cardLarge)
                .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
                .padding(.horizontal, Spacing.screen)
                .padding(.bottom, 8)
                .readableWidth()
                .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }

    private func downloadConfiguration(for lookup: ReaderModel.Lookup) -> TranslationSession.Configuration? {
        guard case let .needsDownload(source, target) = lookup else { return nil }
        return TranslationSession.Configuration(source: source, target: target)
    }
}

/// What the text is, in the Focus card's layout: the detail and the level on
/// the left, the theme's artwork on the right, and how to use the reader.
private struct ReaderHeader: View {
    let text: ReadingText

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(text.detail)
                        .font(.title3.weight(.semibold))
                        .fixedSize(horizontal: false, vertical: true)
                    Text("\(text.level) · \(text.minutes) min")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                ScenarioArtwork(systemImage: text.systemImage, symbolSize: 34, cornerRadius: 16)
                    .frame(width: 72, height: 72)
            }
            Label("Tap a word to see what it means.", systemImage: "hand.tap")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 4)
    }
}

/// One paragraph of the text, as real text that wraps like a page. Every word
/// is a link to itself, so a tap selects it; the selected word is highlighted
/// in the theme colour.
private struct ReaderParagraphText: View {
    let paragraph: ReadingParagraph
    let selectedID: Int?
    let onTap: (Int) -> Void

    var body: some View {
        Text(attributed)
            .font(.title3)
            .lineSpacing(6)
            .tint(Color.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .environment(\.locale, ReaderWordCard.german)
            .environment(\.openURL, OpenURLAction { url in
                if let id = ReaderLink.wordID(in: url) { onTap(id) }
                return .handled
            })
    }

    private var attributed: AttributedString {
        var text = AttributedString()
        for (index, word) in paragraph.words.enumerated() {
            if index > 0 { text += AttributedString(" ") }
            var written = AttributedString(word.written)
            if word.isWord, let range = written.range(of: word.word) {
                written[range].link = ReaderLink.url(for: word.id)
                if word.id == selectedID {
                    written[range].backgroundColor = Color.accentFill.opacity(0.35)
                }
            }
            text += written
        }
        return text
    }
}

/// The links inside the text: `alltag-reader:word/<id>`. They never leave the reader.
enum ReaderLink {
    static func url(for id: Int) -> URL? {
        URL(string: "alltag-reader:word/\(id)")
    }

    static func wordID(in url: URL) -> Int? {
        guard url.scheme == "alltag-reader" else { return nil }
        return url.absoluteString.split(separator: "/").last.flatMap { Int($0) }
    }
}

#Preview {
    NavigationStack {
        ReaderView(text: MockReading.picked)
    }
    .modelContainer(AlltagStore.preview)
}
