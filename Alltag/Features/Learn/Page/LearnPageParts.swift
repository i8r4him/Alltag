//
//  LearnPageParts.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The lesson card's designs to pick from, behind the temporary switcher.
enum LessonDesign: Int, CaseIterable {
    case ring, nextUp, strip, path, cards

    /// The design's working name, only for talking about it while one is picked.
    var name: String {
        switch self {
        case .ring: "Big ring"
        case .nextUp: "Next up"
        case .strip: "Strip"
        case .path: "Path"
        case .cards: "Cards"
        }
    }
}

/// "Today's lesson" and its card, in the design picked with the temporary
/// "‹ n / 5 ›" switcher next to the title.
struct LessonHero: View {
    let content: LearnPageContent

    @AppStorage("dailyLesson.cardDesign") private var design = 0

    var body: some View {
        if !content.steps.isEmpty {
            let onOpen: (LessonStep) -> Void = { content.open($0.target) }
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Today’s lesson")
                        .textRole(.sectionHeader)
                    Spacer()
                    LessonDesignSwitcher(design: $design)
                }
                .padding(.horizontal, 4)
                switch LessonDesign(rawValue: design) ?? .ring {
                case .ring:
                    LessonRingDesign(level: content.level, steps: content.steps, zoom: content.zoom, onOpen: onOpen)
                case .nextUp:
                    LessonNextUpDesign(steps: content.steps, zoom: content.zoom, onOpen: onOpen)
                case .strip:
                    LessonStripDesign(steps: content.steps, zoom: content.zoom, onOpen: onOpen)
                case .path:
                    LessonPathDesign(steps: content.steps, zoom: content.zoom, onOpen: onOpen)
                case .cards:
                    LessonDeckDesign(steps: content.steps, zoom: content.zoom, onOpen: onOpen)
                }
            }
        }
    }
}

/// The temporary "Big ring · 1 / 5" switcher between the lesson card's
/// designs; it goes once the maintainer has picked one.
private struct LessonDesignSwitcher: View {
    @Binding var design: Int

    private var count: Int { LessonDesign.allCases.count }
    private var current: LessonDesign { LessonDesign(rawValue: design) ?? .ring }

    var body: some View {
        HStack(spacing: 0) {
            Button { step(by: -1) } label: {
                Image(systemName: "chevron.left")
                    .frame(width: 36, height: 36)
                    .contentShape(.rect)
            }
            .accessibilityLabel(Text("Previous design"))
            Text(verbatim: "\(current.name) · \(current.rawValue + 1) / \(count)")
                .monospacedDigit()
            Button { step(by: 1) } label: {
                Image(systemName: "chevron.right")
                    .frame(width: 36, height: 36)
                    .contentShape(.rect)
            }
            .accessibilityLabel(Text("Next design"))
        }
        .buttonStyle(.plain)
        .font(.subheadline.weight(.semibold))
        .padding(.horizontal, 4)
        .glassEffect(.regular.interactive(), in: .capsule)
        .sensoryFeedback(.selection, trigger: design)
    }

    private func step(by offset: Int) {
        withAnimation(.smooth) {
            design = (current.rawValue + offset + count) % count
        }
    }
}

/// A part's real progress in a few words: "8 of 20 solved", "3 of 24 read",
/// "2 texts written", "1 of 6 saved", or "Coming soon".
struct PartProgressText: View {
    let part: LearnOverview.Part

    var body: some View {
        switch part.kind {
        case .grammar:
            Text("\(part.done) of \(part.total) solved")
        case .read:
            Text("\(part.done) of \(part.total) read")
        case .words:
            Text("\(part.done) of \(part.total) saved")
        case .write:
            if part.done > 0 {
                Text("^[\(part.done) text](inflect: true) written")
            } else {
                Text("Nothing written yet")
            }
        case .listen:
            Text("Coming soon")
        }
    }
}

/// A part's progress as a small ring with the percentage inside, like Learn's level ring.
struct PartRing: View {
    let fraction: Double
    var size: CGFloat = 40

    var body: some View {
        ZStack {
            LevelRing(fraction: fraction, lineWidth: size / 9)
            Text(verbatim: "\(Int((fraction * 100).rounded()))")
                .font(.system(size: size * 0.3, weight: .bold, design: .rounded))
                .monospacedDigit()
                .minimumScaleFactor(0.7)
                .padding(.horizontal, size * 0.16)
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}
