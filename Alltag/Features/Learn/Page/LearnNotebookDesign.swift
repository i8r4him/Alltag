//
//  LearnNotebookDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Page design 2, "Heft": today's lesson is a page of the learner's exercise
/// book, a handwritten list ticked off as they go, and the parts of Learn are
/// binders on a shelf, each filled as far as the learner has come.
struct LearnNotebookDesign: View {
    let content: LearnPageContent

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            if !content.steps.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    LearnSectionTitle(title: Text(verbatim: "Heute"),
                                      note: Text("^[\(content.steps.count) thing](inflect: true) · \(totalMinutes) min"))
                    NotebookPage(content: content)
                }
            }
            VStack(alignment: .leading, spacing: 12) {
                LearnSectionTitle(title: Text(verbatim: "Deine Ordner"), note: Text("Tap one"))
                GlassEffectContainer(spacing: 0) {
                    HStack(alignment: .bottom, spacing: 10) {
                        ForEach(content.overview.doors) { part in
                            Binder(part: part) { content.openPart(part.kind) }
                        }
                    }
                }
            }
        }
    }

    private var totalMinutes: Int {
        content.steps.map(\.minutes).reduce(0, +)
    }
}

/// A lined page with a red margin, the date and the lesson as a handwritten
/// list, each line ticked and struck through once done.
private struct NotebookPage: View {
    let content: LearnPageContent

    private let lineHeight: CGFloat = 38
    private static let paper = Color(hex: 0xF6EEDC)
    private static let ink = Color(hex: 0x2B2620)
    private static let pen = Color(hex: 0xC0392B)

    var body: some View {
        let current = DailyLesson.current(in: content.steps)
        VStack(alignment: .leading, spacing: 0) {
            Text(verbatim: Date.now.german(.dateTime.weekday(.wide).day().month(.wide)))
                .font(.custom("Noteworthy-Bold", size: 20, relativeTo: .headline))
                .foregroundStyle(Color(hex: 0x7A5A2A))
                .frame(height: lineHeight, alignment: .bottom)
            ForEach(content.steps) { step in
                Button { content.open(step.target) } label: { task(step) }
                    .buttonStyle(.plain)
                    .matchedTransitionSource(id: step.target, in: content.zoom)
                    .accessibilityElement(children: .combine)
                    .accessibilityValue(step.isDone ? Text("Done") : Text(verbatim: ""))
            }
            if let current {
                GlassEffectContainer {
                    Button { content.open(current.target) } label: {
                        Label {
                            Text(verbatim: "Weiter")
                        } icon: {
                            Image(systemName: "pencil")
                        }
                    }
                    .buttonStyle(.primary)
                }
                .padding(.top, 18)
            }
        }
        .padding(.leading, 50)
        .padding(.trailing, 18)
        .padding(.top, 8)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background { lines }
        .clipShape(.rect(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.35), radius: 16, y: 8)
        .environment(\.colorScheme, .light)
    }

    private func task(_ step: LessonStep) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 4)
                .strokeBorder(Self.ink.opacity(0.8), lineWidth: 2)
                .frame(width: 20, height: 20)
                .overlay {
                    if step.isDone {
                        Image(systemName: "checkmark")
                            .font(.system(size: 15, weight: .black))
                            .foregroundStyle(Self.pen)
                    }
                }
            HStack(spacing: 6) {
                Text(verbatim: "\(step.part.germanName):")
                step.title.text
            }
            .font(.custom("Noteworthy-Bold", size: 21, relativeTo: .title3))
            .foregroundStyle(step.isDone ? Self.ink.opacity(0.45) : Self.ink)
            .strikethrough(step.isDone, color: Self.pen)
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            Spacer(minLength: 0)
        }
        .frame(height: lineHeight, alignment: .bottom)
        .padding(.bottom, -4)
        .contentShape(.rect)
    }

    /// The paper: cream, ruled in pale blue, with the red margin line.
    private var lines: some View {
        Canvas { context, size in
            var y = lineHeight + 8
            while y < size.height {
                context.fill(Path(CGRect(x: 0, y: y, width: size.width, height: 1)),
                             with: .color(Color(hex: 0x466EAA).opacity(0.3)))
                y += lineHeight
            }
            context.fill(Path(CGRect(x: 36, y: 0, width: 2, height: size.height)),
                         with: .color(Color(hex: 0xDC5046).opacity(0.55)))
        }
        .background(Self.paper)
    }
}

/// A part as a binder standing on the shelf: a ring hole, its symbol, its name
/// down the spine, and the theme colour filling it as far as the learner has come.
private struct Binder: View {
    let part: LearnOverview.Part
    let onOpen: () -> Void

    @ScaledMetric(relativeTo: .headline) private var height: CGFloat = 220

    var body: some View {
        Button(action: onOpen) {
            VStack(spacing: 10) {
                Circle()
                    .fill(.black.opacity(0.4))
                    .frame(width: 14, height: 14)
                Image(systemName: part.kind.systemImage)
                    .font(.title2)
                    .foregroundStyle(.accent)
                Text(part.kind.title)
                    .font(.headline.weight(.heavy))
                    .fixedSize()
                    .rotationEffect(.degrees(-90))
                    .frame(width: 30, height: 90)
                Spacer(minLength: 0)
                Text(verbatim: part.fraction.map { "\(Int(($0 * 100).rounded()))%" } ?? "\(part.done) ✎")
                    .font(.footnote.weight(.heavy))
                    .monospacedDigit()
            }
            .padding(.top, 14)
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity, minHeight: height, maxHeight: height)
            .background(alignment: .bottom) {
                LinearGradient(colors: [Color.accentFill.opacity(0.5), AppTheme.shared.palette.deep.opacity(0.6)],
                               startPoint: .top, endPoint: .bottom)
                    .frame(height: height * max(0.04, part.shownFraction))
            }
            .clipShape(.rect(topLeadingRadius: 14, bottomLeadingRadius: 10, bottomTrailingRadius: 10,
                             topTrailingRadius: 14, style: .continuous))
            .glassEffect(.regular.interactive(),
                         in: .rect(topLeadingRadius: 14, bottomLeadingRadius: 10, bottomTrailingRadius: 10,
                                   topTrailingRadius: 14, style: .continuous))
        }
        .buttonStyle(.tile)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(part.kind.title))
        .accessibilityValue(PartProgressText(part: part).accessibilityText)
    }
}

private extension PartProgressText {
    /// The progress in words, for VoiceOver.
    var accessibilityText: Text {
        switch part.kind {
        case .grammar: Text("\(part.done) of \(part.total) solved")
        case .read: Text("\(part.done) of \(part.total) read")
        case .words: Text("\(part.done) of \(part.total) saved")
        case .write: Text("^[\(part.done) text](inflect: true) written")
        case .listen: Text("Coming soon")
        }
    }
}
