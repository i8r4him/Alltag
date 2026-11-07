//
//  FeedbackCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Feedback under a learner line: green check (good), coral pencil (fix) or grey info (note).
struct FeedbackCard: View {
    let feedback: Feedback

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: symbol)
                .font(.system(size: 18))
                .foregroundStyle(tint)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(verbatim: feedback.title)
                    .fontWeight(.semibold)
                Text(verbatim: feedback.note)
                    .foregroundStyle(.secondary)
            }
            .textRole(.bodySmall)
            .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.surface, in: .rect(cornerRadius: Radius.tile, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("\(Text(kindLabel)): \(feedback.title). \(feedback.note)"))
    }

    private var symbol: String {
        switch feedback.kind {
        case .good: "checkmark.circle.fill"
        case .fix: "pencil.circle.fill"
        case .note: "info.circle.fill"
        }
    }

    private var tint: Color {
        switch feedback.kind {
        case .good: .success
        case .fix: .mistake
        case .note: .secondary
        }
    }

    private var kindLabel: LocalizedStringResource {
        switch feedback.kind {
        case .good: "Good"
        case .fix: "Fix"
        case .note: "Note"
        }
    }
}

#Preview {
    VStack(alignment: .trailing, spacing: 12) {
        ForEach(MockScenarios.dentist.script.compactMap(\.feedback), id: \.title) { FeedbackCard(feedback: $0) }
        FeedbackCard(feedback: Feedback(kind: .note, title: "Prototype", note: "Feedback on your own sentences arrives later."))
    }
    .padding()
    .background(.screenBackground)
}
