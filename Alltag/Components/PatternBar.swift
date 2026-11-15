//
//  PatternBar.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The shape of a rule as slots: e.g. "weil / wenn · Subject · … · Verb",
/// with the slots that matter in amber.
struct PatternBar: View {
    let slots: [GrammarRule.PatternSlot]

    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            ForEach(Array(slots.enumerated()), id: \.offset) { _, slot in
                VStack(spacing: 6) {
                    Capsule()
                        .fill(slot.emphasis == .none ? AnyShapeStyle(.fill.secondary) : AnyShapeStyle(.accentFill))
                        .frame(height: 6)
                    Text(verbatim: slot.label)
                        .textRole(.caption)
                        .foregroundStyle(slot.emphasis == .none ? AnyShapeStyle(.tertiary) : AnyShapeStyle(.accent))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Pattern")
        .accessibilityValue(Text(verbatim: slots.map(\.label).joined(separator: ", ")))
    }
}

#Preview {
    PatternBar(slots: MockRules.weil.pattern)
        .padding()
        .background(.surface)
}
