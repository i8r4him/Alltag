//
//  WelcomeStep.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Step 0: what Alltag is, anchored to the bottom with a soft amber glow.
struct WelcomeStep: View {
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Eyebrow(title: "Alltag")
                    Text("Learn German through the life you already live.")
                        .textRole(.hero)
                        .accessibilityAddTraits(.isHeader)
                    // One localized key, so it can't be split across lines.
                    // swiftlint:disable:next line_length
                    Text("No courses, no streaks. Alltag learns from your day — what you read, write, plan and say — and turns it into a few minutes of practice.")
                        .textRole(.body)
                        .foregroundStyle(.secondary)
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 8)
                .frame(maxWidth: .infinity, minHeight: proxy.size.height, alignment: .bottomLeading)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .background(alignment: .topTrailing) {
            Circle()
                .fill(RadialGradient(colors: [.accentFill.opacity(AccentTint.glow), .clear],
                                     center: .center, startRadius: 0, endRadius: 160))
                .frame(width: 320, height: 320)
                .offset(x: 60, y: 40)
                .accessibilityHidden(true)
        }
    }
}

#Preview {
    WelcomeStep()
        .padding(.horizontal, Spacing.onboarding)
        .background(.screenBackground)
}
