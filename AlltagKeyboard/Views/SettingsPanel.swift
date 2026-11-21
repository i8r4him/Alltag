//
//  SettingsPanel.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 21.11.26.
//

import SwiftUI

/// The keyboard's own settings, in place of the keys: a tap on the orb opens them.
struct SettingsPanel: View {
    let model: KeyboardModel
    @State private var hasForgotten = false
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                KeyboardOrb()
                    .frame(width: 22, height: 22)
                    .accessibilityHidden(true)
                Text("Alltag keyboard")
                    .font(.system(size: 16, weight: .semibold))
                Spacer(minLength: 0)
                Button {
                    model.closeSettings()
                } label: {
                    Text("Done")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.onAccent)
                        .padding(.horizontal, 14)
                        .frame(height: 30)
                        .background(Color.accentFill, in: .capsule)
                        .contentShape(.capsule)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.top, 6)
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(KeyboardSettings.Option.allCases) { option in
                        if option != KeyboardSettings.Option.allCases.first {
                            Divider()
                                .padding(.leading, 14)
                        }
                        Toggle(isOn: Binding(get: { model.settings[option] }, set: { model.set(option, to: $0) })) {
                            Self.title(of: option)
                                .font(.system(size: 16))
                        }
                        .tint(Color.accentFill)
                        .padding(.horizontal, 14)
                        .frame(height: 44)
                    }
                }
                .background(KeyCap.fill(isDark: colorScheme == .dark), in: .rect(cornerRadius: 12, style: .continuous))
                .padding(.horizontal, 6)
                Button {
                    model.forgetLearntWords()
                    hasForgotten = true
                } label: {
                    (hasForgotten ? Text("Learnt words forgotten") : Text("Forget learnt words"))
                        .font(.system(size: 16))
                        .foregroundStyle(hasForgotten ? Color.secondary : Color.accent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 14)
                        .frame(height: 44)
                        .background(KeyCap.fill(isDark: colorScheme == .dark), in: .rect(cornerRadius: 12, style: .continuous))
                        .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .disabled(hasForgotten)
                .padding(.horizontal, 6)
                .padding(.top, 4)
                Text("The keyboard learns which words you write one after another. They stay on this iPhone.")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 2)
                if !model.tools.hasFullAccess {
                    Text("The haptic and Alltag’s tools need Full Access: Settings › General › Keyboard › Keyboards › Alltag.")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 4)
                }
            }
            .scrollEdgeEffectStyle(.soft, for: .all)
            .scrollIndicators(.hidden)
        }
    }

    static func title(of option: KeyboardSettings.Option) -> Text {
        switch option {
        case .sound: Text("Key clicks")
        case .haptics: Text("Haptic feedback")
        case .suggestions: Text("Word suggestions")
        case .autoCorrection: Text("Auto-correction")
        case .autoCapitals: Text("Auto-capitalisation")
        case .fullStopShortcut: Text("Full stop with a double space")
        }
    }
}
