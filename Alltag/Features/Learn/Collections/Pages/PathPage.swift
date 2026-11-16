//
//  PathPage.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Page design 3, "Path": a ring for how many words are in Memory, then the
/// words in rounds of five along a path. Each round can be saved on its own.
struct PathPage: View {
    let page: CollectionPage

    private var rounds: [[CollectionWord]] {
        stride(from: 0, to: page.words.count, by: 5).map { Array(page.words[$0..<min($0 + 5, page.words.count)]) }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.section) {
                PathHeader(page: page)
                ForEach(Array(rounds.enumerated()), id: \.offset) { index, words in
                    PathRound(number: index + 1, words: words, page: page)
                }
                SaveCollectionButton(page: page)
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
    }
}

private struct PathHeader: View {
    let page: CollectionPage

    var body: some View {
        let total = page.words.count
        let saved = page.words.filter(page.isSaved).count
        HStack(spacing: 18) {
            ZStack {
                Circle()
                    .stroke(Color.controlFill, lineWidth: 10)
                Circle()
                    .trim(from: 0, to: total > 0 ? CGFloat(saved) / CGFloat(total) : 0)
                    .stroke(Color.accentFill, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                Image(systemName: page.collection.systemImage)
                    .font(.title2)
                    .foregroundStyle(.accent)
            }
            .frame(width: 84, height: 84)
            .animation(.smooth, value: saved)
            VStack(alignment: .leading, spacing: 4) {
                Text(verbatim: page.collection.title)
                    .font(.title2.weight(.bold))
                Text(page.collection.subtitle)
                    .foregroundStyle(.secondary)
                Text("\(saved) of \(total) in Memory")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.accent)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

private struct PathRound: View {
    let number: Int
    let words: [CollectionWord]
    let page: CollectionPage

    var body: some View {
        let isDone = words.allSatisfy(page.isSaved)
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Round \(number)")
                    .font(.headline)
                Spacer()
                if isDone {
                    Label("In Memory", systemImage: "checkmark.circle.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.accent)
                } else {
                    Button("Save these words") { page.save(words) }
                        .buttonStyle(.primaryCompact)
                }
            }
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(words.enumerated()), id: \.element.id) { index, word in
                    PathStop(word: word, isSaved: page.isSaved(word), isLast: index == words.count - 1)
                }
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }
}

/// One stop on the path: a dot (filled once the word is in Memory), the line
/// to the next stop, and the word.
private struct PathStop: View {
    let word: CollectionWord
    let isSaved: Bool
    let isLast: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(spacing: 0) {
                Circle()
                    .fill(isSaved ? Color.accentFill : Color.clear)
                    .overlay { Circle().strokeBorder(Color.accentFill, lineWidth: 2) }
                    .frame(width: 16, height: 16)
                    .padding(.top, 3)
                if !isLast {
                    Rectangle()
                        .fill(Color.accentFill.opacity(0.35))
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }
            .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                ArticleWord(word: word)
                Text(verbatim: word.meaning)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, isLast ? 0 : 16)
            Spacer(minLength: 8)
            SpeakButton(text: word.displayWord)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}
