//
//  KeyboardGeometry.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import CoreGraphics
import Foundation

/// The sizes that shape the keys. Drawing and touch handling read the same ones.
struct KeyboardMetrics: Equatable {
    var sideInset: CGFloat = 3
    var topInset: CGFloat = 4
    var bottomInset: CGFloat = 4
    var keyGap: CGFloat = 6
    var rowGap: CGFloat = 10
    /// The numbers row is a little lower than the letter rows.
    var numbersHeight: CGFloat = 0.86
    /// Shift and delete, measured in letter keys.
    var sideKeyWidth: CGFloat = 1.45
    /// Return and the page key of the bottom row, as a share of the keyboard's width.
    var bottomKeyShare: CGFloat = 0.24

    static let portrait = KeyboardMetrics()
    static let landscape = KeyboardMetrics(topInset: 3, bottomInset: 3, rowGap: 6)
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
        let unit = Self.unitWidth(of: rows, width: size.width, metrics: metrics)
        let gaps = CGFloat(rows.count - 1) * metrics.rowGap
        let keyHeight = (size.height - metrics.topInset - metrics.bottomInset - gaps)
            / (CGFloat(rows.count - 1) + metrics.numbersHeight)
        var frames: [KeyFrame] = []
        var y = metrics.topInset
        for (index, row) in rows.enumerated() {
            let height = index == 0 ? keyHeight * metrics.numbersHeight : keyHeight
            for (key, span) in zip(row, Self.spans(of: row, unit: unit, width: size.width, metrics: metrics)) {
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
    private static func unitWidth(of rows: [[KeyboardKey]], width: CGFloat, metrics: KeyboardMetrics) -> CGFloat {
        let most = rows.filter { $0.allSatisfy(\.isCharacter) }.map(\.count).max() ?? 10
        return (width - 2 * metrics.sideInset - CGFloat(most - 1) * metrics.keyGap) / CGFloat(most)
    }

    private static func spans(of row: [KeyboardKey], unit: CGFloat, width: CGFloat, metrics: KeyboardMetrics) -> [Span] {
        if row.contains(.space) {
            return bottomSpans(of: row, width: width, metrics: metrics)
        }
        if row.allSatisfy(\.isCharacter) {
            let inner = width - 2 * metrics.sideInset - CGFloat(row.count - 1) * metrics.keyGap
            return run(count: row.count, from: metrics.sideInset, width: inner / CGFloat(row.count), gap: metrics.keyGap)
        }
        return sidedSpans(of: row, unit: unit, width: width, metrics: metrics)
    }

    /// Shift and delete (or a page key and delete) at the edges, the keys between them centred.
    private static func sidedSpans(of row: [KeyboardKey], unit: CGFloat, width: CGFloat, metrics: KeyboardMetrics) -> [Span] {
        let middle = row.count - 2
        guard middle > 0 else { return [] }
        let side = unit * metrics.sideKeyWidth
        let room = width - 2 * metrics.sideInset - 2 * side - 2 * metrics.keyGap - CGFloat(middle - 1) * metrics.keyGap
        // Seven letters keep the width of the rows above; a few punctuation keys may grow.
        let keyWidth = min(room / CGFloat(middle), middle > 5 ? unit : unit * 1.5)
        let used = CGFloat(middle) * keyWidth + CGFloat(middle - 1) * metrics.keyGap
        let first = Span(x: metrics.sideInset, width: side)
        let last = Span(x: width - metrics.sideInset - side, width: side)
        return [first] + run(count: middle, from: (width - used) / 2, width: keyWidth, gap: metrics.keyGap) + [last]
    }

    /// The bottom row: fixed keys at both ends, the space bar takes the rest.
    private static func bottomSpans(of row: [KeyboardKey], width: CGFloat, metrics: KeyboardMetrics) -> [Span] {
        let wide = width * metrics.bottomKeyShare
        let half = (wide - metrics.keyGap) / 2
        let hasGlobe = row.contains(.globe)
        let fixed = row.map { key -> CGFloat? in
            switch key {
            case .space: nil
            case .enter: wide
            case .globe: half
            default: hasGlobe ? half : wide
            }
        }
        let taken = fixed.compactMap { $0 }.reduce(0, +)
        let space = width - 2 * metrics.sideInset - taken - CGFloat(row.count - 1) * metrics.keyGap
        var x = metrics.sideInset
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
