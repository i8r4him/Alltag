//
//  EmojiCatalogTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 21.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Keyboard emoji")
@MainActor
struct EmojiCatalogTests {
    @Test("The emoji file gives every group, each emoji once")
    func catalog() {
        let sections = EmojiCatalog.sections
        #expect(sections.map(\.kind) == [.people, .nature, .food, .activity, .travel, .objects, .symbols, .flags])
        let all = sections.flatMap(\.emoji)
        #expect(all.count > 1500)
        #expect(Set(all).count == all.count)
        #expect(all.allSatisfy { $0.count == 1 }, "an entry is more than one emoji")
        #expect(sections.first?.emoji.first == "😀")
        #expect(all.contains("#️⃣"))
        #expect(all.contains("🇩🇪"))
    }

    @Test("A group starts at its @ line; a keycap # is an emoji, not a group")
    func parsing() {
        let sections = EmojiCatalog.parse("@people\n😀 😃\n😄\n@symbols\n#️⃣ ❤️\n@nothing\n🙂\n")
        #expect(sections == [EmojiSection(kind: .people, emoji: ["😀", "😃", "😄"]),
                             EmojiSection(kind: .symbols, emoji: ["#️⃣", "❤️"])])
    }

    @Test("The emoji used last come first, each once, thirty at most")
    func recents() {
        #expect(EmojiRecents.adding("🙂", to: ["😀", "🙂", "👍"]) == ["🙂", "😀", "👍"])
        let many = (0..<40).map { "\($0)" }
        let list = EmojiRecents.adding("🙂", to: many)
        #expect(list.count == EmojiRecents.limit)
        #expect(list.first == "🙂")
    }
}
