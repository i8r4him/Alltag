//
//  ReaderWordCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The tapped word: its dictionary form with the article in the theme colour,
/// the meaning, a grammar note and an example, with buttons to hear it and to
/// save it. Without a background: the reader puts it on a glass card.
struct ReaderWordCard: View {
    let word: ReadingWord
    let lookup: ReaderModel.Lookup
    let isSaved: Bool
    var onListen: (String) -> Void = { _ in }
    var onToggleSave: () -> Void = {}
    var onRetry: () -> Void = {}
    var onDownload: () -> Void = {}
    /// Shows a close button; the previews leave it out.
    var onClose: (() -> Void)?

    static let german = Locale(identifier: "de")

    var body: some View {
        Group {
            switch lookup {
            case .loading:
                loading
            case .found(let meaning):
                found(meaning)
            case .needsDownload:
                ReaderWordState(systemImage: "arrow.down.circle", title: Text("Download the languages"),
                                explanation: Text("Download English and German once to translate privately on your iPhone."),
                                action: StateCard.Action(title: "Download languages", systemImage: "arrow.down.circle",
                                                         run: onDownload),
                                onClose: onClose)
            case .failed(let failure):
                failed(failure)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .animation(.easeOut(duration: 0.2), value: lookup)
    }

    private func found(_ meaning: ReadingMeaning) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(verbatim: meaning.display)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.accent)
                        .environment(\.locale, Self.german)
                    if meaning.word.caseInsensitiveCompare(word.word) != .orderedSame {
                        Text("In the text: „\(Text(verbatim: word.word))“")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Text(verbatim: meaning.meaning)
                        .font(.title3)
                    if !meaning.grammar.isEmpty {
                        Text(verbatim: meaning.grammar)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                buttons(meaning)
            }
            if let example = meaning.example {
                Divider()
                Label {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(verbatim: example.german)
                            .italic()
                            .environment(\.locale, Self.german)
                        Text(verbatim: example.english)
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: "quote.opening").foregroundStyle(.accent)
                }
                .font(.subheadline)
                .accessibilityElement(children: .combine)
            }
        }
    }

    /// Hear the word, save it, and close: glass circles side by side.
    private func buttons(_ meaning: ReadingMeaning) -> some View {
        GlassEffectContainer(spacing: 8) {
            HStack(spacing: 8) {
                Button {
                    onListen(meaning.display)
                } label: {
                    ListenIcon(text: meaning.display)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.accent)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .glassEffect(.regular.interactive(), in: .circle)
                .accessibilityLabel(Text("Listen"))
                ArticleBookmarkButton(isSaved: isSaved, action: onToggleSave)
                if let onClose {
                    ReaderCloseButton(action: onClose)
                }
            }
        }
    }

    /// While the word is on its way: a card in the shape of the answer, still blank.
    private var loading: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Label {
                    Text("Translating „\(Text(verbatim: word.word))“…")
                } icon: {
                    ProgressView().controlSize(.small)
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                if let onClose {
                    ReaderCloseButton(action: onClose)
                }
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(verbatim: "die Wohnung").font(.title2.weight(.bold))
                Text(verbatim: "flat, apartment").font(.title3)
                Text(verbatim: "noun · pl. Wohnungen").font(.subheadline)
            }
            .redacted(reason: .placeholder)
            .accessibilityHidden(true)
        }
    }

    @ViewBuilder
    private func failed(_ failure: CloudFailure) -> some View {
        switch failure {
        case .offline:
            ReaderWordState(systemImage: "wifi.slash", title: Text("You’re offline"),
                            explanation: Text("This needs the internet. Connect to Wi‑Fi or mobile data."),
                            action: .tryAgain(onRetry), onClose: onClose)
        case .cloudOff:
            ReaderWordState(systemImage: "icloud.slash", title: Text("Online help is off"),
                            explanation: Text("Turn on “Talk and get corrections online” in Settings to use this."),
                            onClose: onClose)
        case .dailyLimit:
            ReaderWordState(systemImage: "hourglass", title: Text("That’s all for today"),
                            explanation: Text("You’ve used today’s online help. Try again tomorrow."),
                            onClose: onClose)
        case .other:
            ReaderWordState(systemImage: "exclamationmark.triangle",
                            title: Text("Couldn’t translate „\(Text(verbatim: word.word))“"),
                            explanation: Text("Something went wrong on the way. Try again in a moment."),
                            action: .tryAgain(onRetry), onClose: onClose)
        }
    }
}

/// A state of the word card that isn't the answer: the symbol, what happened,
/// and a glass button when there is something to do.
private struct ReaderWordState: View {
    let systemImage: String
    let title: Text
    let explanation: Text
    var action: StateCard.Action?
    var onClose: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundStyle(.accent)
                    .frame(width: 32)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 4) {
                    title.font(.headline)
                    explanation
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                if let onClose {
                    ReaderCloseButton(action: onClose)
                }
            }
            if let action {
                Button(action: action.run) {
                    Label { Text(action.title) } icon: { Image(systemName: action.systemImage) }
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 34)
                }
                .buttonStyle(.glass)
            }
        }
    }
}

/// Closes the word card.
private struct ReaderCloseButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.body.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .circle)
        .accessibilityLabel(Text("Close"))
    }
}

#Preview {
    let word = ReadingWord(id: 0, written: "Nebenkostenabrechnung", word: "Nebenkostenabrechnung", sentence: "")
    let meaning = ReadingMeaning(article: "die ", word: "Nebenkostenabrechnung", meaning: "service charge statement",
                                 grammar: "noun · pl. Nebenkostenabrechnungen",
                                 example: .init(german: "Die Nebenkostenabrechnung kommt im Frühling.",
                                                english: "The service charge statement arrives in spring."))
    return ScrollView {
        VStack(spacing: 16) {
            ForEach([ReaderModel.Lookup.found(meaning), .loading, .failed(.offline)], id: \.self) { lookup in
                ReaderWordCard(word: word, lookup: lookup, isSaved: false, onClose: {})
                    .padding(Spacing.cardLarge)
                    .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
            }
        }
        .padding(Spacing.screen)
    }
    .skyBackground()
    .fontDesign(.rounded)
}
