//
//  AskRegisterChoice.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// How the answer to "How do I say …?" sounds: Everyday (the default, the way
/// people really talk) or Formal (Sie, for an email or an office), as two glass
/// chips under the field. The chosen one is outlined in the theme colour.
struct AskRegisterChoice: View {
    let selection: GermanRegister
    let onChoose: (GermanRegister) -> Void

    var body: some View {
        GlassEffectContainer(spacing: 8) {
            HStack(spacing: 8) {
                ForEach(GermanRegister.allCases) { register in
                    let isSelected = register == selection
                    Button {
                        onChoose(register)
                    } label: {
                        Label { Text(register.title) } icon: { Image(systemName: register.systemImage) }
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(isSelected ? Color.accent : Color.primary)
                            .padding(.horizontal, 14)
                            .frame(minHeight: 36)
                            .overlay {
                                Capsule().strokeBorder(Color.accentFill, lineWidth: isSelected ? 2 : 0)
                            }
                            .contentShape(.capsule)
                    }
                    .buttonStyle(.plain)
                    .glassEffect(.regular.interactive(), in: .capsule)
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                    .accessibilityHint(Text(register.hint))
                }
            }
        }
        .padding(.vertical, 4) // a 44pt tap target
        .sensoryFeedback(.selection, trigger: selection)
    }
}

extension GermanRegister {
    var title: LocalizedStringResource {
        switch self {
        case .everyday: "Everyday"
        case .formal: "Formal"
        }
    }

    var systemImage: String {
        switch self {
        case .everyday: "bubble.left.and.bubble.right"
        case .formal: "envelope"
        }
    }

    var hint: LocalizedStringResource {
        switch self {
        case .everyday: "German the way people really talk, to friends, colleagues and in shops."
        case .formal: "Polite German with Sie, for an email, a letter or an office."
        }
    }
}

#Preview {
    @Previewable @State var register = GermanRegister.everyday
    AskRegisterChoice(selection: register) { register = $0 }
        .padding()
}
