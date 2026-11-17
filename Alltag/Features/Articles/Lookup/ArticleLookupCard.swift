//
//  ArticleLookupCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import SwiftData
import SwiftUI

/// "Look up a word": a noun or its meaning in the field, and its article,
/// plural, meaning and an example in a glass card below, to save to Memory.
struct ArticleLookupCard: View {
    let level: Level
    @Bindable var model: ArticleLookupModel
    /// The screen's, so a tap or a scroll anywhere on it lowers the keyboard.
    var isFieldFocused: FocusState<Bool>.Binding
    @Environment(\.services) private var services
    @Environment(\.modelContext) private var context
    @Environment(\.reducesMotion) private var reduceMotion
    /// Counts the field's taps, searches and clears, for the medium haptic tap.
    @State private var taps = 0

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.grid) {
            field
            results
                .fieldFocusBackdrop(isActive: isFieldFocused.wrappedValue) { isFieldFocused.wrappedValue = false }
        }
        // The screen animates the change (ArticlesView), so the clues below move with the cards.
        .onChange(of: model.text) { _, _ in model.textChanged() }
        .onChange(of: model.answer?.nouns) { _, _ in model.refreshSaved(in: context) }
        .onChange(of: isFieldFocused.wrappedValue) { _, focused in if focused { taps += 1 } }
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
        .onDisappear { model.stop() }
    }

    @ViewBuilder private var results: some View {
        if model.isLookingUp {
            ArticleSearching(query: model.query)
                .transition(ArticleLookupMotion.card(reduceMotion: reduceMotion))
        } else if let failure = model.failure {
            CloudFailureCard(failure: failure, failedTitle: Text("Couldn’t look it up")) {
                taps += 1
                model.lookUp(level: level, with: services.articles)
            }
            .transition(ArticleLookupMotion.card(reduceMotion: reduceMotion))
        } else if model.foundNothing {
            StateCard(systemImage: "questionmark",
                      title: Text("No noun for „\(model.query)“"),
                      explanation: (model.answer?.note).flatMap { $0.isEmpty ? nil : Text(verbatim: $0) }
                          ?? Text("Check the spelling, or type what it means in English."))
            .transition(ArticleLookupMotion.card(reduceMotion: reduceMotion))
        } else if let answer = model.answer {
            if !answer.note.isEmpty {
                Text(verbatim: answer.note)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
                    .transition(ArticleLookupMotion.card(reduceMotion: reduceMotion))
            }
            ForEach(Array(answer.nouns.enumerated()), id: \.element.id) { index, noun in
                ArticleWordCard(noun: noun, isSaved: model.saved.contains(noun.id)) {
                    model.toggleSave(noun, in: context)
                }
                .transition(ArticleLookupMotion.card(index: index + 1, reduceMotion: reduceMotion))
            }
        }
    }

    /// The field of "How do I say …?", with the round button that looks the word up.
    private var field: some View {
        GlassInputField(systemImage: "magnifyingglass", prompt: "A noun, or what it means", text: $model.text,
                        isFocused: isFieldFocused, submitLabel: .search, sendLabel: "Look up a word",
                        canSend: !model.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !model.isLookingUp,
                        onSend: lookUp, onClear: clear)
            .autocorrectionDisabled()
            // The same opening effect as "How do I say …?" on Learn.
            .fieldFocusEffect(isActive: isFieldFocused.wrappedValue)
    }

    private func lookUp() {
        taps += 1
        isFieldFocused.wrappedValue = false
        model.lookUp(level: level, with: services.articles)
    }

    /// Done with the word: the field empties, the cards fold away and the keyboard goes down.
    private func clear() {
        taps += 1
        isFieldFocused.wrappedValue = false
        model.text = ""
    }
}

/// While the word is on its way: a card in the shape of the answer, still blank.
private struct ArticleSearching: View {
    let query: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label {
                Text("Looking up „\(query)“…")
            } icon: {
                ProgressView().controlSize(.small)
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 8) {
                Text(verbatim: "die Wohnung").font(.title2.weight(.bold))
                Text(verbatim: "flat, apartment").font(.title3)
                Text(verbatim: "Plural: die Wohnungen").font(.subheadline)
                Text(verbatim: "Die Wohnung hat zwei Zimmer und einen Balkon.").font(.body)
            }
            .redacted(reason: .placeholder)
            .accessibilityHidden(true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// A noun with its article in the theme colour, its meaning, plural, note and example.
/// The round's answer card uses it.
struct ArticleNounDetail: View {
    let noun: Noun

    /// So VoiceOver reads the German words as German.
    static let german = Locale(identifier: "de")

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(verbatim: "\(noun.article.rawValue) \(noun.word)")
                .font(.title2.weight(.bold))
                .foregroundStyle(.accent)
                .environment(\.locale, Self.german)
            Text(verbatim: noun.meaning)
                .font(.title3)
            if noun.hasPlural {
                // Localised text: the German locale stays on the German words only.
                Text("Plural: die \(noun.plural)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            if !noun.explanation.isEmpty {
                Text(verbatim: noun.explanation)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
            if !noun.example.isEmpty {
                Text(verbatim: noun.example)
                    .font(.body.italic())
                    .padding(.top, 4)
                    .environment(\.locale, Self.german)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    @Previewable @FocusState var isFocused: Bool
    ScrollView {
        ArticleLookupCard(level: .a2, model: ArticleLookupModel(), isFieldFocused: $isFocused)
            .padding(Spacing.screen)
    }
    .skyBackground()
    .fontDesign(.rounded)
    .modelContainer(AlltagStore.preview)
}
