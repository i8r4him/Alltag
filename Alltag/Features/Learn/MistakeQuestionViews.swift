//
//  MistakeQuestionViews.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftUI

/// A mistake as a flashcard: what was said, with the wrong words underlined
/// in coral. Think of the fix, turn the card over, and say honestly whether
/// you knew it.
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
