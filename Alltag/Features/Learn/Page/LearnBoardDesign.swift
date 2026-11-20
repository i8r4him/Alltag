//
//  LearnBoardDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Page design 9, "Pinnwand": today's lesson is sticky notes pinned to a cork
/// board, one per step, written by hand and crossed off once done; the next
/// one sits a little forward. The parts of Learn are instant photos taped up
/// below, each with its progress written under it.
struct LearnBoardDesign: View {
    let content: LearnPageContent

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            if !content.steps.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    LearnSectionTitle(title: Text(verbatim: "Heute"),
                                      note: Text("About \(DailyLesson.minutesLeft(in: content.steps)) min"))
                    CorkBoard(content: content)
                }
            }
            VStack(alignment: .leading, spacing: 12) {
                LearnSectionTitle(title: Text(verbatim: "Deine Fotos"), note: Text("All of Learn"))
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 18), GridItem(.flexible(), spacing: 18)],
                          spacing: 22) {
                    ForEach(Array(content.overview.doors.enumerated()), id: \.element.id) { index, part in
                        Polaroid(part: part, tilt: Self.tilts[index % Self.tilts.count]) {
                            content.openPart(part.kind)
                        }
                    }
                }
                .padding(.horizontal, 6)
            }
        }
    }

    /// How much each note and photo leans, so the board looks pinned up by hand.
    static let tilts: [Double] = [-3, 2.5, 1.5, -2, 3, -1.5]
}

/// The cork board with a sticky note per step and the button for the next one.
private struct CorkBoard: View {
    let content: LearnPageContent

    var body: some View {
        let current = content.current
        VStack(spacing: 18) {
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 18) {
                ForEach(Array(content.steps.enumerated()), id: \.element.id) { index, step in
                    StickyNote(step: step, isCurrent: step.id == current?.id,
                               tilt: LearnBoardDesign.tilts[index % LearnBoardDesign.tilts.count]) {
                        content.open(step.target)
                    }
                    .matchedTransitionSource(id: step.target, in: content.zoom)
                }
            }
            if let current {
                GlassEffectContainer {
                    Button { content.open(current.target) } label: {
                        Label {
                            Text(verbatim: "Abreißen und los")
                        } icon: {
                            Image(systemName: "pin.fill")
                        }
                    }
                    .buttonStyle(.primary)
                }
            }
        }
        .padding(18)
        .background {
            ZStack {
                Color(hex: 0xB0814F)
                Canvas { context, size in
                    // Cork's specks, in a fixed pattern.
                    var seed: UInt64 = 7
                    for _ in 0..<260 {
                        seed = seed &* 6_364_136_223_846_793_005 &+ 1
                        let x = CGFloat(seed >> 33 % 10_000) / 10_000 * size.width
                        seed = seed &* 6_364_136_223_846_793_005 &+ 1
                        let y = CGFloat(seed >> 33 % 10_000) / 10_000 * size.height
                        context.fill(Path(ellipseIn: CGRect(x: x, y: y, width: 2.5, height: 2.5)),
                                     with: .color(.black.opacity(0.18)))
                    }
                }
            }
            .clipShape(.rect(cornerRadius: 26, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .strokeBorder(Color(hex: 0x6B4A2B), lineWidth: 6)
            }
        }
    }
}

/// A step as a sticky note: a pin, the part, the step in handwriting, a big tick once done.
private struct StickyNote: View {
    let step: LessonStep
    let isCurrent: Bool
    let tilt: Double
    let onOpen: () -> Void

    private static let ink = Color(hex: 0x2B2620)

    var body: some View {
        Button(action: onOpen) {
            VStack(alignment: .leading, spacing: 6) {
                Text(verbatim: step.part.germanName)
                    .font(.custom("Noteworthy-Bold", size: 15, relativeTo: .footnote))
                    .opacity(0.6)
                step.title.text
                    .font(.custom("Noteworthy-Bold", size: 19, relativeTo: .headline))
                    .lineLimit(3)
                    .minimumScaleFactor(0.7)
                    .strikethrough(step.isDone, color: Color(hex: 0xC0392B))
                Spacer(minLength: 0)
                Text(verbatim: "\(step.minutes) Min.")
                    .font(.custom("Noteworthy-Bold", size: 14, relativeTo: .caption))
                    .opacity(0.6)
            }
            .foregroundStyle(Self.ink)
            .padding(14)
            .padding(.top, 8)
            .frame(maxWidth: .infinity, minHeight: 140, alignment: .topLeading)
            .background(noteColour)
            .overlay(alignment: .bottomTrailing) {
                if step.isDone {
                    Image(systemName: "checkmark")
                        .font(.system(size: 34, weight: .heavy))
                        .foregroundStyle(Color(hex: 0xC0392B).opacity(0.8))
                        .padding(10)
                }
            }
            .overlay(alignment: .top) {
                Circle()
                    .fill(RadialGradient(colors: [Color(hex: 0xFF8A80), Color(hex: 0xB71C1C)],
                                         center: UnitPoint(x: 0.35, y: 0.3), startRadius: 0, endRadius: 9))
                    .frame(width: 16, height: 16)
                    .shadow(color: .black.opacity(0.4), radius: 2, y: 2)
                    .offset(y: -4)
            }
            .shadow(color: .black.opacity(isCurrent ? 0.45 : 0.25), radius: isCurrent ? 10 : 4, y: isCurrent ? 8 : 3)
            .scaleEffect(isCurrent ? 1.04 : 1)
            .rotationEffect(.degrees(tilt))
            .contentShape(.rect)
        }
        .buttonStyle(.tile)
        .accessibilityElement(children: .combine)
        .accessibilityValue(step.isDone ? Text("Done") : Text(verbatim: ""))
    }

    /// The note's paper: yellow, warmed by the theme colour; paler once done.
    private var noteColour: some View {
        ZStack {
            Color(hex: 0xFFE98A)
            Color.accentFill.opacity(0.18)
            if step.isDone {
                Color.white.opacity(0.3)
            }
        }
    }
}

/// A part as an instant photo taped to the board: the picture, and its name and progress written underneath.
private struct Polaroid: View {
    let part: LearnOverview.Part
    let tilt: Double
    let onOpen: () -> Void

    var body: some View {
        Button(action: onOpen) {
            VStack(alignment: .leading, spacing: 6) {
                ScenarioArtwork(systemImage: part.kind.systemImage, symbolSize: 44, cornerRadius: 2)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(alignment: .bottomLeading) {
                        PartBar(fraction: part.shownFraction)
                            .padding(8)
                    }
                Text(part.kind.title)
                    .font(.custom("Noteworthy-Bold", size: 19, relativeTo: .headline))
                Text(verbatim: part.count)
                    .font(.custom("Noteworthy-Bold", size: 14, relativeTo: .caption))
                    .opacity(0.6)
            }
            .foregroundStyle(Color(hex: 0x2B2620))
            .padding(10)
            .padding(.bottom, 4)
            .background(Color(hex: 0xFBFAF6))
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(Color.white.opacity(0.55))
                    .frame(width: 56, height: 18)
                    .rotationEffect(.degrees(-tilt * 2))
                    .offset(y: -9)
            }
            .shadow(color: .black.opacity(0.3), radius: 6, y: 4)
            .rotationEffect(.degrees(tilt))
            .contentShape(.rect)
        }
        .buttonStyle(.tile)
        .accessibilityElement(children: .combine)
        .accessibilityValue(Text(verbatim: part.count))
    }
}
