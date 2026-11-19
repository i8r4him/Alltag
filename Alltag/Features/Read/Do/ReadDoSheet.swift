//
//  ReadDoSheet.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A scene drawn as the thing it is: a dark departure board, a sign with a
/// border, a cream box label, a form, a narrow receipt, a pink prescription,
/// a contract in serif type, a dark TV guide. Real things keep
/// their own colours in light and dark mode. Each line can be tapped.
struct ReadDoSheet: View {
    /// How a line looks while the learner looks for the answer.
    enum LineStatus { case open, right, wrong, hint }

    let scene: ReadDoScene
    var status: (ReadDoLine) -> LineStatus = { _ in .open }
    /// `nil` for a preview that can't be tapped.
    var onTap: ((ReadDoLine) -> Void)?

    private static let german = Locale(identifier: "de_DE")

    var body: some View {
        let look = ReadDoLook(kind: scene.kind)
        VStack(alignment: .leading, spacing: look.spacing) {
            ForEach(scene.lines) { line in
                if let onTap, line.isTappable {
                    Button { onTap(line) } label: {
                        ReadDoLineView(line: line, look: look, status: status(line))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(Text(verbatim: line.cells.joined(separator: ", ")))
                } else {
                    ReadDoLineView(line: line, look: look, status: .open)
                }
            }
        }
        .foregroundStyle(look.ink)
        .fontDesign(look.design)
        .padding(look.padding)
        .frame(maxWidth: look.maxWidth, alignment: .leading)
        .background(look.background, in: .rect(cornerRadius: look.cornerRadius, style: .continuous))
        .overlay {
            if let border = look.border {
                RoundedRectangle(cornerRadius: look.cornerRadius, style: .continuous)
                    .inset(by: 5)
                    .strokeBorder(border, lineWidth: 2.5)
            }
        }
        .shadow(color: .black.opacity(0.3), radius: 14, y: 8)
        .frame(maxWidth: .infinity)
        .environment(\.locale, Self.german)
    }
}

/// The look of each kind of thing.
private struct ReadDoLook {
    var background: Color
    var ink: Color
    /// Headings and the numbers that matter: the board's yellow, the label's green.
    var highlight: Color
    var design: Font.Design = .default
    var cornerRadius: CGFloat = 14
    var border: Color?
    var maxWidth: CGFloat?
    var padding: CGFloat = 20
    var spacing: CGFloat = 8

    private static let paper = Color(red: 0.97, green: 0.96, blue: 0.93)
    private static let darkInk = Color(red: 0.13, green: 0.13, blue: 0.15)

    init(kind: ReadDoKind) {
        background = Self.paper
        ink = Self.darkInk
        highlight = Self.darkInk
        switch kind {
        case .departures:
            background = Color(red: 0.05, green: 0.11, blue: 0.27)
            ink = .white
            highlight = Color(red: 1, green: 0.83, blue: 0.2)
            spacing = 10
        case .sign:
            background = .white
            border = Self.darkInk
            cornerRadius = 12
            padding = 24
        case .packaging:
            background = Color(red: 0.98, green: 0.95, blue: 0.87)
            ink = Color(red: 0.23, green: 0.16, blue: 0.09)
            highlight = Color(red: 0.16, green: 0.45, blue: 0.22)
            cornerRadius = 26
        case .form:
            background = .white
            ink = Color(red: 0.12, green: 0.17, blue: 0.28)
            highlight = Color(red: 0.12, green: 0.17, blue: 0.28)
            cornerRadius = 6
            spacing = 12
        case .receipt:
            background = .white
            design = .monospaced
            cornerRadius = 3
            maxWidth = 320
            spacing = 5
        case .binCalendar:
            background = .white
            highlight = Color(red: 0.16, green: 0.45, blue: 0.22)
            cornerRadius = 10
        case .bill, .payslip:
            cornerRadius = 6
        case .ticket, .prescription, .contract, .tvGuide, .schedule:
            applyPaper(of: kind)
        }
    }

