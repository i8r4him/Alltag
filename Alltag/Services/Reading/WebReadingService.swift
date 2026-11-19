//
//  WebReadingService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// Why an article can't be read in the app.
enum WebReadingError: Error, Equatable {
    /// The page couldn't be loaded.
    case unreachable
    /// The page has no article text the app can find (a video, a paywall, a start page).
    case noArticle
    /// The article isn't in German.
    case notGerman
}

/// Three questions about an article and what the server thinks of it.
struct WebArticleQuiz: Sendable {
    let questions: [ReadingQuestion]
    /// How hard the article's German is, as the server judges it.
    let difficulty: Level?
    /// What it is about, in one English sentence.
    let gist: String
}

/// Reads articles from the web for Learn › Read: loads a page and asks for questions about it.
protocol WebReadingService {
    func article(at url: URL) async throws -> WebArticle
    func questions(about article: WebArticle, level: Level) async throws -> WebArticleQuiz
}

/// Loads the page itself and asks the `write` Edge Function for the questions.
/// The questions need the learner's permission for cloud use, like Write.
struct CloudWebReadingService: WebReadingService {
    typealias Load = (URL) async throws -> (Data, URLResponse)
    typealias Send = ([String: String]) async throws -> Data

    var load: Load = { url in
        var request = URLRequest(url: url, timeoutInterval: 20)
        // Some sites only send the article to a browser.
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 27_0 like Mac OS X) AppleWebKit/605.1.15 Mobile/15E148",
                         forHTTPHeaderField: "User-Agent")
        request.setValue("de-DE,de;q=0.9", forHTTPHeaderField: "Accept-Language")
        return try await URLSession.shared.data(for: request)
    }
    var send: Send = { try await SupabaseRealtimeClient.shared.post(to: "write", body: $0) }
    var allowed: () -> Bool = { UserDefaults.standard.bool(forKey: "usesCloudForPro") }

    func article(at url: URL) async throws -> WebArticle {
        guard url.scheme == "https" || url.scheme == "http" else { throw WebReadingError.unreachable }
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await load(url)
        } catch {
            throw WebReadingError.unreachable
        }
        if let status = (response as? HTTPURLResponse)?.statusCode, !(200..<300).contains(status) {
            throw WebReadingError.unreachable
        }
        let html = String(data: data, encoding: .utf8) ?? String(data: data, encoding: .isoLatin1) ?? ""
        let article = await Self.parse(html, url: response.url ?? url)
        guard article.paragraphs.count >= 2 else { throw WebReadingError.noArticle }
        guard article.isGerman else { throw WebReadingError.notGerman }
        return article
    }

    /// Off the main actor: a big page takes a moment to search.
    @concurrent
    nonisolated private static func parse(_ html: String, url: URL) async -> WebArticle {
        WebArticleParser.article(from: html, url: url)
    }

    func questions(about article: WebArticle, level: Level) async throws -> WebArticleQuiz {
        guard allowed() else { throw RealtimeServiceError.unavailable }
        let body = ["action": "questions", "level": level.rawValue, "title": article.title,
                    "text": article.paragraphs.joined(separator: "\n\n")]
        return try JSONDecoder().decode(ServerReadingQuestions.self, from: await send(body)).quiz(for: article)
    }
}

/// The questions as the server writes them.
struct ServerReadingQuestions: Decodable {
    struct Question: Decodable {
        let prompt: String
        let options: [String]
        let answer: Int
        let evidence: String
    }

    let questions: [Question]
    let difficulty: String?
    let gist: String?

    /// Only questions the reader can use: three options, a right one among them, and
    /// evidence that really is in the article (otherwise nothing lights up).
    func quiz(for article: WebArticle) throws -> WebArticleQuiz {
        let usable = questions.filter { question in
            question.options.count == 3 && question.options.indices.contains(question.answer)
        }
        guard !usable.isEmpty else { throw RealtimeServiceError.unexpectedResponse }
        let text = article.paragraphs.joined(separator: "\n")
        return WebArticleQuiz(
            questions: usable.map {
                ReadingQuestion(prompt: $0.prompt, options: $0.options, answer: $0.answer,
                                evidence: text.contains($0.evidence) ? $0.evidence : "")
            },
            difficulty: difficulty.flatMap { Level(rawValue: $0) },
            gist: gist ?? "")
    }
}

/// A short German article, for previews and tests.
struct MockWebReadingService: WebReadingService {
    func article(at url: URL) async throws -> WebArticle {
        WebArticle(url: url, title: "Mehr Radwege in der Stadt", paragraphs: [
            "Die Stadt baut in diesem Jahr zwölf Kilometer neue Radwege. Die meisten liegen in der Innenstadt.",
            "Viele Menschen fahren seit dem Frühling mit dem Fahrrad zur Arbeit. Deshalb sind die alten Wege oft zu voll.",
            "Die Bauarbeiten beginnen im März und dauern bis zum Herbst. In dieser Zeit gibt es Umleitungen."
        ])
    }

    func questions(about article: WebArticle, level: Level) async throws -> WebArticleQuiz {
        WebArticleQuiz(questions: [
            ReadingQuestion(prompt: "How many kilometres of new cycle paths are built?",
                            options: ["Two", "Twelve", "Twenty"], answer: 1,
                            evidence: "Die Stadt baut in diesem Jahr zwölf Kilometer neue Radwege."),
            ReadingQuestion(prompt: "Why are the old paths often full?",
                            options: ["More people cycle to work", "They are narrow", "There are works"], answer: 0,
                            evidence: "Deshalb sind die alten Wege oft zu voll."),
            ReadingQuestion(prompt: "When do the works end?",
                            options: ["In March", "In spring", "In autumn"], answer: 2,
                            evidence: "Die Bauarbeiten beginnen im März und dauern bis zum Herbst.")
        ], difficulty: .a2, gist: "The city builds new cycle paths.")
    }
}
