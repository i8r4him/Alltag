//
//  TranslateInput.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Both languages on one glass card: the text to translate on top, the swap
/// button on the line between them, and room below for the translation (or
/// whatever stands in for it).
struct TranslateInputCard<Lower: View>: View {
    @Binding var text: String
    let sourceLabel: LocalizedStringResource
    let prompt: LocalizedStringResource
    var isFocused: FocusState<Bool>.Binding
    let onSwap: () -> Void
    /// The field was cleared or pasted into.
    let onEdit: () -> Void
    @ViewBuilder let lower: Lower

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                TranslateLanguageChip(label: sourceLabel, isResult: false)
                TranslateField(text: $text, prompt: prompt, isFocused: isFocused, onEdit: onEdit)
            }
            Divider()
                .overlay { swapButton }
                .padding(.top, 22)
            lower.padding(.top, 22)
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    private var swapButton: some View {
        Button("Swap languages", systemImage: "arrow.up.arrow.down", action: onSwap)
            .labelStyle(.iconOnly)
            .font(.headline)
            .foregroundStyle(.accent)
            .frame(width: 44, height: 44)
            .glassEffect(.regular.interactive(), in: .circle)
            .buttonStyle(.plain)
    }
}

/// The name of a language on a capsule: filled with the theme colour for the translation's side.
struct TranslateLanguageChip: View {
    let label: LocalizedStringResource
    let isResult: Bool

    var body: some View {
        Text(label)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(isResult ? AnyShapeStyle(.onAccent) : AnyShapeStyle(.primary))
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(isResult ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.controlFill), in: .capsule)
    }
}

/// The text field: grows with the text, with a clear button beside it and
/// the system's Paste button while it is empty.
struct TranslateField: View {
    @Binding var text: String
    let prompt: LocalizedStringResource
    var isFocused: FocusState<Bool>.Binding
    let onEdit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 8) {
                TextField(text: $text, axis: .vertical) { Text(prompt) }
                    .font(.title3)
                    .lineLimit(2...6)
                    .focused(isFocused)
                if !text.isEmpty {
                    Button("Clear", systemImage: "xmark.circle.fill") {
                        text = ""
                        isFocused.wrappedValue = true
                        onEdit()
                    }
                    .labelStyle(.iconOnly)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .frame(width: 32, height: 32)
                    .contentShape(.rect)
                    .buttonStyle(.plain)
                    .transition(.opacity)
                }
            }
            if text.isEmpty {
                PasteButton(payloadType: String.self) { strings in
                    guard let pasted = strings.first else { return }
                    text = pasted.trimmingCharacters(in: .whitespacesAndNewlines)
                    onEdit()
                }
                .buttonBorderShape(.capsule)
                .tint(.accentFill)
            }
        }
        .animation(.easeOut(duration: 0.2), value: text.isEmpty)
    }
}
