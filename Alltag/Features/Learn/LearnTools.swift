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

    var detail: LocalizedStringResource {
        switch self {
        case .translate: "Any word or sentence"
        case .howToSay: "Natural German for a situation"
        case .articles: "2 saved from Safari"
        }
    }

    var systemImage: String {
        switch self {
        case .translate: "translate"
        case .howToSay: "quote.bubble.fill"
        case .articles: "newspaper.fill"
        }
    }
}

/// Temporary: layouts for the tools, to compare on device.
enum ToolsDesign: Int, CaseIterable {
    case tiles, card, askField, rows, toolbar

    var name: String {
        switch self {
        case .tiles: "Tiles"
        case .card: "One card"
        case .askField: "Ask field"
        case .rows: "Rows"
        case .toolbar: "Toolbar"
        }
    }
}

/// Temporary: steps through the tools layouts.
struct ToolsDesignSwitcher: View {
    @Binding var design: ToolsDesign

    var body: some View {
        let all = ToolsDesign.allCases
        HStack(spacing: 14) {
            Button { step(-1) } label: { Image(systemName: "chevron.left") }
            Text(verbatim: "\(design.rawValue + 1) / \(all.count) · \(design.name)")
                .foregroundStyle(.secondary)
                .frame(minWidth: 130)
            Button { step(1) } label: { Image(systemName: "chevron.right") }
        }
        .font(.footnote.weight(.semibold))
        .buttonStyle(.glass)
        .frame(maxWidth: .infinity)
        .sensoryFeedback(.selection, trigger: design)
    }

    private func step(_ offset: Int) {
        let all = ToolsDesign.allCases
        withAnimation(.snappy) { design = all[(design.rawValue + offset + all.count) % all.count] }
    }
}

/// Translate, How to say it and Articles in one of the layouts. The toolbar
/// layout draws nothing here; `LearnView` puts the tools in its toolbar.
struct ToolsSection: View {
    let design: ToolsDesign
    let onOpen: (LearnTool) -> Void

    @State private var taps = 0

    var body: some View {
        Group {
            switch design {
            case .tiles: tiles
            case .card: card
            case .askField: askField
            case .rows: rows
            case .toolbar: EmptyView()
            }
        }
        .fontDesign(.rounded)
        .sensoryFeedback(.impact(weight: .light), trigger: taps)
    }

    private func open(_ tool: LearnTool) {
        taps += 1
        onOpen(tool)
    }

    // MARK: Designs

    /// Three glass tiles in a row: the symbol in the theme colour, the name below.
    private var tiles: some View {
        GlassEffectContainer(spacing: 0) {
            HStack(spacing: Spacing.grid) {
                ForEach(LearnTool.allCases) { tool in
                    Button { open(tool) } label: {
                        VStack(alignment: .leading, spacing: 0) {
                            Image(systemName: tool.systemImage)
                                .font(.title2)
                                .foregroundStyle(.accent)
                            Spacer(minLength: 12)
                            Text(tool.title)
                                .font(.subheadline.weight(.semibold))
                                .lineLimit(2, reservesSpace: true)
                        }
                        .multilineTextAlignment(.leading)
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 112)
                        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 26, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .accessibilityElement(children: .combine)
                }
            }
        }
    }

    /// One card with three round buttons, like a control panel.
    private var card: some View {
        HStack(spacing: 0) {
            ForEach(LearnTool.allCases) { tool in
                Button { open(tool) } label: {
                    VStack(spacing: 8) {
                        Image(systemName: tool.systemImage)
                            .font(.title2)
                            .foregroundStyle(.accent)
                            .frame(width: 58, height: 58)
                            .background(Color.accent.opacity(0.14), in: .circle)
                        Text(tool.title)
                            .font(.subheadline.weight(.semibold))
                            .multilineTextAlignment(.center)
                            .lineLimit(2, reservesSpace: true)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, Spacing.cardLarge)
        .padding(.horizontal, 8)
        .learnSurface()
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

    /// The tools as rows with artwork, like Learn's other lists.
    private var rows: some View {
        LearnList {
            ForEach(LearnTool.allCases) { tool in
                LearnRow(systemImage: tool.systemImage, title: Text(tool.title),
                         detail: Text(tool.detail)) { open(tool) }
            }
        }
    }
}
