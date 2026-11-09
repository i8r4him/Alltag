//
//  MistakesCardDesigns.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import SwiftUI

/// Temporary: designs for "Fix your mistakes", to compare on device.
enum MistakesDesign: Int, CaseIterable {
    case current, beforeAfter, bigNumber, focus, list, deck

    var name: String {
        switch self {
        case .current: "Current"
        case .beforeAfter: "Before → after"
        case .bigNumber: "Big number"
        case .focus: "Focus"
        case .list: "List"
        case .deck: "Deck"
        }
    }
}

/// Temporary: steps through the mistakes designs.
struct MistakesDesignSwitcher: View {
    @Binding var design: MistakesDesign

    var body: some View {
        let all = MistakesDesign.allCases
        HStack(spacing: 14) {
            Button { step(-1) } label: { Image(systemName: "chevron.left") }
            Text(verbatim: "\(design.rawValue + 1) / \(all.count) · \(design.name)")
                .foregroundStyle(.secondary)
                .frame(minWidth: 150)
            Button { step(1) } label: { Image(systemName: "chevron.right") }
        }
        .font(.footnote.weight(.semibold))
        .buttonStyle(.glass)
        .frame(maxWidth: .infinity)
        .sensoryFeedback(.selection, trigger: design)
    }

    private func step(_ offset: Int) {
        let all = MistakesDesign.allCases
        withAnimation(.snappy) { design = all[(design.rawValue + offset + all.count) % all.count] }
    }
}

/// One of the learner's mistakes (mock content until the logic is built).
private struct SampleMistake: Identifiable {
    let id = UUID()
    let before: String
    let wrong: String
    let after: String
    let fixed: String
    let source: LocalizedStringResource
    let systemImage: String

    static let all = [
        SampleMistake(before: "Ich wohne hier ", wrong: "für drei Jahren", after: ".",
                      fixed: "seit drei Jahren", source: "Messages · yesterday", systemImage: "message.fill"),
        SampleMistake(before: "… wenn ", wrong: "das passt mir", after: ".",
                      fixed: "mir das passt", source: "Conversation · dentist", systemImage: "waveform")
    ]

    /// The sentence with the mistake underlined in coral.
    var quote: Text {
        var opening = AttributedString("„" + before)
        opening.foregroundColor = .secondary
        var mistake = AttributedString(wrong)
        mistake.foregroundColor = .primary
        mistake.underlineStyle = Text.LineStyle(pattern: .solid, color: .mistake)
        var closing = AttributedString(after + "“")
        closing.foregroundColor = .secondary
        return Text(opening + mistake + closing)
    }

    /// The same sentence corrected, the fix in the theme colour.
    var correction: Text {
        var opening = AttributedString("„" + before)
        opening.foregroundColor = .secondary
        var fix = AttributedString(fixed)
        fix.foregroundColor = .accent
        var closing = AttributedString(after + "“")
        closing.foregroundColor = .secondary
        return Text(opening + fix + closing)
    }
}

/// "Fix your mistakes" in one of the designs.
struct MistakesCard: View {
    let design: MistakesDesign
    let action: () -> Void

    @State private var taps = 0

    private var mistakes: [SampleMistake] { SampleMistake.all }
    private var first: SampleMistake { SampleMistake.all[0] }

    var body: some View {
        Group {
            switch design {
            case .current: current
            case .beforeAfter: beforeAfter
            case .bigNumber: bigNumber
            case .focus: focus
            case .list: list
            case .deck: deck
            }
        }
        .fontDesign(.rounded)
        .sensoryFeedback(.impact(weight: .light), trigger: taps)
    }

    private func tapped() {
        taps += 1
        action()
    }

    // MARK: Pieces

    private var practiseButton: some View {
        Button(action: tapped) {
            Label("Practise · 1 min", systemImage: "arrow.trianglehead.counterclockwise")
                .font(.headline)
                .frame(maxWidth: .infinity, minHeight: 34)
        }
        .buttonStyle(.glassProminent)
        .tint(Color.accentFill)
    }

