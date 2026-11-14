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
    @Environment(\.services) private var services
    @Environment(\.modelContext) private var context
    @FocusState private var isFieldFocused: Bool
    /// Counts the field's taps, searches and clears, for the medium haptic tap.
    @State private var taps = 0

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.grid) {
            field
            if model.isLookingUp {
                ArticleSearching(query: model.query)
                    .transition(.opacity)
            } else if let failure = model.failure {
                ArticleLookupFailed(failure: failure) {
                    taps += 1
                    model.lookUp(level: level, with: services.articles)
                }
                .transition(.opacity)
            } else if model.foundNothing {
                ArticleStateCard(systemImage: "questionmark",
                                 title: Text("No noun for „\(model.query)“"),
                                 explanation: (model.answer?.note).flatMap { $0.isEmpty ? nil : Text(verbatim: $0) }
                                    ?? Text("Check the spelling, or type what it means in English."))
                .transition(.opacity)
            } else if let answer = model.answer {
                if !answer.note.isEmpty {
                    Text(verbatim: answer.note)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 4)
                }
                ForEach(answer.nouns) { noun in
                    ArticleWordCard(noun: noun, isSaved: model.saved.contains(noun.id)) {
                        model.toggleSave(noun, in: context)
                    }
                    .transition(.opacity)
                }
            }
        }
        .animation(.easeOut(duration: 0.25), value: model.answer?.nouns)
        .animation(.easeOut(duration: 0.25), value: model.isLookingUp)
        .animation(.easeOut(duration: 0.25), value: model.failure)
        .onChange(of: model.text) { _, _ in model.textChanged() }
        .onChange(of: model.answer?.nouns) { _, _ in model.refreshSaved(in: context) }
        .onChange(of: isFieldFocused) { _, focused in if focused { taps += 1 } }
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
        .onDisappear { model.stop() }
    }

    /// The field, in the look of "How do I say …?": a glass capsule with the symbol on the left.
    private var field: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.title3)
                .foregroundStyle(.accent)
                .accessibilityHidden(true)
            TextField("A noun, or what it means", text: $model.text)
                .font(.title3)
                .focused($isFieldFocused)
                .submitLabel(.search)
                .autocorrectionDisabled()
                .onSubmit(lookUp)
            if !model.text.isEmpty {
                Button("Clear", systemImage: "xmark.circle.fill") {
                    model.text = ""
                    taps += 1
                }
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.secondary)
                    .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 60)
        .glassEffect(.regular.interactive(), in: .capsule)
    }

    private func lookUp() {
        taps += 1
        isFieldFocused = false
        model.lookUp(level: level, with: services.articles)
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

/// The word couldn't be looked up: why, in the same card as "No noun for …", and a way to try again.
private struct ArticleLookupFailed: View {
    let failure: ArticleLookupFailure
    let onRetry: () -> Void

    var body: some View {
        switch failure {
        case .offline:
            ArticleStateCard(systemImage: "wifi.slash", title: Text("You’re offline"),
                             explanation: Text("Looking up a word needs the internet. Connect to Wi‑Fi or mobile data."),
                             onRetry: onRetry)
        case .cloudOff:
            ArticleStateCard(systemImage: "icloud.slash", title: Text("Online help is off"),
                             explanation: Text("Turn on “Talk and get corrections online” in Settings to look words up."))
        case .dailyLimit:
            ArticleStateCard(systemImage: "hourglass", title: Text("That’s all for today"),
                             explanation: Text("You’ve looked up as many words as you can today. Try again tomorrow."))
        case .other:
            ArticleStateCard(systemImage: "exclamationmark.triangle", title: Text("Couldn’t look it up"),
                             explanation: Text("Something went wrong on the way. Try again in a moment."),
                             onRetry: onRetry)
        }
    }
}

/// The Focus card's layout for a state: what happened on the left, the artwork on the right,
/// and "Try again" under it when trying again can help.
private struct ArticleStateCard: View {
    let systemImage: String
    let title: Text
    let explanation: Text
    var onRetry: (() -> Void)?

    @ScaledMetric(relativeTo: .title3) private var artworkSize: CGFloat = 72

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    title.font(.title3.weight(.semibold))
                    explanation
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                ScenarioArtwork(systemImage: systemImage, symbolSize: 34, cornerRadius: 16)
                    .frame(width: artworkSize, height: artworkSize)
            }
            if let onRetry {
                Button(action: onRetry) {
                    Label("Try again", systemImage: "arrow.clockwise")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 34)
                }
                .buttonStyle(.glass)
            }
        }
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
    ScrollView {
        ArticleLookupCard(level: .a2, model: ArticleLookupModel())
            .padding(Spacing.screen)
    }
    .skyBackground()
    .fontDesign(.rounded)
    .modelContainer(AlltagStore.preview)
}
