//
//  ArticleService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import Foundation

protocol ArticleService {
    func request(word: String?, level: Level, excluding: [String]) async throws -> ArticleAnswer
}

struct ArticleAnswer: Decodable {
    let nouns: [Noun]
    let note: String
}

struct CloudArticleService: ArticleService {
    typealias Send = ([String: String]) async throws -> Data
    var send: Send = { try await SupabaseRealtimeClient.shared.post(to: "articles", body: $0) }
    var allowed: () -> Bool = { UserDefaults.standard.bool(forKey: "usesCloudForPro") }

    func request(word: String?, level: Level, excluding: [String]) async throws -> ArticleAnswer {
        guard allowed() else { throw RealtimeServiceError.unavailable }
        let body = ["action": word == nil ? "practice" : "lookup", "text": word ?? "",
                    "level": level.rawValue.uppercased(), "language": "English", "exclude": excluding.suffix(60).joined(separator: ", ")]
        let answer = try JSONDecoder().decode(ArticleAnswer.self, from: await send(body))
        guard answer.nouns.allSatisfy({ !$0.word.isEmpty && !$0.meaning.isEmpty }),
              Set(answer.nouns.map(\.id)).count == answer.nouns.count,
              word != nil || answer.nouns.count >= 3 else { throw RealtimeServiceError.unexpectedResponse }
        return answer
    }
}

struct UnavailableArticleService: ArticleService {
    func request(word: String?, level: Level, excluding: [String]) async throws -> ArticleAnswer {
        throw RealtimeServiceError.unavailable
    }
}