    private var playCircle: some View {
        Button(action: tapped) {
            Image(systemName: "play.fill")
                .font(.title3)
                .frame(width: 34, height: 34)
        }
        .buttonStyle(.glassProminent)
        .buttonBorderShape(.circle)
        .tint(Color.accentFill)
        .accessibilityLabel("Practise your mistakes")
    }

    // MARK: Designs

    private var current: some View {
        Button(action: tapped) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("Fix your mistakes")
                        .font(.title3.weight(.semibold))
                    Spacer()
                    Label("1 min", systemImage: "clock")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.accent)
                }
                first.quote
                    .font(.title2.weight(.semibold))
                Text("You wrote this in Messages yesterday · plus one from a conversation")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.leading)
            .padding(Spacing.cardLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .learnSurface()
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }

    /// What you wrote, crossed out in coral, and the fix underneath.
    private var beforeAfter: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Fix your mistakes")
                .font(.title3.weight(.semibold))
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.mistake)
                    first.quote
                }
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.accent)
                    first.correction
                }
            }
            .font(.headline)
            .accessibilityElement(children: .combine)
            Label { Text(first.source) } icon: { Image(systemName: first.systemImage) }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            practiseButton
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .learnSurface()
    }

    /// Like the briefing: a big count, the text and a play button.
    private var bigNumber: some View {
        HStack(alignment: .center, spacing: 18) {
            VStack(spacing: 0) {
                Text(mistakes.count, format: .number)
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundStyle(LinearGradient(colors: [.accentFill, AppTheme.shared.palette.deep],
                                                    startPoint: .top, endPoint: .bottom))
                Text("TO FIX")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.accent)
            }
            .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 4) {
                Text("Fix your mistakes")
                    .font(.title3.weight(.semibold))
                Text("From Messages and a conversation · 1 min")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
            playCircle
        }
        .padding(Spacing.cardLarge)
        .learnSurface()
    }

    /// The Focus card's layout: text left, artwork right, a button below.
    private var focus: some View {
        VStack(spacing: 18) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Fix your mistakes")
                        .font(.title3.weight(.semibold))
                    Text("^[\(mistakes.count) mistake](inflect: true) from this week, fixed in a minute.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                ScenarioArtwork(systemImage: "pencil.and.scribble")
                    .frame(width: 96, height: 96)
            }
            practiseButton
        }
        .padding(Spacing.cardLarge)
        .learnSurface()
    }

    /// Each mistake on its own row with where it came from.
    private var list: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Fix your mistakes")
                    .font(.title3.weight(.semibold))
                Spacer()
                playCircle
            }
            .padding(.bottom, 8)
            ForEach(Array(mistakes.enumerated()), id: \.element.id) { index, mistake in
                if index > 0 { Divider() }
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: mistake.systemImage)
                        .font(.subheadline)
                        .foregroundStyle(.accent)
                        .frame(width: 34, height: 34)
                        .background(.accent.opacity(0.14), in: .circle)
                    VStack(alignment: .leading, spacing: 3) {
                        mistake.quote
                            .font(.headline)
                        Text(mistake.source)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 12)
                .accessibilityElement(children: .combine)
            }
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .learnSurface()
    }

    /// A stack of cards, one per mistake, the first on top.
    private var deck: some View {
        Button(action: tapped) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Label { Text(first.source) } icon: { Image(systemName: first.systemImage) }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.accent)
                    Spacer()
                    Text("1 of ^[\(mistakes.count) mistake](inflect: true)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                first.quote
                    .font(.title2.weight(.semibold))
                Text("Tap to fix it")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.leading)
            .padding(Spacing.cardLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .learnSurface()
            .background(alignment: .bottom) {
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: Radius.hero, style: .continuous)
                        .fill(.white.opacity(0.07))
                        .padding(.horizontal, 28)
                        .offset(y: 20)
                    RoundedRectangle(cornerRadius: Radius.hero, style: .continuous)
                        .fill(.white.opacity(0.12))
                        .padding(.horizontal, 14)
                        .offset(y: 10)
                }
            }
            .padding(.bottom, 20)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}