    /// The looks of tickets, prescriptions, contracts, TV guides and schedules.
    private mutating func applyPaper(of kind: ReadDoKind) {
        switch kind {
        case .ticket:
            background = .white
            highlight = Color(red: 0.75, green: 0.1, blue: 0.15)
            cornerRadius = 10
            maxWidth = 340
        case .prescription:
            // The pink of a German prescription form.
            background = Color(red: 0.99, green: 0.89, blue: 0.91)
            highlight = Color(red: 0.6, green: 0.1, blue: 0.25)
            cornerRadius = 4
            spacing = 10
        case .contract:
            design = .serif
            cornerRadius = 4
            spacing = 10
        case .tvGuide:
            background = Color(red: 0.1, green: 0.09, blue: 0.2)
            ink = .white
            highlight = Color(red: 0.55, green: 0.8, blue: 1)
            spacing = 10
        case .schedule:
            background = .white
            highlight = Color(red: 0, green: 0.42, blue: 0.48)
            cornerRadius = 12
        default:
            break
        }
    }
}

/// One line, lit coral when it was a wrong tap, green when right, glowing as a hint.
private struct ReadDoLineView: View {
    let line: ReadDoLine
    let look: ReadDoLook
    let status: ReadDoSheet.LineStatus

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 6)
            .padding(.vertical, line.style == .rule ? 0 : 3)
            .background(tint.opacity(status == .open ? 0 : 0.3), in: .rect(cornerRadius: 8, style: .continuous))
            .overlay {
                if status == .hint {
                    let outline = RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .strokeBorder(Color.accentFill, lineWidth: 2)
                    if reduceMotion {
                        outline
                    } else {
                        outline.phaseAnimator([0.35, 1]) { view, phase in view.opacity(phase) }
                    }
                }
            }
            .padding(.horizontal, -6)
            .contentShape(.rect)
            .animation(.easeOut(duration: 0.2), value: status)
            .accessibilityValue(accessibilityValue)
    }

    @ViewBuilder
    private var content: some View {
        switch line.style {
        case .heading:
            Text(verbatim: line.cells.first ?? "")
                .font(.title2.weight(.heavy))
                .foregroundStyle(look.highlight)
                .fixedSize(horizontal: false, vertical: true)
        case .label:
            Text(verbatim: line.cells.first ?? "")
                .font(.caption.weight(.heavy))
                .textCase(.uppercase)
                .opacity(0.7)
                .padding(.top, 6)
        case .rule:
            DashedLine()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 3]))
                .frame(height: 1)
                .opacity(0.4)
                .padding(.vertical, 4)
        case .row:
            ReadDoRow(cells: line.cells, look: look)
        case .field:
            VStack(alignment: .leading, spacing: 4) {
                Text(verbatim: line.cells.first ?? "")
                    .font(.footnote.weight(.semibold))
                    .opacity(0.75)
                Rectangle()
                    .fill(look.ink.opacity(0.35))
                    .frame(height: 1)
                    .padding(.top, 14)
            }
        case .text:
            Text(verbatim: line.cells.first ?? "")
                .font(.callout.weight(.medium))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var tint: Color {
        switch status {
        case .right: .success
        case .wrong: .mistake
        case .hint, .open: .clear
        }
    }

    private var accessibilityValue: Text {
        switch status {
        case .right: Text("Right")
        case .wrong: Text("Wrong")
        case .hint, .open: Text(verbatim: "")
        }
    }
}

/// Cells side by side: the first in its own column, the last on the right,
/// the rest in between. A bin's name gets the bin's colour.
private struct ReadDoRow: View {
    let cells: [String]
    let look: ReadDoLook

    @ScaledMetric(relativeTo: .callout) private var firstColumn: CGFloat = 64

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            if cells.count > 2 {
                cell(cells[0])
                    .frame(width: firstColumn, alignment: .leading)
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    ForEach(Array(cells.dropFirst().dropLast().enumerated()), id: \.offset) { _, text in
                        cell(text)
                    }
                }
                Spacer(minLength: 6)
                cell(cells[cells.count - 1])
                    .foregroundStyle(look.highlight)
            } else {
                cell(cells.first ?? "")
                Spacer(minLength: 8)
                if cells.count == 2 {
                    cell(cells[1])
                        .fontWeight(.bold)
                        .monospacedDigit()
                }
            }
        }
        .font(.callout.weight(.semibold))
    }

    private func cell(_ text: String) -> some View {
        HStack(spacing: 6) {
            if let bin = BinColour(name: text) {
                Circle()
                    .fill(bin.colour)
                    .overlay { Circle().strokeBorder(.black.opacity(0.25), lineWidth: 0.5) }
                    .frame(width: 11, height: 11)
                    .accessibilityHidden(true)
            }
            Text(verbatim: text)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

/// The colours of German bins, which mean something: grey for the rest,
/// brown for food, blue for paper, yellow for packaging.
private enum BinColour {
    case rest, bio, paper, yellow, glass

    init?(name: String) {
        if name.hasPrefix("Restmüll") {
            self = .rest
        } else if name.hasPrefix("Bio") {
            self = .bio
        } else if name.hasPrefix("Papier") || name.hasPrefix("Altpapier") {
            self = .paper
        } else if name.hasPrefix("Gelbe") {
            self = .yellow
        } else if name.hasPrefix("Glas") {
            self = .glass
        } else {
            return nil
        }
    }

    var colour: Color {
        switch self {
        case .rest: Color(white: 0.35)
        case .bio: Color(red: 0.45, green: 0.3, blue: 0.16)
        case .paper: Color(red: 0.16, green: 0.38, blue: 0.75)
        case .yellow: Color(red: 0.98, green: 0.8, blue: 0.1)
        case .glass: Color(red: 0.2, green: 0.6, blue: 0.35)
        }
    }
}

/// A straight line across, for the receipt's dashes.
private struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        }
    }
}
