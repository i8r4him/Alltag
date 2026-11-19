//
//  WebArticles.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData

/// What the reader opens from the web: a link the learner shared or pasted, or
/// an article kept in Your sessions.
enum WebSource: Hashable, Identifiable {
    case link(URL)
    case saved(WebArticle)

    var id: String {
        switch self {
        case .link(let url): url.absoluteString
        case .saved(let article): article.url.absoluteString
        }
    }
}

/// Articles from the web are kept in Your sessions as reading sessions, so they
/// can be read again offline: the first line is the link, the rest the paragraphs.
/// No new model is needed.
enum WebArticles {
    /// The reader's text for an article: the questions are the server's, the level its judgement.
    static func text(for article: WebArticle, quiz: WebArticleQuiz?, level: Level) -> ReadingText {
        ReadingText(id: id(of: article.url), level: quiz?.difficulty ?? level, kind: .article,
                    title: "\(article.title)", detail: "\(article.site)", systemImage: "globe",
                    german: article.paragraphs.joined(separator: "\n"), questions: quiz?.questions ?? [])
    }

    static func id(of url: URL) -> String { "web-\(url.absoluteString)" }

    /// Keeps the article in Your sessions, or moves it to now when it was kept before.
    static func keep(_ article: WebArticle, in context: ModelContext, date: Date = .now) throws {
        let id = ReadingProgress.recordID(for: id(of: article.url))
        let existing = try context.fetch(FetchDescriptor<SessionRecord>(predicate: #Predicate { $0.uuid == id }))
        if let record = existing.first {
            record.date = date
        } else {
            let lines = [SessionLine(isLearner: false, german: article.url.absoluteString)]
                + article.paragraphs.map { SessionLine(isLearner: false, german: $0) }
            context.insert(SessionRecord(uuid: id, kind: .reading, title: article.title, lines: lines, date: date))
        }
        try context.save()
    }

    /// The articles kept in Your sessions, newest first.
    static func saved(in records: [SessionRecord]) -> [WebArticle] {
        records.filter { $0.kind == .reading }
            .sorted { $0.date > $1.date }
            .compactMap { record in
                let lines = record.lines
                guard let first = lines.first?.german, first.hasPrefix("http"), let url = URL(string: first),
                      record.uuid == ReadingProgress.recordID(for: id(of: url)) else { return nil }
                return WebArticle(url: url, title: record.title, paragraphs: lines.dropFirst().map(\.german))
            }
    }
}

extension WebArticles {
    /// The links shared to Alltag and not read yet, newest first. Links
    /// already kept are taken out of the inbox.
    static func shared(skipping saved: [WebArticle], in directory: URL? = nil) -> [URL] {
        let kept = Set(saved.map(\.url))
        var waiting: [URL] = []
        for entry in ReadingInbox.entries(in: directory) {
            if kept.contains(entry.url) {
                ReadingInbox.remove(entry.url, from: directory)
            } else {
                waiting.append(entry.url)
            }
        }
        return waiting
    }

    /// A name for a link before its article is loaded: its last part, with the
    /// dashes and the trailing number taken out ("mieten-steigen-100.html" → "Mieten steigen").
    static func name(of url: URL) -> String {
        let last = url.deletingPathExtension().pathComponents.last { $0 != "/" } ?? ""
        let words = last.split(whereSeparator: { $0 == "-" || $0 == "_" })
            .map(String.init)
            .filter { !$0.allSatisfy(\.isNumber) }
        guard !words.isEmpty else { return url.host() ?? url.absoluteString }
        let name = words.joined(separator: " ")
        return name.prefix(1).uppercased() + name.dropFirst()
    }
}

/// A German site with articles for a level, to start from.
struct WebReadingSite: Identifiable, Hashable {
    let name: String
    let url: URL
    let about: LocalizedStringResource
    let systemImage: String

    var id: String { url.absoluteString }

    private static let simpleNews = WebReadingSite(
        name: "nachrichtenleicht.de", url: URL(string: "https://www.nachrichtenleicht.de")!,
        about: "The week's news in easy German", systemImage: "newspaper.fill")
    private static let mdrEasy = WebReadingSite(
        name: "MDR in Leichter Sprache", url: URL(string: "https://www.mdr.de/nachrichten-leicht/index.html")!,
        about: "News in very short sentences", systemImage: "text.bubble.fill")
    private static let learnGerman = WebReadingSite(
        name: "DW Learn German", url: URL(string: "https://learngerman.dw.com/de")!,
        about: "Short articles for learners, with words explained", systemImage: "graduationcap.fill")
    private static let logo = WebReadingSite(
        name: "logo! (ZDF)", url: URL(string: "https://www.zdf.de/kinder/logo")!,
        about: "News for young people, clearly told", systemImage: "sparkles.tv.fill")
    private static let tagesschau = WebReadingSite(
        name: "tagesschau.de", url: URL(string: "https://www.tagesschau.de")!,
        about: "Germany's main news", systemImage: "tv.fill")
    private static let spiegel = WebReadingSite(
        name: "SPIEGEL", url: URL(string: "https://www.spiegel.de")!,
        about: "News and long reads", systemImage: "doc.richtext.fill")
    private static let zeit = WebReadingSite(
        name: "ZEIT ONLINE", url: URL(string: "https://www.zeit.de")!,
        about: "Essays, debate and culture", systemImage: "books.vertical.fill")
    private static let suddeutsche = WebReadingSite(
        name: "Süddeutsche Zeitung", url: URL(string: "https://www.sueddeutsche.de")!,
        about: "Politics, business and Munich", systemImage: "building.columns.fill")

    /// Where to find articles that suit the level.
    static func sites(for level: Level) -> [WebReadingSite] {
        switch level {
        case .a1: [simpleNews, mdrEasy]
        case .a2: [simpleNews, mdrEasy, learnGerman]
        case .b1: [learnGerman, logo, tagesschau]
        case .b2: [tagesschau, spiegel, learnGerman]
        case .c1, .c2: [zeit, suddeutsche, spiegel]
        }
    }
}
