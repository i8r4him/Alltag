//
//  StepHeader.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Title and optional subtitle at the top of an onboarding step.
struct StepHeader: View {
    let title: LocalizedStringKey
    var subtitle: LocalizedStringKey?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .textRole(.title2)
                .accessibilityAddTraits(.isHeader)
            if let subtitle {
                Text(subtitle)
                    .textRole(.body)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
    }
}
