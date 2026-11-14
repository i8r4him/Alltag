//
//  TranslationPanelModel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import Foundation
import NaturalLanguage
import Observation

@MainActor
@Observable
final class TranslationPanelModel {
    typealias Stream = ([String: String], (String) throws -> Void) async throws -> Void
    private let stream: Stream
    private var requestID = UUID()

    init(stream: @escaping Stream = { try await SupabaseRealtimeClient.shared.stream(to: "translate", body: $0, onLine: $1) }) {
        self.stream = stream
    }

    var result: TranslationResult?
    var isLoading = false
    var failed = false
    var sourceIsGerman = false

    func translate(_ source: String) async {
        let id = UUID()
        requestID = id
        sourceIsGerman = false
        isLoading = false
        result = nil
        failed = false
        guard !source.isEmpty else { return }
        isLoading = true
        defer { if requestID == id { isLoading = false } }
        var parser = TranslationStream()
        let language = Locale.current.language.languageCode?.identifier ?? "en"
        let name = Locale(identifier: "en").localizedString(forLanguageCode: language) ?? "English"
        do {
            try await stream([
                "text": source, "language": language == "de" ? "English" : name, "stream": "true"
            ]) { line in
                guard !Task.isCancelled, self.requestID == id else { return }
                if let partial = try parser.receive(line) { self.result = partial }
                if let german = parser.sourceIsGerman { self.sourceIsGerman = german }
            }
            guard !Task.isCancelled, requestID == id else { return }
            result = try parser.finish()
        } catch {
            guard !Task.isCancelled, requestID == id else { return }
            failed = true
        }
    }

    var translation: String? { sourceIsGerman ? result?.english : result?.german }
}

/// A translation arranged for reading, from its line breaks and length alone:
/// a short first line becomes a heading, the short lines after it (place, pay,
/// hours) a list of facts, and the rest paragraphs. A short phrase stays one
/// block, shown large. Here, beside the panel's model, so the extension and
/// the tests both see it.
struct TranslationLayout: Equatable {
    enum Block: Equatable {
        case heading(String)
        case facts([String])
        case paragraph(String)
    }

    let blocks: [Block]
    /// Long text is set in body size and arranged; short text keeps the big style.
    let isLong: Bool

    init(_ text: String) {
        let lines = text.split(whereSeparator: \.isNewline)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        isLong = text.count > Self.longLength || lines.count > 2
        blocks = isLong ? Self.blocks(from: lines) : [.paragraph(text)]
    }

    private static let longLength = 140
    private static let bullets = ["• ", "- ", "– ", "* ", "· "]
    private static let separators = [" | ", " · ", " • "]

    private static func blocks(from lines: [String]) -> [Block] {
        var blocks: [Block] = []
        var facts: [String] = []
        var hasParagraph = false
        for (index, line) in lines.enumerated() {
            if index == 0, lines.count > 1, isShort(line, limit: 80) {
                blocks.append(.heading(line))
                continue
            }
            let bullet = bullets.first(where: line.hasPrefix)
            let content = bullet.map { String(line.dropFirst($0.count)) } ?? line
            // Short lines are facts only before the text proper begins; bulleted lines anywhere.
            if bullet != nil || (!hasParagraph && isShort(content, limit: 70)) {
                facts += separators.reduce([content]) { parts, separator in
                    parts.flatMap { $0.components(separatedBy: separator) }
                }
                continue
            }
            if !facts.isEmpty {
                blocks.append(.facts(facts))
                facts = []
            }
            blocks += paragraphs(in: content).map(Block.paragraph)
            hasParagraph = true
        }
        if !facts.isEmpty { blocks.append(.facts(facts)) }
        return blocks
    }

    /// A title or a fact: short, and not a sentence.
    private static func isShort(_ line: String, limit: Int) -> Bool {
        line.count <= limit && !(line.last.map { ".!?".contains($0) } ?? false)
    }

    /// A long block without line breaks is broken up after every few sentences.
    private static func paragraphs(in text: String) -> [String] {
        guard text.count > 280 else { return [text] }
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text
        var paragraphs: [String] = []
        var current = ""
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            let sentence = text[range].trimmingCharacters(in: .whitespaces)
            if !current.isEmpty, current.count + sentence.count > 220 {
                paragraphs.append(current)
                current = ""
            }
            current += current.isEmpty ? sentence : " " + sentence
            return true
        }
        if !current.isEmpty { paragraphs.append(current) }
        return paragraphs.isEmpty ? [text] : paragraphs
    }
}
