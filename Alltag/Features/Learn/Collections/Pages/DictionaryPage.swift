//
//  DictionaryPage.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Page design 4, "Dictionary": a cover set in big type, today's word on its
/// own card, then every word A to Z like a small dictionary.
struct DictionaryPage: View {
    let page: CollectionPage

    /// The words by their first letter, ignoring the article.
    private var letters: [LetterGroup] {
        let groups = Dictionary(grouping: page.words) { String($0.word.prefix(1)).uppercased() }
        return groups.keys.sorted().map { key in
            LetterGroup(letter: key,
                        words: (groups[key] ?? []).sorted { $0.word.localizedCompare($1.word) == .orderedAscending })
        }
    }

    /// One word a day, the same all day.
    private var wordOfTheDay: CollectionWord? {
        guard !page.words.isEmpty else { return nil }
        let day = Calendar.current.ordinality(of: .day, in: .year, for: .now) ?? 0
        return page.words[day % page.words.count]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.section) {
                cover
                if let word = wordOfTheDay {
                    WordOfTheDayCard(word: word)
                }
                ForEach(letters) { group in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(verbatim: group.letter)
                            .font(.system(size: 34, weight: .heavy, design: .rounded))
                            .foregroundStyle(.accent)
                        ForEach(group.words) { word in
                            DictionaryEntry(word: word, isSaved: page.isSaved(word))
                        }
                    }
                }
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
    }

    private var cover: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                CollectionLevelBadge(level: page.collection.level)
                Text(page.collection.category.title)
                    .textRole(.eyebrow)
                    .foregroundStyle(.secondary)
            }
            Text(verbatim: page.collection.title)
                .font(.system(size: 46, weight: .heavy, design: .rounded))
                .lineLimit(2)
                .minimumScaleFactor(0.6)
            Text(page.collection.subtitle)
                .font(.title3)
                .foregroundStyle(.secondary)
            Button(action: page.toggle) {
                if page.isAdded {
                    Label("Remove from Memory", systemImage: "checkmark")
                } else {
                    Label("Save to Memory", systemImage: "plus")
                }
            }
            .buttonStyle(.primaryCompact)
            .padding(.top, 6)
        }
    }
}

private struct LetterGroup: Identifiable {
    let letter: String
    let words: [CollectionWord]
    var id: String { letter }
}

private struct WordOfTheDayCard: View {
    let word: CollectionWord

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Word of the day")
                    .textRole(.eyebrow)
                    .foregroundStyle(.accent)
                Spacer()
                SpeakButton(text: word.displayWord)
            }
            ArticleWord(word: word, font: .largeTitle.weight(.bold))
            Text(verbatim: word.meaning)
                .font(.title3)
                .foregroundStyle(.secondary)
            Text(word.highlightedExample)
            Text(verbatim: word.exampleMeaning)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

private struct DictionaryEntry: View {
    let word: CollectionWord
    let isSaved: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                ArticleWord(word: word)
                Text(verbatim: word.meaning)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer(minLength: 4)
                if isSaved {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.accent)
                        .accessibilityLabel(Text("Saved to Memory"))
                }
            }
            Text(verbatim: word.example)
                .font(.footnote)
                .italic()
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}
