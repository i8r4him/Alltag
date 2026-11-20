//
//  LearnTicketDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Page design 1, "Fahrkarte": today's lesson is a train ticket from the
/// learner's level to the next, its steps the stops on the route, and the
/// parts of Learn a departure board, one platform each.
struct LearnTicketDesign: View {
    let content: LearnPageContent

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            if !content.steps.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    LearnSectionTitle(title: Text(verbatim: "Heute"),
                                      note: Text("About \(DailyLesson.minutesLeft(in: content.steps)) min"))
                    LessonTicket(content: content)
                }
            }
            VStack(alignment: .leading, spacing: 12) {
                LearnSectionTitle(title: Text(verbatim: "Abfahrt"), note: Text("All of Learn"))
                DepartureBoard(parts: content.overview.doors, onOpen: content.openPart)
            }
        }
    }
}

/// The lesson as a ticket: where it goes, the next stop and the platform, a
/// perforation, the route with a stop per step, and "Einsteigen".
private struct LessonTicket: View {
    let content: LearnPageContent

    @State private var topHeight: CGFloat = 120

    var body: some View {
        let steps = content.steps
        let current = DailyLesson.current(in: steps)
        VStack(spacing: 0) {
            header(current: current)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 16)
                .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { topHeight = $0 }
            Perforation()
                .stroke(Color.secondary.opacity(0.5), style: StrokeStyle(lineWidth: 1.5, dash: [6, 5]))
                .frame(height: 1.5)
                .padding(.horizontal, 20)
            TicketRoute(steps: steps, current: current, zoom: content.zoom) { content.open($0.target) }
                .padding(.horizontal, 14)
                .padding(.top, 18)
            if let current {
                GlassEffectContainer {
                    Button { content.open(current.target) } label: {
                        Label {
                            Text(verbatim: "Einsteigen")
                        } icon: {
                            Image(systemName: "tram.fill")
                        }
                    }
                    .buttonStyle(.primary)
                }
                .padding(.horizontal, 18)
                .padding(.top, 14)
            }
        }
        .padding(.bottom, 18)
        .glassEffect(.regular, in: TicketShape(perforationY: topHeight))
    }

    private func header(current: LessonStep?) -> some View {
        let steps = content.steps
        let platform = (current.flatMap { step in steps.firstIndex { $0.id == step.id } } ?? steps.count - 1) + 1
        return HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(verbatim: "FAHRKARTE · \(Date.now.german(.dateTime.weekday(.abbreviated).day().month(.twoDigits)))")
                    .font(.caption.weight(.heavy))
                    .tracking(1.2)
                    .foregroundStyle(.secondary)
                HStack(spacing: 8) {
                    Text(verbatim: content.level.title)
                    Image(systemName: "arrow.right")
                        .foregroundStyle(.accent)
                    Text(verbatim: (Level.allCases.first { $0 > content.level } ?? content.level).title)
                }
                .font(.title2.weight(.heavy))
                if let current {
                    HStack(spacing: 4) {
                        Text("Next stop:")
                            .foregroundStyle(.secondary)
                        current.title.text
                            .fontWeight(.bold)
                            .lineLimit(1)
                    }
                    .font(.subheadline)
                } else {
                    Label("Done for today", systemImage: "checkmark.circle.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.accent)
                }
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 0) {
                Text(verbatim: "GLEIS")
                    .font(.caption.weight(.heavy))
                    .tracking(1)
                    .foregroundStyle(.secondary)
                Text(verbatim: "\(platform)")
                    .font(.system(size: 36, weight: .heavy, design: .rounded))
                    .foregroundStyle(.accent)
                    .contentTransition(.numericText())
            }
            .accessibilityHidden(true)
        }
    }
}

/// The route on the ticket: a stop per step, joined by a line that fills in as they are done.
private struct TicketRoute: View {
    let steps: [LessonStep]
    let current: LessonStep?
    let zoom: Namespace.ID
    let onOpen: (LessonStep) -> Void

    private let stopWidth: CGFloat = 58
    private let dotSize: CGFloat = 32

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                stop(step)
                if index < steps.count - 1 {
                    Capsule()
                        .fill(step.isDone ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.controlFill))
                        .frame(height: 4)
                        .padding(.horizontal, -(stopWidth - dotSize) / 2)
                        .padding(.top, dotSize / 2 - 2)
                        .zIndex(-1)
                }
            }
        }
    }

    private func stop(_ step: LessonStep) -> some View {
        let isCurrent = step.id == current?.id
        return Button { onOpen(step) } label: {
            VStack(spacing: 6) {
                LessonStepDot(step: step, isCurrent: isCurrent, size: dotSize)
                    .shadow(color: isCurrent ? Color.accentFill.opacity(0.7) : .clear, radius: 8)
                Text(verbatim: step.part.germanName)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(isCurrent ? HierarchicalShapeStyle.primary : HierarchicalShapeStyle.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(width: stopWidth)
            .contentShape(.rect)
        }
        .buttonStyle(.tile)
        .matchedTransitionSource(id: step.target, in: zoom)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(step.title.text)
        .accessibilityValue(step.isDone ? Text("Done") : Text(verbatim: ""))
    }
}

/// "Abfahrt": the parts of Learn as rows on a departure board, the counts in
/// the board's monospaced figures.
private struct DepartureBoard: View {
    let parts: [LearnOverview.Part]
    let onOpen: (LearnPart) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(parts.enumerated()), id: \.element.id) { index, part in
                if index > 0 {
                    Divider()
                        .padding(.leading, 16)
                }
                Button { onOpen(part.kind) } label: { row(part, platform: index + 1) }
                    .buttonStyle(.plain)
                    .accessibilityElement(children: .combine)
            }
        }
        .padding(.vertical, 4)
        .glassEffect(.regular, in: .rect(cornerRadius: 26, style: .continuous))
    }

    private func row(_ part: LearnOverview.Part, platform: Int) -> some View {
        HStack(spacing: 12) {
            VStack(spacing: 0) {
                Text(verbatim: "GLEIS")
                    .font(.system(size: 9, weight: .heavy, design: .monospaced))
                Text(verbatim: "\(platform)")
                    .font(.system(.headline, design: .monospaced, weight: .heavy))
            }
            .foregroundStyle(Color.accent.opacity(0.7))
            .frame(width: 40)
            .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(part.kind.title)
                    .font(.headline)
                if let next = part.next {
                    next.title.text
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(verbatim: part.count)
                .font(.system(.callout, design: .monospaced, weight: .heavy))
                .foregroundStyle(.accent)
            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(minHeight: Spacing.rowMinHeight)
        .contentShape(.rect)
    }
}

/// A ticket's outline: a rounded card with a round notch cut from each side at the perforation.
private struct TicketShape: Shape {
    var perforationY: CGFloat
    var notchRadius: CGFloat = 12
    var cornerRadius: CGFloat = 28

    var animatableData: CGFloat {
        get { perforationY }
        set { perforationY = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let card = Path(roundedRect: rect, cornerRadius: cornerRadius, style: .continuous)
        let diameter = notchRadius * 2
        let y = rect.minY + perforationY - notchRadius
        let left = Path(ellipseIn: CGRect(x: rect.minX - notchRadius, y: y, width: diameter, height: diameter))
        let right = Path(ellipseIn: CGRect(x: rect.maxX - notchRadius, y: y, width: diameter, height: diameter))
        return card.subtracting(left).subtracting(right)
    }
}

/// The ticket's perforation: a straight line across, drawn dashed.
private struct Perforation: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}
