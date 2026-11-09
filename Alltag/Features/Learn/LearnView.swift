//
//  LearnView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Learn: everything apart from speaking (that's on Today). Your mistakes first,
/// then Read, Write, Listen and Grammar.
struct LearnView: View {
    @Environment(AppState.self) private var appState

    @State private var skillsDesign = SkillsDesign.grid

    /// Read and Write get their screens next; for now they open nothing.
    private func open(_ skill: LearnSkill) {
        switch skill {
        case .listen: appState.present(.activity(.listen))
        case .grammar: appState.open(.grammar)
        case .read, .write: break
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.section) {
                MistakesCard { appState.present(.activity(.mistakes)) }
                VStack(spacing: Spacing.grid) {
                    SkillsSection(design: skillsDesign, onOpen: open)
                    SkillsDesignSwitcher(design: $skillsDesign)
                }
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .readableContentMargins()
        .skyBackground()
        .navigationTitle("Learn")
        .toolbarTitleDisplayMode(.inlineLarge)
        .scrollEdgeEffectStyle(.soft, for: .all)
    }
}

/// "Fix your mistakes": the learner's own sentence with the mistake underlined.
private struct MistakesCard: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("Fix your mistakes")
                        .font(.title3.weight(.semibold))
                    Spacer()
                    Label("1 min", systemImage: "clock")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.accent)
                }
                quote
                    .font(.system(.title2, weight: .semibold))
                Text("You wrote this in Messages yesterday · plus one from a conversation")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.leading)
            .padding(Spacing.cardLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .learnSurface()
            .fontDesign(.rounded)
        }
        .buttonStyle(.card)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Starts a one-minute exercise on your mistakes.")
    }

    /// „Ich wohne hier **für drei Jahren**." — the mistake bright, underlined in coral.
    /// Built as an attributed string: it's German content, not catalog text.
    private var quote: Text {
        var opening = AttributedString("„Ich wohne hier ")
        opening.foregroundColor = .secondary
        var mistake = AttributedString("für drei Jahren")
        mistake.foregroundColor = .primary
        mistake.underlineStyle = Text.LineStyle(pattern: .solid, color: .mistake)
        var closing = AttributedString(".“")
        closing.foregroundColor = .secondary
        return Text(opening + mistake + closing)
    }
}

#Preview {
    NavigationStack { LearnView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
