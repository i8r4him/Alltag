//
//  LearnReceiptDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Page design 6, "Kassenbon": today's lesson is a till receipt from the
/// German supermarket (each step a line with its minutes as the price, the
/// sum, a barcode), and the parts of Learn are stamp cards, a stamp for every
/// tenth of the way.
struct LearnReceiptDesign: View {
    let content: LearnPageContent

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            if !content.steps.isEmpty {
                VStack(alignment: .leading, spacing: 14) {
                    LearnSectionTitle(title: Text(verbatim: "Heute"), note: Text("Your receipt"))
                    LessonReceipt(content: content)
                    if let current = content.current {
                        GlassEffectContainer {
                            Button { content.open(current.target) } label: {
                                Label {
                                    Text(verbatim: "Einlösen")
                                } icon: {
                                    Image(systemName: "cart.fill")
                                }
                            }
                            .buttonStyle(.primary)
                        }
                    }
                }
            }
            VStack(alignment: .leading, spacing: 12) {
                LearnSectionTitle(title: Text(verbatim: "Stempelkarten"), note: Text("All of Learn"))
                GlassEffectContainer(spacing: 0) {
                    VStack(spacing: Spacing.grid) {
                        ForEach(content.overview.doors) { part in
                            StampCard(part: part) { content.openPart(part.kind) }
                        }
                    }
                }
            }
        }
    }
}

/// The receipt: the shop, the date, a line per step, the sum and a barcode, on white paper with a torn edge.
private struct LessonReceipt: View {
    let content: LearnPageContent

    private static let ink = Color(hex: 0x1E1E1E)

    var body: some View {
        VStack(spacing: 10) {
            VStack(spacing: 2) {
                Text(verbatim: "ALLTAG MARKT")
                    .font(.system(.title3, design: .monospaced, weight: .heavy))
                Text(verbatim: "Deutsch für jeden Tag")
                    .font(.system(.caption, design: .monospaced))
                Text(verbatim: Date.now.german(.dateTime.day(.twoDigits).month(.twoDigits).year().hour().minute()))
                    .font(.system(.caption, design: .monospaced))
                    .padding(.top, 4)
            }
            dashes
            VStack(spacing: 6) {
                ForEach(content.steps) { step in
                    Button { content.open(step.target) } label: { line(step) }
                        .buttonStyle(.plain)
                        .matchedTransitionSource(id: step.target, in: content.zoom)
                        .accessibilityElement(children: .combine)
                        .accessibilityValue(step.isDone ? Text("Done") : Text(verbatim: ""))
                }
            }
            dashes
            HStack(alignment: .firstTextBaseline) {
                Text(verbatim: "SUMME")
                Spacer()
                Text(verbatim: "\(content.totalMinutes) MIN")
            }
            .font(.system(.title3, design: .monospaced, weight: .heavy))
            HStack {
                Text(verbatim: "ERLEDIGT")
                Spacer()
                Text(verbatim: "\(content.doneCount) / \(content.steps.count)")
            }
            .font(.system(.footnote, design: .monospaced, weight: .semibold))
            Barcode()
                .frame(height: 44)
                .padding(.top, 8)
                .accessibilityHidden(true)
            Text(verbatim: "Danke fürs Lernen!")
                .font(.system(.caption, design: .monospaced, weight: .semibold))
        }
        .foregroundStyle(Self.ink)
        .padding(.horizontal, 22)
        .padding(.top, 22)
        .padding(.bottom, 30)
        .background(Color(hex: 0xFBFAF6), in: ReceiptShape())
        .shadow(color: .black.opacity(0.3), radius: 14, y: 8)
        .padding(.horizontal, 10)
    }

    private func line(_ step: LessonStep) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Text(verbatim: step.isDone ? "✓" : "·")
                .frame(width: 14)
            VStack(alignment: .leading, spacing: 0) {
                Text(verbatim: step.part.germanName.uppercased())
                    .font(.system(.caption2, design: .monospaced, weight: .heavy))
                    .opacity(0.6)
                step.title.text
                    .lineLimit(1)
                    .strikethrough(step.isDone)
            }
            Spacer(minLength: 8)
            Text(verbatim: "\(step.minutes),00")
        }
        .font(.system(.subheadline, design: .monospaced, weight: .semibold))
        .opacity(step.isDone ? 0.55 : 1)
        .contentShape(.rect)
    }

    private var dashes: some View {
        Text(verbatim: String(repeating: "- ", count: 40))
            .font(.system(.caption, design: .monospaced))
            .lineLimit(1)
            .truncationMode(.tail)
            .opacity(0.5)
            .accessibilityHidden(true)
    }
}

/// A barcode of bars in fixed widths, drawn in ink.
private struct Barcode: View {
    private let widths: [CGFloat] = [3, 1, 2, 1, 1, 3, 2, 1, 3, 1, 2, 2, 1, 1, 3, 1, 2, 1, 3, 2, 1, 2, 1, 1, 3, 1, 2,
                                     1, 2, 3, 1, 1, 2, 1, 3, 1]

    var body: some View {
        Canvas { context, size in
            let unit = size.width / widths.reduce(0, +) / 1.6
            var x: CGFloat = 0
            for (index, width) in widths.enumerated() {
                if index.isMultiple(of: 2) {
                    context.fill(Path(CGRect(x: x, y: 0, width: width * unit, height: size.height)),
                                 with: .color(.black))
                }
                x += width * unit * (index.isMultiple(of: 2) ? 1 : 2.2)
            }
        }
    }
}

/// A receipt's outline: straight at the top, torn into a zigzag at the bottom.
private struct ReceiptShape: Shape {
    var tooth: CGFloat = 10

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - tooth))
        let count = max(1, Int(rect.width / (tooth * 2)))
        let step = rect.width / CGFloat(count)
        for index in 0..<count {
            let right = rect.maxX - CGFloat(index) * step
            path.addLine(to: CGPoint(x: right - step / 2, y: rect.maxY))
            path.addLine(to: CGPoint(x: right - step, y: rect.maxY - tooth))
        }
        path.closeSubpath()
        return path
    }
}

/// A part as a stamp card: its name and count, and ten stamps, filled as far as the learner has come.
private struct StampCard: View {
    let part: LearnOverview.Part
    let onOpen: () -> Void

    var body: some View {
        let stamps = Int((part.shownFraction * 10).rounded())
        Button(action: onOpen) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .firstTextBaseline) {
                    Text(part.kind.title)
                        .font(.headline)
                    Spacer()
                    Text(verbatim: part.count)
                        .font(.system(.subheadline, design: .monospaced, weight: .bold))
                        .foregroundStyle(.accent)
                }
                HStack(spacing: 0) {
                    ForEach(0..<10, id: \.self) { index in
                        stamp(isFilled: index < stamps)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(16)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 22, style: .continuous))
            .contentShape(.rect(cornerRadius: 22, style: .continuous))
        }
        .buttonStyle(.card)
        .accessibilityElement(children: .combine)
    }

    private func stamp(isFilled: Bool) -> some View {
        ZStack {
            Circle()
                .strokeBorder(isFilled ? AnyShapeStyle(Color.clear) : AnyShapeStyle(.controlFill),
                              style: StrokeStyle(lineWidth: 1.5, dash: [3, 3]))
            if isFilled {
                Circle()
                    .fill(.accentFill)
                Image(systemName: part.kind.systemImage)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(.onAccent)
            }
        }
        .frame(width: 26, height: 26)
        .rotationEffect(.degrees(isFilled ? -12 : 0))
    }
}
