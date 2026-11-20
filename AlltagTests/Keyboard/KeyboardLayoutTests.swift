//
//  KeyboardLayoutTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import CoreGraphics
import Foundation
import Testing
@testable import Alltag

@Suite("Keyboard layout and key frames")
@MainActor
struct KeyboardLayoutTests {
    let size = CGSize(width: 393, height: 260)

    func makeGeometry(_ page: KeyboardPage = .letters, showsGlobe: Bool = false) -> KeyboardGeometry {
        KeyboardGeometry(rows: KeyboardLayout.allRows(for: page, showsGlobe: showsGlobe), size: size)
    }

    @Test("The letters are QWERTZ with the umlauts, under a numbers row")
    func letters() {
        let rows = KeyboardLayout.allRows(for: .letters, showsGlobe: false)
        #expect(rows.count == 5)
        #expect(rows[0].compactMap(\.text).joined() == "1234567890")
        #expect(rows[1].compactMap(\.text).joined() == "qwertzuiopü")
        #expect(rows[2].compactMap(\.text).joined() == "asdfghjklöä")
        #expect(rows[3].first == .shift)
        #expect(rows[3].compactMap(\.text).joined() == "yxcvbnm")
        #expect(rows[3].last == .delete)
        #expect(rows[4] == [.page(.symbols), .space, .enter])
    }

    @Test("The globe key is only there when iOS asks for it")
    func globe() {
        #expect(KeyboardLayout.rows(for: .letters, showsGlobe: true).last == [.page(.symbols), .globe, .space, .enter])
        #expect(KeyboardLayout.rows(for: .symbols, showsGlobe: false).last == [.page(.letters), .space, .enter])
    }

    @Test("No key appears twice on a page", arguments: KeyboardPage.allCases)
    func uniqueKeys(page: KeyboardPage) {
        let keys = KeyboardLayout.allRows(for: page, showsGlobe: true).flatMap { $0 }
        #expect(Set(keys).count == keys.count)
    }

    @Test("A long press on s offers ß first")
    func alternates() {
        #expect(KeyboardLayout.alternates(for: "s").first == "ß")
        #expect(KeyboardLayout.alternates(for: "q").isEmpty)
    }

    @Test("Every key has a frame inside the keyboard, and no two overlap", arguments: KeyboardPage.allCases)
    func frames(page: KeyboardPage) {
        let geometry = makeGeometry(page, showsGlobe: true)
        let keys = KeyboardLayout.allRows(for: page, showsGlobe: true).flatMap { $0 }
        #expect(geometry.frames.map(\.key) == keys)
        let bounds = CGRect(origin: .zero, size: size)
        for frame in geometry.frames {
            #expect(bounds.contains(frame.frame), "\(frame.key) leaves the keyboard")
            #expect(frame.frame.width > 20 && frame.frame.height > 20, "\(frame.key) is too small")
        }
        for (index, first) in geometry.frames.enumerated() {
            for second in geometry.frames.dropFirst(index + 1) {
                #expect(!first.frame.intersects(second.frame), "\(first.key) overlaps \(second.key)")
            }
        }
    }

    @Test("The letters of the third row are as wide as the rows above, and the space bar is the widest key")
    func widths() throws {
        let geometry = makeGeometry()
        let upper = try #require(geometry.frame(of: .character("q"))).frame
        let lower = try #require(geometry.frame(of: .character("y"))).frame
        #expect(abs(upper.width - lower.width) < 0.01)
        let space = try #require(geometry.frame(of: .space)).frame
        #expect(geometry.frames.allSatisfy { $0.frame.width <= space.width })
        let numbers = try #require(geometry.frame(of: .character("1"))).frame
        #expect(numbers.height < upper.height)
    }

    @Test("A touch in a gap or at the edge means the nearest key")
    func touches() throws {
        let geometry = makeGeometry()
        let keyQ = try #require(geometry.frame(of: .character("q"))).frame
        let keyA = try #require(geometry.frame(of: .character("a"))).frame
        let keyY = try #require(geometry.frame(of: .character("y"))).frame
        #expect(geometry.key(at: CGPoint(x: keyQ.midX, y: keyQ.midY))?.key == .character("q"))
        #expect(geometry.key(at: CGPoint(x: keyQ.maxX + 1, y: keyQ.midY))?.key == .character("q"))
        #expect(geometry.key(at: CGPoint(x: keyQ.maxX + 5, y: keyQ.midY))?.key == .character("w"))
        #expect(geometry.key(at: CGPoint(x: keyQ.midX, y: keyQ.maxY + 2))?.key == .character("q"))
        #expect(geometry.key(at: CGPoint(x: 0, y: keyA.midY))?.key == .character("a"))
        #expect(geometry.key(at: CGPoint(x: 0, y: keyY.midY))?.key == .shift)
        #expect(geometry.key(at: CGPoint(x: keyY.minX - 3, y: keyY.midY))?.key == .character("y"))
        #expect(geometry.key(at: CGPoint(x: 100, y: 0))?.row == 0)
        #expect(geometry.key(at: CGPoint(x: size.width, y: size.height))?.key == .enter)
    }

    @Test("An empty size gives no frames")
    func empty() {
        let geometry = KeyboardGeometry(rows: KeyboardLayout.allRows(for: .letters, showsGlobe: false), size: .zero)
        #expect(geometry.frames.isEmpty)
        #expect(geometry.key(at: .zero) == nil)
    }
}
