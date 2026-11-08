//
//  ForYouCarousel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 08.11.26.
//

import SwiftUI

/// "For you": tall cards for real-life conversations, scrolled sideways.
struct ForYouCarousel: View {
    let scenarios: [Scenario]
    let onStart: (Scenario.ID) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("For you")
                .textRole(.sectionHeader)
            ScrollView(.horizontal) {
                LazyHStack(spacing: Spacing.grid) {
                    ForEach(Array(scenarios.enumerated()), id: \.element.id) { index, scenario in
                        ScenarioCard(scenario: scenario, palette: Self.palettes[index % Self.palettes.count]) {
                            onStart(scenario.id)
                        }
                        .containerRelativeFrame(.horizontal) { width, _ in min(width * 0.72, 300) }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
            .contentMargins(.horizontal, 0, for: .scrollContent)
        }
    }

    /// Warm, calm two-colour washes, one per card.
    private static let palettes: [[Color]] = [
        [Color(red: 0.56, green: 0.33, blue: 0.16), Color(red: 0.16, green: 0.10, blue: 0.07)],
        [Color(red: 0.20, green: 0.36, blue: 0.42), Color(red: 0.07, green: 0.11, blue: 0.14)],
        [Color(red: 0.30, green: 0.40, blue: 0.24), Color(red: 0.09, green: 0.12, blue: 0.08)]
    ]
}

private struct ScenarioCard: View {
    let scenario: Scenario
    let palette: [Color]
    let action: () -> Void

    @ScaledMetric(relativeTo: .title) private var height: CGFloat = 320

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottomLeading) {
                LinearGradient(colors: palette, startPoint: .topTrailing, endPoint: .bottomLeading)
                Image(systemName: scenario.systemImage)
                    .font(.system(size: 120, weight: .light))
                    .foregroundStyle(.white.opacity(0.16))
                    .rotationEffect(.degrees(-8))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(.top, 28)
                    .offset(x: 24)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 6) {
                    Text(verbatim: scenario.title)
                        .textRole(.sectionHeader)
                    Text(verbatim: scenario.meta)
                        .textRole(.meta)
                        .foregroundStyle(.white.opacity(0.75))
                    Label("Start", systemImage: "play.fill")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .glassEffect(.regular, in: .capsule)
                        .padding(.top, 10)
                }
                .foregroundStyle(.white)
                .padding(Spacing.cardLarge)
            }
            .frame(height: height)
            .clipShape(.rect(cornerRadius: Radius.hero, style: .continuous))
            .contentShape(.rect(cornerRadius: Radius.hero, style: .continuous))
        }
        .buttonStyle(.card)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Starts this conversation.")
    }
}

#Preview {
    ForYouCarousel(scenarios: MockScenarios.all) { _ in }
        .padding(Spacing.screen)
        .background(.screenBackground)
}
