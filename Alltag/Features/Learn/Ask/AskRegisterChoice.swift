//
//  AskRegisterChoice.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// How the answer to "How do I say …?" sounds, in the Tone card of its
/// details: Everyday (the default, the way people really talk) or Formal
/// (Sie, for an email or an office), with the answer's note above them.
/// Choosing the other one asks again; the chosen one has a tick, or turns
/// while its answer is on its way.
struct AskRegisterChoice: View {
    let selection: GermanRegister
    /// The answer's note on register or usage, if any.
    let note: String
    let isLoading: Bool
    let onChoose: (GermanRegister) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !note.isEmpty {
                Label {
                    Text(verbatim: note)
                } icon: {
                    Image(systemName: "info.circle.fill").foregroundStyle(.accent)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 12)
                Divider()
            }
            ForEach(Array(GermanRegister.allCases.enumerated()), id: \.element) { index, register in
                if index > 0 { Divider() }
                row(register)
            }
        }
        .sensoryFeedback(.selection, trigger: selection)
    }

    private func row(_ register: GermanRegister) -> some View {
        let isSelected = register == selection
        return Button { onChoose(register) } label: {
            HStack(spacing: 12) {
                Image(systemName: register.systemImage)
                    .font(.title3)
                    .foregroundStyle(.accent)
                    .frame(width: 28)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 2) {
                    Text(register.title)
                        .font(.headline)
                        .foregroundStyle(isSelected ? AnyShapeStyle(.accent) : AnyShapeStyle(.primary))
                    Text(register.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                if isSelected {
                    if isLoading {
                        ProgressView()
                    } else {
                        Image(systemName: "checkmark")
                            .font(.headline)
                            .foregroundStyle(.accent)
                            .accessibilityHidden(true)
                    }
                }
            }
            .padding(.vertical, 12)
            .frame(minHeight: 44)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

extension GermanRegister {
    var title: LocalizedStringResource {
        switch self {
        case .everyday: "Everyday"
        case .formal: "Formal"
        }
    }

    var subtitle: LocalizedStringResource {
        switch self {
        case .everyday: "How friends and colleagues say it"
        case .formal: "With Sie, for an email or an office"
        }
    }

    var systemImage: String {
        switch self {
        case .everyday: "bubble.left.and.bubble.right.fill"
        case .formal: "envelope.fill"
        }
    }
}

#Preview {
    @Previewable @State var register = GermanRegister.everyday
    AskRegisterChoice(selection: register, note: "Casual, for friends; use Formal in an email.", isLoading: false) {
        register = $0
    }
    .padding()
}
