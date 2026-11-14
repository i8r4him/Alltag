//
//  TranslateInput.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The Translate button when it sits inside the input card.
struct TranslateInlineButton {
    enum Shape { case none, capsule, arrow }

    var shape: Shape = .none
    let title: LocalizedStringResource
    let systemImage: String
    let isEnabled: Bool
    let action: () -> Void
}

/// The languages, the field and the swap, with room below for the
/// translation (or whatever stands in for it).
///
/// TEMPORARY (#296): three designs to choose from.
/// 1 one card for both languages, the swap on the line between them;
/// 2 a language bar on top, the field and the translation on a card each;
/// 3 a compact field with the languages as one line above the text.
struct TranslateInputCard<Lower: View>: View {
    let design: Int
    @Binding var text: String
    let sourceLabel: LocalizedStringResource
    let resultLabel: LocalizedStringResource
    let prompt: LocalizedStringResource
    var isFocused: FocusState<Bool>.Binding
    let button: TranslateInlineButton
    let onSwap: () -> Void
    /// The field was cleared or pasted into.
    let onEdit: () -> Void
    let showsLower: Bool
    @ViewBuilder let lower: Lower

    var body: some View {
        switch design {
        case 2: languageBar
        case 3: compact
        default: pair
        }
    }

    private var field: TranslateField {
        TranslateField(text: $text, prompt: prompt, isFocused: isFocused, button: button, onEdit: onEdit)
    }

    // MARK: 1 · Pair card

    private var pair: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    TranslateLanguageChip(label: sourceLabel, isResult: false)
                    Spacer()
                    // Without the lower half there is no line for the swap to sit on.
                    if !showsLower { swapButton }
                }
                field
            }
            if showsLower {
                Divider()
                    .overlay { swapButton }
                    .padding(.top, 22)
                lower.padding(.top, 22)
            }
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

    // MARK: 2 · Language bar

    private var languageBar: some View {
        VStack(alignment: .leading, spacing: Spacing.grid) {
            HStack(spacing: 0) {
                Text(sourceLabel).frame(maxWidth: .infinity)
                Button("Swap languages", systemImage: "arrow.left.arrow.right", action: onSwap)
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.onAccent)
                    .frame(width: 44, height: 36)
                    .background(.accentFill, in: .capsule)
                    .buttonStyle(.plain)
                Text(resultLabel).frame(maxWidth: .infinity)
            }
            .font(.headline)
            .padding(6)
            .glassEffect(.regular.interactive(), in: .capsule)
            field
                .padding(Spacing.cardLarge)
                .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
            lowerCard
        }
    }

    // MARK: 3 · Compact field

    private var compact: some View {
        VStack(alignment: .leading, spacing: Spacing.grid) {
            VStack(alignment: .leading, spacing: 10) {
                Button(action: onSwap) {
                    HStack(spacing: 6) {
                        Text(sourceLabel)
                        Image(systemName: "arrow.right").accessibilityHidden(true)
                        Text(resultLabel)
                        Image(systemName: "arrow.left.arrow.right.circle.fill")
                            .font(.body)
                            .accessibilityHidden(true)
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.accent)
                    .frame(minHeight: 32)
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityHint(Text("Swap languages"))
                field
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .glassEffect(.regular, in: .rect(cornerRadius: 28, style: .continuous))
            lowerCard
        }
    }

    @ViewBuilder
    private var lowerCard: some View {
        if showsLower {
            lower
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Spacing.cardLarge)
                .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        }
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

/// The text field: grows with the text, with a clear button beside it, the
/// system's Paste button while it is empty, and the Translate button when
/// that lives in the card.
struct TranslateField: View {
    @Binding var text: String
    let prompt: LocalizedStringResource
    var isFocused: FocusState<Bool>.Binding
    let button: TranslateInlineButton
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
            if text.isEmpty || button.shape != .none {
                HStack(spacing: 10) {
                    if text.isEmpty {
                        PasteButton(payloadType: String.self) { strings in
                            guard let pasted = strings.first else { return }
                            text = pasted.trimmingCharacters(in: .whitespacesAndNewlines)
                            onEdit()
                        }
                        .buttonBorderShape(.capsule)
                        .tint(.accentFill)
                    }
                    Spacer(minLength: 0)
                    inlineButton
                }
            }
        }
        .animation(.easeOut(duration: 0.2), value: text.isEmpty)
    }

    @ViewBuilder
    private var inlineButton: some View {
        switch button.shape {
        case .none:
            EmptyView()
        case .capsule:
            Button(action: button.action) {
                Label { Text(button.title) } icon: { Image(systemName: button.systemImage) }
            }
            .buttonStyle(.primaryCompact)
            .disabled(!button.isEnabled)
        case .arrow:
            Button(action: button.action) {
                Image(systemName: "arrow.up")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(button.isEnabled ? AnyShapeStyle(.onAccent) : AnyShapeStyle(.tertiary))
                    .frame(width: 44, height: 44)
                    .background(button.isEnabled ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.controlFill), in: .circle)
            }
            .buttonStyle(.plain)
            .disabled(!button.isEnabled)
            .accessibilityLabel(Text(button.title))
        }
    }
}
