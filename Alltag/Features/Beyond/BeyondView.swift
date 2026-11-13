//
//  BeyondView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI
import Translation

/// Alltag outside the app: translating what you read works now, with Apple's
/// Translation; the widgets and the Siri phrases are shown as what is coming.
struct BeyondView: View {
    @State private var toast: ToastMessage?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.section) {
                section("Tap a word", badge: "Works now", isLive: true,
                        note: "Translated on your iPhone with Apple's Translation. In other apps, select a text and choose Translate.") {
                    TapToTranslate(toast: $toast)
                }
                section("Widgets", badge: "Coming soon", note: "Your word of the day and what's ready to review, on the Home Screen.") {
                    WidgetPreviews()
                }
                section("Siri", badge: "Coming with iOS 27.3", note: "Start practising without opening the app.") {
                    SiriPhrases()
                }
            }
            .padding(Spacing.screen)
        }
        .fontDesign(.rounded)
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .readableContentMargins()
        .skyBackground()
        .navigationTitle("Beyond the app")
        .toolbarTitleDisplayMode(.inlineLarge)
        .toast($toast)
    }

    private func section(_ title: LocalizedStringKey, badge: LocalizedStringKey, isLive: Bool = false,
                         note: LocalizedStringKey, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text(title)
                    .textRole(.sectionHeader)
                    .accessibilityAddTraits(.isHeader)
                Text(badge)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(isLive ? AnyShapeStyle(.accent) : AnyShapeStyle(.secondary))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .glassEffect(.regular, in: .capsule)
            }
            .padding(.horizontal, 4)
            content()
            Text(note)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
        }
    }
}

/// A short German text from everyday life. Tapping a word translates it with
/// Apple's Translation framework; the word can be saved to Memory.
///
/// The framework's `translationTask` is a view modifier, so this view talks to
/// it directly instead of going through `TranslationService`.
private struct TapToTranslate: View {
    @Binding var toast: ToastMessage?
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [MemoryItem]

    @State private var selected: String?
    @State private var translation: String?
    @State private var hasFailed = false
    @State private var configuration: TranslationSession.Configuration?
    @State private var showsWholeText = false

    private static let text = "Sehr geehrte Mieterin, sehr geehrter Mieter, am Donnerstag wird das Wasser von 9 bis 12 Uhr abgestellt. " +
        "Bitte entschuldigen Sie die Unannehmlichkeiten. Ihre Hausverwaltung"
    private static let words = text.split(separator: " ").map(String.init)

    /// The learner's own language, or English for learners whose iPhone is in German.
    private static var target: Locale.Language {
        let own = Locale.current.language
        return own.languageCode == .german ? Locale.Language(identifier: "en") : own
    }

