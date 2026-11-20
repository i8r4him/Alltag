//
//  KeyboardGeometry.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import CoreGraphics
import Foundation

/// The sizes that shape the keys, measured on Apple's own keyboard (iOS 27, a 440 pt wide iPhone):
/// keys 33.3 pt wide and 44.7 pt high, 6 pt apart, rows 11.3 pt apart.
/// Drawing and touch handling read the same ones.
struct KeyboardMetrics: Equatable {
    var topInset: CGFloat = 3
    /// Down to where iOS draws its globe and microphone.
    var bottomInset: CGFloat = 7
    var keyGap: CGFloat = 6
    var rowGap: CGFloat = 11.33
    /// The numbers row is a little lower than the letter rows.
    var numbersHeight: CGFloat = 0.82
    /// Shift and delete, as a share of the keyboard's width.
    var sideKeyShare: CGFloat = 0.1136
    /// The page key, the emoji key and the globe.
    var smallKeyShare: CGFloat = 0.109
    var returnKeyShare: CGFloat = 0.232

    static let portrait = KeyboardMetrics()
    static let landscape = KeyboardMetrics(topInset: 2, bottomInset: 3, rowGap: 6)

    /// The room left and right of the keys: 3 pt on most iPhones, more on the widest.
    static func sideInset(for width: CGFloat) -> CGFloat {
        min(max(3 + (width - 402) * 0.0965, 3), 6.67)
    }
}

/// Where one key is drawn.
struct KeyFrame: Equatable, Identifiable {
    let key: KeyboardKey
    let frame: CGRect
    let row: Int

    var id: KeyboardKey { key }
}

/// The frames of all keys for one size, and which key a touch means.
///
/// The first row is the numbers row. A touch between two keys or beside a row
/// counts for the nearest key, so no tap is lost in a gap.
struct KeyboardGeometry: Equatable {
    let frames: [KeyFrame]
    let size: CGSize

    init(rows: [[KeyboardKey]], size: CGSize, metrics: KeyboardMetrics = .portrait) {
        self.size = size
        guard !rows.isEmpty, size.width > 0, size.height > 0 else {
            frames = []
            return
        }
        let inset = KeyboardMetrics.sideInset(for: size.width)
        let unit = Self.unitWidth(of: rows, width: size.width, inset: inset, metrics: metrics)
        let gaps = CGFloat(rows.count - 1) * metrics.rowGap
        let keyHeight = (size.height - metrics.topInset - metrics.bottomInset - gaps)
            / (CGFloat(rows.count - 1) + metrics.numbersHeight)
        var frames: [KeyFrame] = []
        var y = metrics.topInset
        for (index, row) in rows.enumerated() {
            let height = index == 0 ? keyHeight * metrics.numbersHeight : keyHeight
            let spans = Self.spans(of: row, unit: unit, width: size.width, inset: inset, metrics: metrics)
            for (key, span) in zip(row, spans) {
                frames.append(KeyFrame(key: key, frame: CGRect(x: span.x, y: y, width: span.width, height: height), row: index))
            }
            y += height + metrics.rowGap
        }
        self.frames = frames
    }

    /// The key a touch at `point` means: the nearest key of the nearest row.
    func key(at point: CGPoint) -> KeyFrame? {
        let nearestRow = frames.min {
            Self.distance(from: point.y, to: $0.frame.minY...$0.frame.maxY)
                < Self.distance(from: point.y, to: $1.frame.minY...$1.frame.maxY)
        }?.row
        return frames.filter { $0.row == nearestRow }.min {
            Self.distance(from: point.x, to: $0.frame.minX...$0.frame.maxX)
                < Self.distance(from: point.x, to: $1.frame.minX...$1.frame.maxX)
        }
    }

    func frame(of key: KeyboardKey) -> KeyFrame? {
        frames.first { $0.key == key }
    }

    // MARK: - Rows

    private struct Span {
        let x: CGFloat
        let width: CGFloat
    }

    /// The width of a letter key: the widest row of plain keys fills the keyboard.
    private static func unitWidth(of rows: [[KeyboardKey]], width: CGFloat, inset: CGFloat,
                                  metrics: KeyboardMetrics) -> CGFloat {
        let most = rows.filter { $0.allSatisfy(\.isCharacter) }.map(\.count).max() ?? 10
        return (width - 2 * inset - CGFloat(most - 1) * metrics.keyGap) / CGFloat(most)
    }

    private static func spans(of row: [KeyboardKey], unit: CGFloat, width: CGFloat, inset: CGFloat,
                              metrics: KeyboardMetrics) -> [Span] {
        if row.contains(.space) {
            return bottomSpans(of: row, width: width, inset: inset, metrics: metrics)
        }
        if row.allSatisfy(\.isCharacter) {
            let inner = width - 2 * inset - CGFloat(row.count - 1) * metrics.keyGap
            return run(count: row.count, from: inset, width: inner / CGFloat(row.count), gap: metrics.keyGap)
        }
        return sidedSpans(of: row, unit: unit, width: width, inset: inset, metrics: metrics)
    }

    /// Shift and delete (or a page key and delete) at the edges, the keys between them centred.
    private static func sidedSpans(of row: [KeyboardKey], unit: CGFloat, width: CGFloat, inset: CGFloat,
                                   metrics: KeyboardMetrics) -> [Span] {
        let middle = row.count - 2
        guard middle > 0 else { return [] }
        let side = width * metrics.sideKeyShare
        let room = width - 2 * inset - 2 * side - 2 * metrics.keyGap - CGFloat(middle - 1) * metrics.keyGap
        // Seven letters keep the width of the rows above; a few punctuation keys may grow.
        let keyWidth = min(room / CGFloat(middle), middle > 5 ? unit : unit * 1.5)
        let used = CGFloat(middle) * keyWidth + CGFloat(middle - 1) * metrics.keyGap
        let first = Span(x: inset, width: side)
        let last = Span(x: width - inset - side, width: side)
        return [first] + run(count: middle, from: (width - used) / 2, width: keyWidth, gap: metrics.keyGap) + [last]
    }

    /// The bottom row: fixed keys at both ends, the space bar takes the rest.
    private static func bottomSpans(of row: [KeyboardKey], width: CGFloat, inset: CGFloat,
                                    metrics: KeyboardMetrics) -> [Span] {
        let fixed = row.map { key -> CGFloat? in
            switch key {
            case .space: nil
            case .enter: width * metrics.returnKeyShare
            default: width * metrics.smallKeyShare
            }
        }
        let taken = fixed.compactMap { $0 }.reduce(0, +)
        let space = width - 2 * inset - taken - CGFloat(row.count - 1) * metrics.keyGap
        var x = inset
        return fixed.map { fixedWidth in
            let span = Span(x: x, width: fixedWidth ?? space)
            x += span.width + metrics.keyGap
            return span
        }
    }

    private static func run(count: Int, from start: CGFloat, width: CGFloat, gap: CGFloat) -> [Span] {
        (0..<count).map { Span(x: start + CGFloat($0) * (width + gap), width: width) }
    }

    private static func distance(from value: CGFloat, to range: ClosedRange<CGFloat>) -> CGFloat {
        max(range.lowerBound - value, value - range.upperBound, 0)
    }
}
