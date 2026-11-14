//
//  MistakeQuestionViews.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftUI

/// What the learner said, with where they said it, on a glass card.
struct MistakeSaidCard: View {
    let question: MistakeQuestion
    /// Underline the wrong words in coral. Off where spotting them is the task.
    var marksWrongWords = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label {
                Text(verbatim: question.source).lineLimit(1)
            } icon: {
                Image(systemName: "waveform")
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.accent)
            Group {
                if marksWrongWords {
                    MistakePractice.quote(said: question.said, correction: question.correction)
                } else {
                    Text(verbatim: "„\(question.said)“")
                }
            }
            .font(.title3.weight(.medium))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .environment(\.locale, Locale(identifier: "de"))
    }
}

// MARK: - 1 · Which sounds natural?

/// What was said against the correction: pick the one that sounds natural.
struct MistakeChoice: View {
    let question: MistakeQuestion
    let onAnswer: (Bool) -> Void
    @State private var picked: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            MistakeSaidCard(question: question)
            ForEach(question.options.indices, id: \.self) { option in
                OptionButton(text: question.options[option], state: state(of: option)) {
                    picked = option
                    onAnswer(option == question.correctIndex)
                }
            }
        }
        .environment(\.locale, Locale(identifier: "de"))
    }

    private func state(of option: Int) -> ActivityModel.OptionState {
        guard let picked else { return .open }
        if option == question.correctIndex { return .right }
        return option == picked ? .wrong : .dimmed
    }
}

// MARK: - 2 · Tap the wrong word, then pick the fix

/// The sentence as words to tap: find the one that's wrong, then choose what
/// should stand there. Tapping a word that is fine counts as wrong.
struct MistakeSpot: View {
    let question: MistakeQuestion
    let onAnswer: (Bool) -> Void
    @State private var tapped: Int?
    @State private var pickedFix: Int?

    private var foundIt: Bool { tapped.map(question.wrongWords.contains) ?? false }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                Label {
                    Text(verbatim: question.source).lineLimit(1)
                } icon: {
                    Image(systemName: "waveform")
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.accent)
                FlowLayout(spacing: 8) {
                    ForEach(question.saidWords.indices, id: \.self) { index in
                        Button { tap(index) } label: { word(index) }
                            .buttonStyle(.plain)
                    }
                }
                .allowsHitTesting(tapped == nil)
            }
            .padding(Spacing.cardLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))

            if foundIt, !question.fixOptions.isEmpty {
                Text("What should it be?")
                    .textRole(.cardTitle)
                    .transition(.opacity)
                ForEach(question.fixOptions.indices, id: \.self) { option in
                    OptionButton(text: question.fixOptions[option], state: state(ofFix: option)) {
                        pickedFix = option
                        onAnswer(option == question.fixIndex)
                    }
                    .transition(.opacity)
                }
            }
        }
        .environment(\.locale, Locale(identifier: "de"))
        .animation(.easeOut(duration: 0.25), value: tapped)
        .sensoryFeedback(.impact(weight: .medium), trigger: foundIt) { _, found in found }
    }

    private func tap(_ index: Int) {
        tapped = index
        if !question.wrongWords.contains(index) {
            onAnswer(false)
        } else if question.fixOptions.isEmpty {
            onAnswer(true)
        }
    }

    /// A word: plain until one is tapped; then the wrong ones in coral, and a wrongly tapped one faded.
    private func word(_ index: Int) -> some View {
        let isWrong = question.wrongWords.contains(index)
        let revealed = tapped != nil && isWrong
        return Text(verbatim: question.saidWords[index])
            .font(.title3.weight(.medium))
            .strikethrough(revealed, color: .mistake)
            .foregroundStyle(.primary)
            .padding(.horizontal, 12)
            .frame(minHeight: 44)
            .background(revealed ? AnyShapeStyle(.mistake.opacity(0.22)) : AnyShapeStyle(.controlFill), in: .capsule)
            .overlay { Capsule().strokeBorder(revealed ? AnyShapeStyle(.mistake.opacity(0.6)) : AnyShapeStyle(.clear), lineWidth: 1.5) }
            .opacity(tapped == index && !isWrong ? 0.45 : 1)
            .contentShape(.capsule)
            .accessibilityValue(revealed ? Text("Wrong") : Text(verbatim: ""))
    }

    private func state(ofFix option: Int) -> ActivityModel.OptionState {
        guard let pickedFix else { return .open }
        if option == question.fixIndex { return .right }
        return option == pickedFix ? .wrong : .dimmed
    }
}

// MARK: - 3 · Build it from tiles

/// The correction's words as tiles, with the wrong word among them: tap them
/// in order. It is checked when the last place is filled.
struct MistakeBuild: View {
    let question: MistakeQuestion
    let onAnswer: (Bool) -> Void
    /// The tiles placed so far, by their place in `question.tiles`.
    @State private var placed: [Int] = []
    @State private var isRight: Bool?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            MistakeSaidCard(question: question, marksWrongWords: true)
            FlowLayout(spacing: 8) {
                if placed.isEmpty {
                    Text("Tap the words in order")
                        .font(.title3)
                        .foregroundStyle(.tertiary)
                        .frame(minHeight: 44)
                }
                ForEach(placed, id: \.self) { tile in
                    Button { placed.removeAll { $0 == tile } } label: { self.tile(tile, isPlaced: true) }
                        .buttonStyle(.plain)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
            .padding(Spacing.card)
            .background(trayFill, in: .rect(cornerRadius: 26, style: .continuous))
            .glassEffect(.regular, in: .rect(cornerRadius: 26, style: .continuous))

            FlowLayout(spacing: 8) {
                ForEach(question.tiles.indices, id: \.self) { tile in
                    Button { place(tile) } label: { self.tile(tile, isPlaced: false) }
                        .buttonStyle(.plain)
                        // Keeps its place, so the others don't jump.
                        .opacity(placed.contains(tile) ? 0 : 1)
                        .disabled(placed.contains(tile))
                }
            }
        }
        .allowsHitTesting(isRight == nil)
        .environment(\.locale, Locale(identifier: "de"))
        .animation(.easeOut(duration: 0.2), value: placed)
        .sensoryFeedback(.selection, trigger: placed)
    }

    private var trayFill: AnyShapeStyle {
        switch isRight {
        case true?: AnyShapeStyle(.success.opacity(0.22))
        case false?: AnyShapeStyle(.mistake.opacity(0.22))
        case nil: AnyShapeStyle(.clear)
        }
    }

    private func place(_ tile: Int) {
        placed.append(tile)
        guard placed.count == question.correctionWords.count else { return }
        let right = question.isBuilt(placed.map { question.tiles[$0] })
        isRight = right
        onAnswer(right)
    }

    private func tile(_ tile: Int, isPlaced: Bool) -> some View {
        Text(verbatim: question.tiles[tile])
            .font(.title3.weight(.medium))
            .foregroundStyle(.primary)
            .padding(.horizontal, 14)
            .frame(minHeight: 44)
            .background(isPlaced ? AnyShapeStyle(.accentFill.opacity(0.18)) : AnyShapeStyle(.clear), in: .capsule)
            .glassEffect(.regular.interactive(), in: .capsule)
            .contentShape(.capsule)
    }
}
