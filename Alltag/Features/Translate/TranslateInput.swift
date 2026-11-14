//
//  TranslateInput.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Both languages on one card: the text to translate on top, the swap button
/// on the line between them, and the translation with Listen, Slowly and the
/// bookmark below.
struct TranslatePairCard: View {
    @Binding var text: String
    let sourceLabel: LocalizedStringResource
    let resultLabel: LocalizedStringResource
    let prompt: LocalizedStringResource
    var isFocused: FocusState<Bool>.Binding
    let result: String?
    let isTranslating: Bool
    let actions: TranslateResultActions
    let onSwap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                chip(sourceLabel, isResult: false)
                TranslateTextField(text: $text, prompt: prompt, isFocused: isFocused)
            }
            .padding(.bottom, 22)
            Divider()
                .overlay {
                    Button("Swap languages", systemImage: "arrow.up.arrow.down", action: onSwap)
                        .labelStyle(.iconOnly)
                        .font(.headline)
                        .foregroundStyle(.accent)
                        .frame(width: 44, height: 44)
                        .glassEffect(.regular.interactive(), in: .circle)
                        .buttonStyle(.plain)
                }
            VStack(alignment: .leading, spacing: 10) {
                chip(resultLabel, isResult: true)
                if let result {
                    Text(verbatim: result)
                        .font(.title2.weight(.semibold))
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    actions
                } else if isTranslating {
                    ProgressView().frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("The translation appears here.")
                        .font(.title3)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(.top, 22)
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    private func chip(_ label: LocalizedStringResource, isResult: Bool) -> some View {
        Text(label)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(isResult ? AnyShapeStyle(.onAccent) : AnyShapeStyle(.primary))
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(isResult ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.controlFill), in: .capsule)
    }
}

/// The text field the cards use: grows with the text.
struct TranslateTextField: View {
    @Binding var text: String
    let prompt: LocalizedStringResource
    var isFocused: FocusState<Bool>.Binding

    var body: some View {
        TextField(text: $text, axis: .vertical) { Text(prompt) }
            .font(.title3)
            .lineLimit(2...6)
            .focused(isFocused)
    }
}

/// Listen, slowly, and the bookmark that saves to Memory and takes it out again.
struct TranslateResultActions: View {
    let isSaved: Bool
    let onListen: (_ slowly: Bool) -> Void
    let onToggleSave: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            circle("Listen", systemImage: "speaker.wave.2.fill") { onListen(false) }
            circle("Slowly", systemImage: "tortoise.fill") { onListen(true) }
            Spacer()
            Button(action: onToggleSave) {
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.accent)
                    .contentTransition(.symbolEffect(.replace))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .glassEffect(.regular.interactive(), in: .circle)
            .accessibilityLabel(isSaved ? Text("Remove from Memory") : Text("Save to Memory"))
        }
    }

    private func circle(_ title: LocalizedStringResource, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.headline)
                .foregroundStyle(.primary)
                .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .circle)
        .accessibilityLabel(Text(title))
    }
}

/// Where to start: the Focus card's layout, with two prompts to try.
struct TranslateWelcome: View {
    let onChoose: (String) -> Void

    @ScaledMetric(relativeTo: .title3) private var artworkSize: CGFloat = 88

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Find the words")
                        .font(.title3.weight(.semibold))
                    Text("Say it naturally in German, or understand something you’ve read, with the words, tone and examples.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                ScenarioArtwork(systemImage: "translate")
                    .frame(width: artworkSize, height: artworkSize)
            }
            GlassEffectContainer(spacing: 8) {
                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 8) { prompts }
                    VStack(alignment: .leading, spacing: 8) { prompts }
                }
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    @ViewBuilder
    private var prompts: some View {
        Button("Ask to meet later", systemImage: "calendar") {
            onChoose("Could we meet half an hour later?")
        }
        .buttonStyle(.glass)
        Button("Understand a word", systemImage: "text.magnifyingglass") {
            onChoose("Kündigungsfrist")
        }
        .buttonStyle(.glass)
    }
}
