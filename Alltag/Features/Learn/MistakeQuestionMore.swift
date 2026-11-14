//
//  MistakeQuestionMore.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftUI

/// The corrected sentence with a gap where the fix belongs. Until it is
/// revealed the gap is an empty outline; then it holds the fix, in green
/// when the answer was right and coral when it wasn't.
struct MistakeGapSentence: View {
    let question: MistakeQuestion
    /// `nil` while unanswered.
    let wasRight: Bool?

    var body: some View {
        FlowLayout(spacing: 6, lineSpacing: 10) {
            ForEach(question.correctionWords.indices, id: \.self) { index in
                if question.fixWords.contains(index) {
                    gap(question.correctionWords[index])
                } else {
                    Text(verbatim: question.correctionWords[index])
                        .font(.title2.weight(.semibold))
                        .frame(minHeight: 40)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .environment(\.locale, Locale(identifier: "de"))
        .animation(.easeOut(duration: 0.25), value: wasRight)
        .accessibilityElement(children: .combine)
    }

    private func gap(_ word: String) -> some View {
        let tint: AnyShapeStyle = switch wasRight {
        case true?: AnyShapeStyle(.success)
        case false?: AnyShapeStyle(.mistake)
        case nil: AnyShapeStyle(.accent)
        }
        return Text(verbatim: word)
            .font(.title2.weight(.semibold))
            // Hidden, not removed: the gap is as wide as its word, and nothing moves when it appears.
            .opacity(wasRight == nil ? 0 : 1)
            .padding(.horizontal, 10)
            .frame(minHeight: 40)
            .background(tint.opacity(wasRight == nil ? 0.10 : 0.22), in: .rect(cornerRadius: 12, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(tint, style: StrokeStyle(lineWidth: 1.5, dash: wasRight == nil ? [5, 4] : []))
            }
            .accessibilityLabel(wasRight == nil ? Text("Gap") : Text(verbatim: word))
    }
}

// MARK: - 4 · Fill the gap

/// The corrected sentence with a gap, and the words that could go in it as chips.
struct MistakeFill: View {
    let question: MistakeQuestion
    let onAnswer: (Bool) -> Void
    @State private var picked: Int?

    private var wasRight: Bool? { picked.map { $0 == question.fixIndex } }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            MistakeSaidCard(question: question, marksWrongWords: true)
            MistakeGapSentence(question: question, wasRight: wasRight)
            GlassEffectContainer(spacing: 10) {
                FlowLayout(spacing: 10) {
                    ForEach(question.fixOptions.indices, id: \.self) { option in
                        Button {
                            picked = option
                            onAnswer(option == question.fixIndex)
                        } label: {
                            chip(option)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .allowsHitTesting(picked == nil)
        }
        .environment(\.locale, Locale(identifier: "de"))
    }

    private func chip(_ option: Int) -> some View {
        let isRight = picked != nil && option == question.fixIndex
        let isWrong = picked == option && option != question.fixIndex
        return Text(verbatim: question.fixOptions[option])
            .font(.title3.weight(.semibold))
            .foregroundStyle(.primary)
            .padding(.horizontal, 22)
            .frame(minHeight: 52)
            .background(isRight ? AnyShapeStyle(.success.opacity(0.22)) : isWrong ? AnyShapeStyle(.mistake.opacity(0.22))
                        : AnyShapeStyle(.clear), in: .capsule)
            .glassEffect(picked == nil ? .regular.interactive() : .regular, in: .capsule)
            .opacity(picked != nil && !isRight && !isWrong ? 0.45 : 1)
            .contentShape(.capsule)
            .accessibilityValue(isRight ? Text("Correct") : isWrong ? Text("Wrong") : Text(verbatim: ""))
    }
}

// MARK: - 5 · Type what's missing

/// The corrected sentence with a gap, and a field to type the word into: recalling it, not recognising it.
struct MistakeType: View {
    let question: MistakeQuestion
    let onAnswer: (Bool) -> Void
    @State private var text = ""
    @State private var wasRight: Bool?
    @FocusState private var isFocused: Bool

    private var isEmpty: Bool { text.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            MistakeSaidCard(question: question, marksWrongWords: true)
            MistakeGapSentence(question: question, wasRight: wasRight)
            HStack(spacing: 12) {
                Image(systemName: "character.cursor.ibeam")
                    .font(.title3)
                    .foregroundStyle(.accent)
                    .accessibilityHidden(true)
                TextField("The missing word", text: $text)
                    .font(.title3)
                    .focused($isFocused)
                    .submitLabel(.done)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .onSubmit(check)
                Button("Check", systemImage: "arrow.up", action: check)
                    .labelStyle(.iconOnly)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(isEmpty ? AnyShapeStyle(.tertiary) : AnyShapeStyle(.onAccent))
                    .frame(width: 40, height: 40)
                    .background(isEmpty ? AnyShapeStyle(.controlFill) : AnyShapeStyle(.accentFill), in: .circle)
                    .buttonStyle(.plain)
                    .disabled(isEmpty)
            }
            .padding(.leading, 20)
            .padding(.trailing, 10)
            .frame(height: 60)
            .glassEffect(.regular.interactive(), in: .capsule)
            .disabled(wasRight != nil)
            .opacity(wasRight == nil ? 1 : 0.6)
        }
        .environment(\.locale, Locale(identifier: "de"))
        .onAppear { isFocused = true }
    }

    private func check() {
        guard !isEmpty, wasRight == nil else { return }
        let right = question.isFix(text)
        wasRight = right
        isFocused = false
        onAnswer(right)
    }
}

// MARK: - 6 · Flashcard

/// What was said on a card; think of the fix, turn it over, and say honestly whether you knew it.
struct MistakeFlash: View {
    let question: MistakeQuestion
    let onAnswer: (Bool) -> Void
    @State private var isRevealed = false
    @State private var answer: Bool?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 14) {
                Label {
                    Text(verbatim: question.source).lineLimit(1)
                } icon: {
                    Image(systemName: "waveform")
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.accent)
                MistakePractice.quote(said: question.said, correction: question.correction)
                    .font(.title2.weight(.semibold))
                if isRevealed {
                    Divider()
                    Label {
                        Text(verbatim: question.correction)
                    } icon: {
                        Image(systemName: "checkmark.circle.fill").foregroundStyle(.success)
                    }
                    .font(.title2.weight(.semibold))
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
            .padding(Spacing.cardLarge)
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
            .environment(\.locale, Locale(identifier: "de"))

            if !isRevealed {
                Button {
                    withAnimation(.easeOut(duration: 0.25)) { isRevealed = true }
                } label: {
                    Label("Show the fix", systemImage: "eye")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 34)
                }
                .buttonStyle(.glass)
            } else if answer == nil {
                GlassEffectContainer(spacing: 12) {
                    HStack(spacing: 12) {
                        rate("Not yet", systemImage: "arrow.uturn.backward", style: AnyShapeStyle(.mistake), right: false)
                        rate("I knew it", systemImage: "checkmark", style: AnyShapeStyle(.success), right: true)
                    }
                }
                .transition(.opacity)
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: isRevealed)
    }

    private func rate(_ title: LocalizedStringResource, systemImage: String, style: AnyShapeStyle, right: Bool) -> some View {
        Button {
            answer = right
            onAnswer(right)
        } label: {
            Label { Text(title) } icon: { Image(systemName: systemImage).foregroundStyle(style) }
                .font(.headline)
                .frame(maxWidth: .infinity, minHeight: 34)
        }
        .buttonStyle(.glass)
    }
}
