//
//  SituationsView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 12.11.26.
//

import SwiftUI

/// Every situation to train, grouped by where in life it happens.
/// Tapping one starts its conversation with the live voice.
struct SituationsView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.section) {
                ForEach(Situation.Category.allCases) { category in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(category.title)
                            .textRole(.sectionHeader)
                            .padding(.horizontal, 4)
                            .accessibilityAddTraits(.isHeader)
                        let situations = SituationCatalogue.situations(in: category)
                        VStack(spacing: 0) {
                            ForEach(Array(situations.enumerated()), id: \.element.id) { index, situation in
                                if index > 0 { Divider().padding(.leading, 72) }
                                Button { appState.present(.situation(situation.id)) } label: {
                                    SituationRow(situation: situation)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
                    }
                }
            }
            .padding(Spacing.screen)
        }
        .fontDesign(.rounded)
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .readableContentMargins()
        .skyBackground()
        .navigationTitle("Situations")
        .toolbarTitleDisplayMode(.inlineLarge)
    }
}

#Preview {
    NavigationStack { SituationsView() }
        .environment(AppState())
}
