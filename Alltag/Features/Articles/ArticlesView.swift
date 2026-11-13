//
//  ArticlesView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftData
import SwiftUI

/// Articles: look up whether a word is der, die or das, and train the
/// articles of the nouns for the learner's level and their own saved words.
struct ArticlesView: View {
    var level: Level = .a1
    @Query private var items: [MemoryItem]
    @State private var toast: ToastMessage?

    /// Alltag's nouns up to the learner's level, with their own saved nouns first.
    private var nouns: [Noun] {
        let own = Nouns.saved(in: items)
        return own + Nouns.nouns(upTo: level).filter { noun in !own.contains { $0.word == noun.word } }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.section) {
                ArticleLookupSection(nouns: nouns, toast: $toast)
                VStack(alignment: .leading, spacing: 10) {
                    Text("Train")
                        .textRole(.sectionHeader)
                        .padding(.horizontal, 4)
                        .accessibilityAddTraits(.isHeader)
                    ArticleTrainerCard(nouns: nouns)
                }
            }
            .padding(Spacing.screen)
        }
        .fontDesign(.rounded)
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .readableContentMargins()
        .skyBackground()
        .navigationTitle("Articles")
        .toolbarTitleDisplayMode(.inlineLarge)
        .toast($toast)
    }
}

// MARK: - Look up

/// Type a word, get its article: from Alltag's nouns at once, from the
/// translation service for anything else.
private struct ArticleLookupSection: View {
    let nouns: [Noun]
    @Binding var toast: ToastMessage?
    @Environment(\.services) private var services
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [MemoryItem]

