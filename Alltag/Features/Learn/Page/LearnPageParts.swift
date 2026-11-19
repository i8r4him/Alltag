//
//  LearnPageParts.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// "Today's lesson" and its card, at the top of every page design.
struct LessonHero: View {
    let content: LearnPageContent

    var body: some View {
        if !content.steps.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Today’s lesson")
                    .textRole(.sectionHeader)
                    .padding(.horizontal, 4)
                LessonCardDesign(level: content.level, steps: content.steps, zoom: content.zoom) {
                    content.open($0.target)
                }
            }
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

/// A part's title as a section header that opens the part: "Grammar ›", with its progress on the right.
struct PartHeader: View {
    let part: LearnOverview.Part
    let onOpen: () -> Void

    var body: some View {
        Button(action: onOpen) {
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(part.kind.title)
                    .textRole(.sectionHeader)
                Image(systemName: "chevron.right")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.secondary)
                Spacer(minLength: 8)
                PartProgressText(part: part)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 4)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }
}
