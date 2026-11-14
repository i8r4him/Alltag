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

/// The tools at the top of Learn: the "How do I say …?" field, which answers
/// in place, with Translate and Articles below it.
struct ToolsSection: View {
    let onOpen: (LearnTool) -> Void

    @State private var taps = 0

    var body: some View {
        VStack(spacing: Spacing.grid) {
            AskInPlace()
            GlassEffectContainer(spacing: 8) {
                HStack(spacing: 8) {
                    ForEach([LearnTool.translate, .articles]) { tool in
                        Button {
                            taps += 1
                            onOpen(tool)
                        } label: {
                            Label { Text(tool.title) } icon: { Image(systemName: tool.systemImage) }
                                .font(.subheadline.weight(.semibold))
                                .frame(maxWidth: .infinity, minHeight: 30)
                        }
                        .buttonStyle(.glass)
                    }
                }
            }
        }
        .fontDesign(.rounded)
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
    }
}
