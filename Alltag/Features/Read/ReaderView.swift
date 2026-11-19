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
/// toolbar reads the whole text aloud. Under the text, three questions check
/// what the learner understood; a wrong answer lights up the sentence that
/// holds the answer.
struct ReaderView: View {
    @State private var model: ReaderModel
    @Environment(\.services) private var services
    @Environment(\.modelContext) private var context
    @State private var download: TranslationSession.Configuration?
    /// Counts the speaker's taps, for the medium haptic tap.
    @State private var listenTaps = 0
    /// Temporary: where the questions show, until the maintainer picks a design.
    @AppStorage(ReadDesign.storageKey) private var design = 0
    @Namespace private var questionsZoom

    init(text: ReadingText) {
        _model = State(initialValue: ReaderModel(text: text))
    }

    private var questionsOnSheet: Bool { ReadDesign(rawValue: design) != .realThing }

    var body: some View {
        @Bindable var model = model
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.section) {
                    ReaderHeader(text: model.text)
                    page
                    questionsButton
                }
                .padding(.horizontal, Spacing.screen)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
            .scrollEdgeEffectStyle(.soft, for: .all)
            .onChange(of: model.litParagraphID) { _, id in
                guard let id else { return }
                // High on the screen: the questions cover the lower half.
                withAnimation(.easeOut(duration: 0.35)) { proxy.scrollTo(id, anchor: UnitPoint(x: 0.5, y: 0.2)) }
            }
        }
        .fontDesign(.rounded)
        .readableContentMargins()
        .skyBackground()
        .navigationTitle(Text(model.text.title))
        .toolbarTitleDisplayMode(.inline)
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
        .safeAreaInset(edge: .bottom) { bottomCard }
        .animation(.easeOut(duration: 0.25), value: model.selected)
        .animation(.easeOut(duration: 0.25), value: model.showsQuestions)
        .sensoryFeedback(.selection, trigger: model.selected)
        .sensoryFeedback(.impact(weight: .medium), trigger: listenTaps)
        .sensoryFeedback(.impact(weight: .medium), trigger: model.showsQuestions) { _, shows in shows }
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
        .sheet(isPresented: questionsSheet) {
            ScrollView {
                ReadingQuestionsView(quiz: model.quiz, style: .rows,
                                     onNext: { model.nextQuestion(in: context) },
                                     onClose: { model.hideQuestions() })
                    .padding(.horizontal, Spacing.screen)
                    .padding(.top, 28)
                    .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
            .scrollEdgeEffectStyle(.soft, for: .all)
            .fontDesign(.rounded)
            .presentationDetents([.medium, .large])
            // The text stays readable and scrollable above the sheet.
            .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            .navigationTransition(.zoom(sourceID: Self.questionsID, in: questionsZoom))
        }
        .toast($model.notice)
    }

    private static let questionsID = "questions"

    /// The questions on a sheet, in that design.
    private var questionsSheet: Binding<Bool> {
        Binding(get: { questionsOnSheet && model.showsQuestions },
                set: { shows in if !shows { model.hideQuestions() } })
    }

    /// The text on a clear glass card, a paragraph at a time.
    private var page: some View {
        let lit = model.litWordIDs
        return VStack(alignment: .leading, spacing: 0) {
            ForEach(model.paragraphs) { paragraph in
                ReaderParagraphText(paragraph: paragraph, selectedID: model.selected?.id, litIDs: lit) { id in
                    if let word = model.word(id: id) { model.select(word, with: services.translation) }
                }
                .padding(.top, paragraph.id == 0 ? 0 : paragraph.startsBlock ? 18 : 4)
                .id(paragraph.id)
            }
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    /// "Check what you understood", under the text.
    private var questionsButton: some View {
        Button { model.showQuestions() } label: {
            Label("Check what you understood", systemImage: "checklist")
        }
        .buttonStyle(.primary)
        .matchedTransitionSource(id: Self.questionsID, in: questionsZoom)
    }

    /// The tapped word, or the questions in that design, on a glass card above
    /// the tab bar; the text scrolls behind it.
    @ViewBuilder
    private var bottomCard: some View {
        if let word = model.selected, let lookup = model.lookup {
            ReaderWordCard(word: word, lookup: lookup, isSaved: model.meaning.map(model.isSaved) ?? false,
                           onListen: { german in Task { await model.listen(to: german, with: services.voice) } },
                           onToggleSave: { model.toggleSave(in: context) },
                           onRetry: { model.retry(with: services.translation) },
                           onDownload: { download = downloadConfiguration(for: lookup) },
                           onClose: { model.close() })
                .modifier(BottomGlassCard())
        } else if !questionsOnSheet && model.showsQuestions {
            ReadingQuestionsView(quiz: model.quiz, style: .chips,
                                 onNext: { model.nextQuestion(in: context) },
                                 onClose: { model.hideQuestions() })
                .modifier(BottomGlassCard())
        }
    }

    private func downloadConfiguration(for lookup: ReaderModel.Lookup) -> TranslationSession.Configuration? {
        guard case let .needsDownload(source, target) = lookup else { return nil }
        return TranslationSession.Configuration(source: source, target: target)
    }
}

/// A card on clear glass at the bottom of the reader, coming up from below.
private struct BottomGlassCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(Spacing.cardLarge)
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
            .padding(.horizontal, Spacing.screen)
            .padding(.bottom, 8)
            .readableWidth()
            .transition(.move(edge: .bottom).combined(with: .opacity))
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
                    Text("\(text.kind.title) · \(text.level.title) · \(text.minutes) min")
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
/// in the theme colour, and the sentence that holds an answer more softly.
private struct ReaderParagraphText: View {
    let paragraph: ReadingParagraph
    let selectedID: Int?
    /// The words of the sentence that holds an answer.
    let litIDs: Set<Int>
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
                } else if litIDs.contains(word.id) {
                    written[range].backgroundColor = Color.accentFill.opacity(0.22)
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
        ReaderView(text: ReadingTexts.a2Water)
    }
    .modelContainer(AlltagStore.preview)
}
