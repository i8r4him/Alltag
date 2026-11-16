//
//  FlashcardWords.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Layout 1: one card at a time, like a pile of flashcards. The word is on
/// the front; tap to turn it over for the meaning and the sentence. Swipe or
/// use the arrows for the next card.
struct FlashcardWords: View {
    let words: [CollectionWord]

    @State private var index = 0
    @State private var isTurned = false
    @State private var drag: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @ScaledMetric(relativeTo: .largeTitle) private var height: CGFloat = 300

    var body: some View {
        VStack(spacing: 18) {
            if words.indices.contains(index) {
                ZStack {
                    StackLayers(angles: [-4, 3])
                    card(for: words[index])
                        .offset(x: drag)
                        .rotationEffect(.degrees(Double(drag) / 30))
                }
                .frame(height: height)
                .padding(.horizontal, 8)
                .simultaneousGesture(swipe)
            }
            HStack(spacing: 16) {
                GlassEffectContainer(spacing: 16) {
                    HStack(spacing: 16) {
                        Button("Previous word", systemImage: "chevron.left") { move(by: -1) }
                            .disabled(index == 0)
                        Text(verbatim: "\(index + 1) / \(words.count)")
                            .font(.headline.monospacedDigit())
                            .frame(minWidth: 64)
                        Button("Next word", systemImage: "chevron.right") { move(by: 1) }
                            .disabled(index >= words.count - 1)
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.glass)
                    .controlSize(.large)
                }
            }
        }
        .sensoryFeedback(.selection, trigger: index)
        .sensoryFeedback(.impact(weight: .medium), trigger: isTurned)
    }

    private func card(for word: CollectionWord) -> some View {
        ZStack {
            FlashcardFront(word: word)
                .opacity(isTurned ? 0 : 1)
            FlashcardBack(word: word)
                .opacity(isTurned ? 1 : 0)
                .rotation3DEffect(.degrees(reduceMotion ? 0 : 180), axis: (x: 0, y: 1, z: 0))
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
        .rotation3DEffect(.degrees(isTurned && !reduceMotion ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .contentShape(.rect(cornerRadius: Radius.card, style: .continuous))
        .onTapGesture {
            withAnimation(.smooth(duration: 0.4)) { isTurned.toggle() }
        }
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(Text("Tap to turn over"))
    }

    private var swipe: some Gesture {
        DragGesture(minimumDistance: 16)
            .onChanged { value in
                guard abs(value.translation.width) > abs(value.translation.height) else { return }
                drag = value.translation.width
            }
            .onEnded { _ in
                let step = drag < -80 ? 1 : (drag > 80 ? -1 : 0)
                withAnimation(.snappy) { drag = 0 }
                if step != 0 { move(by: step) }
            }
    }

    private func move(by step: Int) {
        let next = index + step
        guard words.indices.contains(next) else { return }
        withAnimation(.snappy) {
            isTurned = false
            index = next
        }
    }
}

private struct FlashcardFront: View {
    let word: CollectionWord

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Spacer()
                SpeakButton(text: word.displayWord)
            }
            Spacer()
            if word.isNoun {
                Text(verbatim: word.article.trimmingCharacters(in: .whitespaces))
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.accent)
            }
            Text(verbatim: word.word)
                .font(.largeTitle.weight(.bold))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Spacer()
            Text("Tap to turn over")
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
    }
}

private struct FlashcardBack: View {
    let word: CollectionWord

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ArticleWord(word: word, font: .title3.weight(.semibold))
            Text(verbatim: word.meaning)
                .font(.title2.weight(.bold))
            Divider()
            Text(word.highlightedExample)
                .font(.body)
            Text(verbatim: word.exampleMeaning)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer(minLength: 0)
            HStack {
                Spacer()
                SpeakButton(text: word.example)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
