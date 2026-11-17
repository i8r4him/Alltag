//
//  GlassInputField.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The field at the top of a page ("How do I say …?" on Learn, "Look up a
/// word" in Articles): a glass capsule with a symbol, the field, and once
/// there is text, the X and a round button in the theme colour that sends.
/// Pair it with `.fieldFocusEffect(isActive:)`.
struct GlassInputField: View {
    let systemImage: String
    let prompt: LocalizedStringKey
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    var submitLabel: SubmitLabel = .send
    /// What the round button says to VoiceOver.
    let sendLabel: LocalizedStringKey
    let canSend: Bool
    let onSend: () -> Void
    let onClear: () -> Void

    @Environment(\.reducesMotion) private var reduceMotion

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(.accent)
                .accessibilityHidden(true)
            TextField(prompt, text: $text)
                .font(.title3)
                .focused(isFocused)
                .submitLabel(submitLabel)
                .onSubmit(onSend)
            if !text.isEmpty {
                Group {
                    Button("Clear", systemImage: "xmark.circle.fill", action: onClear)
                        .labelStyle(.iconOnly)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .frame(width: 32, height: 44)
                        .contentShape(.rect)
                    Button(sendLabel, systemImage: "arrow.up", action: onSend)
                        .labelStyle(.iconOnly)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(canSend ? AnyShapeStyle(.onAccent) : AnyShapeStyle(.tertiary))
                        .frame(width: 40, height: 40)
                        .background(canSend ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.controlFill), in: .circle)
                        .disabled(!canSend)
                }
                .buttonStyle(.plain)
                .transition(reduceMotion ? .opacity : .scale(scale: 0.6).combined(with: .opacity))
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, text.isEmpty ? 20 : 10)
        .frame(height: 60)
        .glassEffect(.regular.interactive(), in: .capsule)
        .animation(.smooth(duration: 0.25), value: text.isEmpty)
    }
}