    private var isSaved: Bool {
        guard let selected else { return false }
        return items.contains { $0.word == selected }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            FlowLayout(spacing: 5, lineSpacing: 6) {
                ForEach(Array(Self.words.enumerated()), id: \.offset) { _, word in
                    let clean = Self.clean(word)
                    Button { select(clean) } label: {
                        Text(verbatim: word)
                            .font(.title3)
                            .padding(.horizontal, 3)
                            .padding(.vertical, 1)
                            .background(selected == clean ? AnyShapeStyle(.accentFill.opacity(0.35)) : AnyShapeStyle(.clear),
                                        in: .rect(cornerRadius: 6, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .accessibilityHint("Translates this word.")
                }
            }
            .environment(\.locale, Locale(identifier: "de"))

            if let selected {
                Divider()
                VStack(alignment: .leading, spacing: 8) {
                    Text(verbatim: selected)
                        .font(.title3.weight(.semibold))
                    Group {
                        if let translation {
                            Text(verbatim: translation)
                        } else if hasFailed {
                            Text("This word couldn't be translated. Try \"Translate everything\" to download German.")
                        } else {
                            ProgressView().controlSize(.small)
                        }
                    }
                    .font(.body)
                    .foregroundStyle(.secondary)
                    if translation != nil {
                        Button(isSaved ? "Saved" : "Save for practice", systemImage: isSaved ? "checkmark" : "bookmark") { save() }
                            .buttonStyle(.glass)
                            .disabled(isSaved)
                            .padding(.top, 2)
                    }
                }
                .transition(.opacity)
            }

            Button("Translate everything", systemImage: "translate") { showsWholeText = true }
                .buttonStyle(.glass)
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .animation(.easeOut(duration: 0.2), value: selected)
        .animation(.easeOut(duration: 0.2), value: translation)
        .sensoryFeedback(.selection, trigger: selected)
        .translationTask(configuration) { session in
            guard let word = selected else { return }
            do {
                let response = try await session.translate(word)
                if selected == word { translation = response.targetText }
            } catch {
                if selected == word { hasFailed = true }
            }
        }
        .translationPresentation(isPresented: $showsWholeText, text: Self.text)
    }

    private func select(_ word: String) {
        guard selected != word else { return }
        selected = word
        translation = nil
        hasFailed = false
        if configuration == nil {
            configuration = TranslationSession.Configuration(source: Locale.Language(identifier: "de"), target: Self.target)
        } else {
            configuration?.invalidate()
        }
    }

    private func save() {
        guard let selected, let translation, !isSaved else { return }
        modelContext.insert(MemoryItem(word: selected, meaning: translation, context: Self.text, kind: .saved, source: .translate))
        try? modelContext.save()
        toast = ToastMessage(text: "Saved to Memory")
    }

    /// The word without the punctuation around it.
    static func clean(_ word: String) -> String {
        word.trimmingCharacters(in: .punctuationCharacters.union(.whitespaces))
    }
}

/// What the widgets will show, with the learner's own word and review count.
private struct WidgetPreviews: View {
    @Query(sort: \MemoryItem.createdAt, order: .reverse) private var items: [MemoryItem]

    private var word: MemoryItem? { items.first { $0.kind != .mistake } }
    private var due: Int { items.filter { $0.isDue() }.count }

    var body: some View {
        GlassEffectContainer(spacing: 0) {
            HStack(spacing: Spacing.grid) {
                widget("Word of the day") {
                    if let word {
                        Text(verbatim: word.article.trimmingCharacters(in: .whitespaces))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(verbatim: word.word)
                            .font(.title3.weight(.semibold))
                            .lineLimit(2)
                            .minimumScaleFactor(0.7)
                        Text(verbatim: word.meaning)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    } else {
                        Text("Your first saved word appears here.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                widget("Review") {
                    Text(due, format: .number)
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                    Text("ready to review")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func widget(_ title: LocalizedStringKey, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption.weight(.semibold))
                .textCase(.uppercase)
                .tracking(0.6)
                .foregroundStyle(.accent)
            Spacer(minLength: 8)
            content()
        }
        .padding(Spacing.card)
        .frame(maxWidth: .infinity, minHeight: 150, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: 28, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

/// What the learner will be able to say to Siri. Shown, not started.
private struct SiriPhrases: View {
    private let phrases: [LocalizedStringKey] = [
        "“Start a German speaking session.”",
        "“Review my saved words.”",
        "“Practise for two minutes.”"
    ]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(phrases.enumerated()), id: \.offset) { index, phrase in
                if index > 0 { Divider().padding(.leading, Spacing.card) }
                HStack(spacing: Spacing.grid) {
                    Image(systemName: "mic.fill")
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                    Text(phrase)
                        .font(.body)
                        .italic()
                    Spacer(minLength: 0)
                }
                .padding(Spacing.card)
            }
        }
        .foregroundStyle(.secondary)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

#Preview {
    NavigationStack { BeyondView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}

#Preview("Nothing saved") {
    NavigationStack { BeyondView() }
        .environment(AppState())
        .modelContainer(try! AlltagStore.makeContainer(inMemory: true)) // swiftlint:disable:this force_try
}