    @State private var text = ""
    @State private var answer: ArticleLookup.Answer?
    @State private var isSearching = false
    @State private var search: Task<Void, Never>?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.accent)
                    .accessibilityHidden(true)
                TextField("der, die or das? Type a word", text: $text)
                    .font(.title3)
                    .submitLabel(.search)
                    .autocorrectionDisabled()
                    .onSubmit(find)
                if !text.isEmpty {
                    Button("Clear", systemImage: "xmark.circle.fill") { text = "" }
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 20)
            .frame(height: 60)
            .glassEffect(.regular, in: .capsule)

            if isSearching {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(Spacing.card)
            } else if let answer {
                result(answer)
                    .padding(Spacing.cardLarge)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
                    .transition(.opacity)
            }
        }
        .animation(.easeOut(duration: 0.2), value: answer)
        .onChange(of: text) { _, _ in
            search?.cancel()
            isSearching = false
            // Alltag's own nouns answer while typing; anything else waits for Return.
            answer = ArticleLookup.local(text, in: nouns).map { .found($0) }
        }
    }

    @ViewBuilder
    private func result(_ answer: ArticleLookup.Answer) -> some View {
        switch answer {
        case .found(let noun):
            VStack(alignment: .leading, spacing: 10) {
                NounLine(noun: noun)
                let isSaved = items.contains { $0.word == noun.word }
                Button(isSaved ? "Saved" : "Save for practice", systemImage: isSaved ? "checkmark" : "bookmark") { save(noun) }
                    .buttonStyle(.glass)
                    .disabled(isSaved)
            }
        case let .notANoun(german, meaning):
            VStack(alignment: .leading, spacing: 4) {
                Text(verbatim: german)
                    .font(.title3.weight(.semibold))
                Text(verbatim: meaning)
                    .foregroundStyle(.secondary)
                Text("This isn't a noun, so it has no article.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
        case .unknown:
            Text("I couldn't find this word. Check the spelling, or your connection.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private func find() {
        guard answer == nil, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let asked = text
        isSearching = true
        search = Task {
            let found = await ArticleLookup.find(asked, in: nouns, translation: services.translation)
            guard !Task.isCancelled, text == asked else { return }
            answer = found
            isSearching = false
        }
    }

    private func save(_ noun: Noun) {
        modelContext.insert(MemoryItem(article: noun.article.rawValue + " ", word: noun.word, meaning: noun.meaning,
                                       kind: .saved, source: .translate))
        try? modelContext.save()
        toast = ToastMessage(text: "Saved to Memory")
    }
}

/// "die Apotheke" with the article in the theme colour, its plural and its meaning.
private struct NounLine: View {
    let noun: Noun

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(verbatim: noun.article.rawValue)
                    .foregroundStyle(.accent)
                Text(verbatim: noun.word)
            }
            .font(.system(size: 30, weight: .bold, design: .rounded))
            .minimumScaleFactor(0.6)
            .lineLimit(1)
            if noun.hasPlural {
                Text(verbatim: "die \(noun.plural)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .accessibilityLabel(Text("Plural: die \(noun.plural)"))
            }
            if !noun.meaning.isEmpty {
                Text(verbatim: noun.meaning)
                    .foregroundStyle(.secondary)
            }
        }
        .environment(\.locale, Locale(identifier: "de"))
        .accessibilityElement(children: .combine)
    }
}

// MARK: - Train

/// The trainer: one noun at a time, three choices, the answer straight away,
/// and a short summary after the round.
private struct ArticleTrainerCard: View {
    let nouns: [Noun]
    @Environment(\.modelContext) private var modelContext
    @State private var trainer: ArticleTrainer?

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            if let trainer {
                if trainer.isDone {
                    summary(trainer)
                } else if let noun = trainer.current {
                    question(noun, trainer: trainer)
                }
            } else {
                start
            }
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .animation(.easeOut(duration: 0.2), value: trainer?.index)
        .animation(.easeOut(duration: 0.2), value: trainer?.picked)
        .sensoryFeedback(trigger: trainer?.picked) { _, picked in
            guard picked != nil, let right = trainer?.isRight else { return nil }
            return right ? .success : .error
        }
        .onChange(of: trainer?.isDone) { _, done in
            if done == true { trainer?.recordPractice(in: modelContext) }
        }
    }

    private var start: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(verbatim: "der, die oder das?")
                        .font(.title3.weight(.semibold))
                    Text("^[\(ArticleTrainer.roundSize) noun](inflect: true) for your level and from your saved words.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                ScenarioArtwork(systemImage: "textformat.abc")
                    .frame(width: 88, height: 88)
            }
            Button { newRound() } label: { Label("Start", systemImage: "play.fill") }
                .buttonStyle(.primary)
        }
    }

    private func question(_ noun: Noun, trainer: ArticleTrainer) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            ProgressView(value: trainer.progress)
                .tint(.accentFill)
                .accessibilityLabel(Text("Progress"))
            VStack(spacing: 6) {
                if trainer.picked == nil {
                    Text(verbatim: noun.word)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    Text(verbatim: noun.meaning)
                        .foregroundStyle(.secondary)
                } else {
                    NounLine(noun: noun)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 110)
            .environment(\.locale, Locale(identifier: "de"))

            GlassEffectContainer(spacing: 10) {
                HStack(spacing: 10) {
                    ForEach(Article.allCases) { article in
                        ArticleChoice(article: article, picked: trainer.picked, right: noun.article) { trainer.pick(article) }
                    }
                }
            }
            Button { trainer.next() } label: { Text("Next") }
                .buttonStyle(.primary)
                .disabled(trainer.picked == nil)
        }
    }

    private func summary(_ trainer: ArticleTrainer) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("\(trainer.rightFirstTime) of \(trainer.total) right first time")
                .font(.title2.weight(.bold))
            if trainer.missed.isEmpty {
                Text("Every article right. These nouns are yours.")
                    .foregroundStyle(.secondary)
            } else {
                Text("These come back next time:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(trainer.missed) { noun in
                        HStack(spacing: 6) {
                            Text(verbatim: noun.article.rawValue).foregroundStyle(.accent)
                            Text(verbatim: noun.word)
                            Text(verbatim: "· \(noun.meaning)").foregroundStyle(.secondary)
                        }
                        .font(.headline)
                    }
                }
                .environment(\.locale, Locale(identifier: "de"))
            }
            Button { newRound() } label: { Label("Another round", systemImage: "arrow.counterclockwise") }
                .buttonStyle(.primary)
        }
    }

    private func newRound() {
        var generator = SystemRandomNumberGenerator()
        trainer = ArticleTrainer(nouns: nouns, using: &generator)
    }
}

/// One of der, die, das: glass until picked, then green for the right one and coral for a wrong pick.
private struct ArticleChoice: View {
    let article: Article
    let picked: Article?
    let right: Article
    let action: () -> Void

    private var shape: RoundedRectangle { RoundedRectangle(cornerRadius: 22, style: .continuous) }

    private var tint: Color? {
        guard let picked else { return nil }
        if article == right { return .success }
        return article == picked ? .mistake : nil
    }

    var body: some View {
        Button(action: action) {
            Text(verbatim: article.rawValue)
                .font(.title2.weight(.bold))
                .frame(maxWidth: .infinity, minHeight: 60)
                .background((tint ?? .clear).opacity(0.22), in: shape)
                .overlay { shape.strokeBorder((tint ?? .clear).opacity(0.6), lineWidth: 1.5) }
                .glassEffect(picked == nil ? .regular.interactive() : .regular, in: shape)
                .opacity(picked != nil && tint == nil ? 0.45 : 1)
                .contentShape(shape)
        }
        .buttonStyle(.plain)
        .allowsHitTesting(picked == nil)
        .accessibilityValue(tint == .success ? Text("Correct") : tint == .mistake ? Text("Wrong") : Text(verbatim: ""))
    }
}

#Preview {
    NavigationStack { ArticlesView(level: .a2) }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
