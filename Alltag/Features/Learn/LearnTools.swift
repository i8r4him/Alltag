//
//  LearnTools.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import SwiftUI

/// Tools on Learn: things you reach for in the moment, not practice.
enum LearnTool: CaseIterable, Identifiable {
    case translate, howToSay, articles

    var id: Self { self }

    var title: LocalizedStringResource {
        switch self {
        case .translate: "Translate"
        case .howToSay: "How to say it"
        case .articles: "Articles"
        }
    }

    var systemImage: String {
        switch self {
        case .translate: "translate"
        case .howToSay: "quote.bubble.fill"
        case .articles: "tag.fill"
        }
    }
}

/// The tools at the top of Learn: a big "How do I say …?" field, with
/// Translate and Articles below it.
struct ToolsSection: View {
    let onOpen: (LearnTool) -> Void

    @State private var taps = 0

    var body: some View {
        askField
            .fontDesign(.rounded)
            .sensoryFeedback(.impact(weight: .light), trigger: taps)
    }

    private func open(_ tool: LearnTool) {
        taps += 1
        onOpen(tool)
    }

    /// A big "How do I say…" field, with Translate and Articles beside it below.
    private var askField: some View {
        VStack(spacing: Spacing.grid) {
            Button { open(.howToSay) } label: {
                HStack(spacing: 12) {
                    Image(systemName: LearnTool.howToSay.systemImage)
                        .font(.title3)
                        .foregroundStyle(.accent)
                    Text("How do I say …?")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Image(systemName: "mic.fill")
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 20)
                .frame(height: 60)
                .glassEffect(.regular.interactive(), in: .capsule)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(Text(LearnTool.howToSay.title))

            GlassEffectContainer(spacing: 8) {
                HStack(spacing: 8) {
                    ForEach([LearnTool.translate, .articles]) { tool in
                        Button { open(tool) } label: {
                            Label { Text(tool.title) } icon: { Image(systemName: tool.systemImage) }
                                .font(.subheadline.weight(.semibold))
                                .frame(maxWidth: .infinity, minHeight: 30)
                        }
                        .buttonStyle(.glass)
                    }
                }
            }
        }
    }
}
