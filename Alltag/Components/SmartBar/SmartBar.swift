//
//  SmartBar.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The floating glass input bar on Home, Memory, Learn, Progress and Grammar.
///
/// `+` reveals the action chips; the right button is a mic when the field is
/// empty and an accent send button once there is text. Add it to a screen
/// with `.smartBar(_:)`.
struct SmartBar: View {
    let context: SmartBarContext
    @Binding var isOpen: Bool
    let onAction: (SmartBarAction) -> Void

    @State private var text = ""
    @FocusState private var isFocused: Bool
    @Environment(\.reducesMotion) private var reduceMotion

    private var hasText: Bool { !text.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if isOpen {
                SmartBarChips(onAction: { send($0) }, text: text)
                    .padding(.horizontal, 14)
                    .padding(.top, 10)
                    .transition(.opacity)
            }
            inputRow
        }
        .glassEffect(.regular, in: .rect(cornerRadius: 28, style: .continuous))
        .padding(.horizontal, 12)
        .padding(.bottom, 4)
        .animation(Motion.easeOut(duration: reduceMotion ? 0.15 : 0.3), value: isOpen)
        .animation(.easeOut(duration: 0.15), value: hasText)
        .onChange(of: isFocused) { _, focused in
            if focused { isOpen = true }
        }
        .onChange(of: isOpen) { _, open in
            if !open { isFocused = false }
        }
    }

    private var inputRow: some View {
        HStack(spacing: 6) {
            Button {
                isOpen.toggle()
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .medium))
                    .rotationEffect(.degrees(isOpen ? 45 : 0))
                    .frame(width: 40, height: 40)
                    .background(.controlFill, in: .circle)
                    .frame(width: Spacing.minTouchTarget, height: Spacing.minTouchTarget)
                    .contentShape(.circle)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(isOpen ? "Hide actions" : "Show actions")
            .sensoryFeedback(.selection, trigger: isOpen)

            TextField(context.placeholder, text: $text)
                .textRole(.body)
                .focused($isFocused)
                .submitLabel(.send)
                .onSubmit { if hasText { send(.submit(text)) } }
                .accessibilityLabel("Ask, translate or practise")

            trailingButton
        }
        .padding(.horizontal, 6)
        .frame(height: 56)
    }

    @ViewBuilder
    private var trailingButton: some View {
        if hasText {
            Button { send(.submit(text)) } label: {
                Image(systemName: "arrow.up")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.onAccent)
                    .frame(width: 40, height: 40)
                    .background(.accentFill, in: .circle)
                    .frame(width: Spacing.minTouchTarget, height: Spacing.minTouchTarget)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Send")
            .transition(.scale.combined(with: .opacity))
        } else {
            Button { send(.speak) } label: {
                Image(systemName: "mic.fill")
                    .font(.system(size: 18, weight: .semibold))
                    // Solid colours: hierarchical styles turn translucent inside glass.
                    .foregroundStyle(Color(uiColor: .systemBackground))
                    .frame(width: 40, height: 40)
                    .background(Color(uiColor: .label), in: .circle)
                    .frame(width: Spacing.minTouchTarget, height: Spacing.minTouchTarget)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Speak")
            .transition(.scale.combined(with: .opacity))
        }
    }

    private func send(_ action: SmartBarAction) {
        onAction(action)
        text = ""
        isOpen = false
    }
}

/// The action chips shown when the Smart Bar is open.
struct SmartBarChips: View {
    let onAction: (SmartBarAction) -> Void
    var text = ""

    var body: some View {
        // Chips already pad themselves to a 44pt tap target, so rows need no extra gap.
        FlowLayout(spacing: 8, lineSpacing: 0) {
            chip("Translate", systemImage: "translate", action: .translateChip(text))
            chip("Practise speaking", systemImage: "waveform", action: .practiseSpeakingChip)
            chip("Fix a mistake", systemImage: "textformat.abc.dottedunderline", action: .fixMistakeChip)
            chip("Review words", systemImage: "brain", action: .reviewWordsChip)
        }
    }

    private func chip(_ title: LocalizedStringKey, systemImage: String, action: SmartBarAction) -> some View {
        Button { onAction(action) } label: {
            Label(title, systemImage: systemImage)
        }
        .buttonStyle(.chip(isSelected: false))
    }
}
