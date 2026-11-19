//
//  WebReadingTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

/// Reading articles from the web: finding the article in a page, the server's
/// questions, and keeping articles in Your sessions. No network.
@MainActor
struct WebReadingTests {
    private let url = URL(string: "https://www.example.de/stadt/radwege-123.html")!

    private let page = """
    <html><head><title>Startseite</title>
    <meta property="og:title" content="Mehr Radwege f&uuml;r die Stadt">
    <script>var x = "<p>Kein Text aus einem Skript, auch wenn er lang genug wäre.</p>";</script></head>
    <body><nav><p>Menü Politik Wirtschaft Sport Kultur Wetter Panorama Wissen</p></nav>
    <article>
      <p class="intro">Die Stadt baut in diesem Jahr <b>zwölf Kilometer</b> neue Radwege in der Innenstadt.</p>
      <figure><p>Foto: Ein Radweg im Sommer, aufgenommen von einer Fotografin der Stadt.</p></figure>
      <p>Mehr lesen</p>
      <p>Viele Menschen fahren seit dem Frühling mit dem Rad zur Arbeit &ndash; die alten Wege sind oft voll.</p>
      <p>Viele Menschen fahren seit dem Frühling mit dem Rad zur Arbeit &ndash; die alten Wege sind oft voll.</p>
    </article>
    <footer><p>Impressum Datenschutz Kontakt und alle anderen Links dieser Seite hier unten.</p></footer>
    </body></html>
    """

    private static func okay(_ url: URL) throws -> HTTPURLResponse {
        guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else {
            throw URLError(.badServerResponse)
        }
        return response
    }

    @Test("The parser keeps the article's paragraphs and drops menus, scripts, captions and repeats")
    func parsing() {
        let article = WebArticleParser.article(from: page, url: url)
        #expect(article.title == "Mehr Radwege für die Stadt")
        #expect(article.paragraphs == [
            "Die Stadt baut in diesem Jahr zwölf Kilometer neue Radwege in der Innenstadt.",
            "Viele Menschen fahren seit dem Frühling mit dem Rad zur Arbeit – die alten Wege sind oft voll."
        ])
        #expect(article.site == "example.de")
        #expect(article.isGerman)
    }

    @Test("Entities are decoded, by name and by number")
    func entities() {
        #expect(WebArticleParser.decodeEntities("&bdquo;Gr&uuml;&szlig;e&ldquo; &#8364; &#x20AC; &unknown;")
            == "„Grüße“ € € &unknown;")
    }

    @Test("A page without an article, or not in German, isn't read")
    func refusals() async throws {
        let empty = CloudWebReadingService(load: { url in
            (Data("<html><body><p>Kurz.</p></body></html>".utf8), try Self.okay(url))
        }, send: { _ in Data() }, allowed: { true })
        await #expect(throws: WebReadingError.noArticle) { try await empty.article(at: url) }

        let english = "<p>This is a long enough paragraph written in English about the weather today.</p>"
        let foreign = CloudWebReadingService(load: { url in
            (Data((english + english.replacingOccurrences(of: "weather", with: "traffic")).utf8), try Self.okay(url))
        }, send: { _ in Data() }, allowed: { true })
        await #expect(throws: WebReadingError.notGerman) { try await foreign.article(at: url) }
    }

    @Test("The server's questions are used; evidence not in the article lights nothing")
    func questions() async throws {
        let article = WebArticleParser.article(from: page, url: url)
        let answer = """
        {"questions": [
          {"prompt": "How much?", "options": ["2 km", "12 km", "20 km"], "answer": 1,
           "evidence": "Die Stadt baut in diesem Jahr zwölf Kilometer neue Radwege in der Innenstadt."},
          {"prompt": "Why?", "options": ["Rain", "More cyclists", "Money"], "answer": 1, "evidence": "Erfunden."},
          {"prompt": "Broken", "options": ["Only one"], "answer": 0, "evidence": ""}
        ], "difficulty": "B1", "gist": "Cycle paths."}
        """
        var sent: [String: String] = [:]
        let service = CloudWebReadingService(load: { _ in throw URLError(.notConnectedToInternet) },
                                             send: { body in sent = body; return Data(answer.utf8) },
                                             allowed: { true })
        let quiz = try await service.questions(about: article, level: .a2)
        #expect(sent["action"] == "questions")
        #expect(sent["level"] == "A2")
        #expect(quiz.questions.count == 2)
        #expect(quiz.questions[0].evidence.hasPrefix("Die Stadt baut"))
        #expect(quiz.questions[1].evidence.isEmpty)
        #expect(quiz.difficulty == .b1)
        let text = WebArticles.text(for: article, quiz: quiz, level: .a2)
        #expect(text.level == .b1)
        #expect(text.questions.count == 2)
    }

    @Test("Without cloud use there are no questions")
    func notAllowed() async {
        let service = CloudWebReadingService(send: { _ in Data() }, allowed: { false })
        await #expect(throws: RealtimeServiceError.unavailable) {
            try await service.questions(about: WebArticleParser.article(from: page, url: url), level: .b1)
        }
    }

    @Test("An article is kept in Your sessions once and comes back from there")
    func keeping() throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        let context = container.mainContext
        let article = WebArticleParser.article(from: page, url: url)
        try WebArticles.keep(article, in: context)
        try WebArticles.keep(article, in: context)
        let records = try context.fetch(FetchDescriptor<SessionRecord>())
        #expect(records.count == 1)
        #expect(WebArticles.saved(in: records) == [article])
        #expect(ReadingProgress.readIDs(in: records).isEmpty)
    }
}
