//
//  ReadingInboxTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

/// Links shared from the share sheet wait in a folder until Read opens them.
@MainActor
struct ReadingInboxTests {
    private let link = URL(string: "https://www.tagesschau.de/inland/mieten-steigen-100.html")!

    private func folder() throws -> URL {
        let folder = FileManager.default.temporaryDirectory.appending(path: "ReadingInbox-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        return folder
    }

    @Test("A link shared twice waits once, and is gone once read")
    func savesOnceAndRemoves() throws {
        let folder = try folder()
        defer { try? FileManager.default.removeItem(at: folder) }
        let other = URL(string: "https://www.nachrichtenleicht.de/wetter.html")!
        try ReadingInbox.save(link, to: folder)
        try ReadingInbox.save(other, to: folder)
        try ReadingInbox.save(link, to: folder)
        #expect(ReadingInbox.entries(in: folder).map(\.url) == [link, other])
        ReadingInbox.remove(link, from: folder)
        #expect(ReadingInbox.entries(in: folder).map(\.url) == [other])
    }

    @Test("A shared link already kept in Your sessions isn't shown again")
    func skipsKeptArticles() throws {
        let folder = try folder()
        defer { try? FileManager.default.removeItem(at: folder) }
        let other = URL(string: "https://www.nachrichtenleicht.de/wetter.html")!
        try ReadingInbox.save(link, to: folder)
        try ReadingInbox.save(other, to: folder)
        let kept = WebArticle(url: link, title: "Mieten steigen", paragraphs: ["Die Mieten steigen weiter."])
        #expect(WebArticles.shared(skipping: [kept], in: folder) == [other])
        #expect(ReadingInbox.entries(in: folder).map(\.url) == [other])
    }

    @Test("A link gets a name from its last part")
    func namesLinks() {
        #expect(WebArticles.name(of: link) == "Mieten steigen")
        #expect(WebArticles.name(of: URL(string: "https://www.zeit.de/")!) == "www.zeit.de")
    }
}
