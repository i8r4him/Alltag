//
//  WritingCheckStream.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// Reads the `write` function's streamed correction: OpenAI's events, whose text
/// is the JSON answer growing piece by piece. Each sentence is handed on as soon
/// as its object in `"sentences"` is complete, so the learner reads the first
/// corrections while the rest are still being written.
struct WritingCheckStream {
    private var text: [UInt8] = []
    private var completed = false
    private var sentences: [WritingSentence] = []

    // Where the scan of the `"sentences"` array stands, so each piece is read only once.
    private var arrayStart: Int?
    private var position = 0
    private var depth = 0
    private var inString = false
    private var escaped = false
    private var objectStart: Int?
    private var arrayDone = false

    /// The sentences checked so far, when this line completed one; otherwise `nil`.
    mutating func receive(_ line: String) throws -> [WritingSentence]? {
        guard line.hasPrefix("data: "),
              let event = try? JSONSerialization.jsonObject(with: Data(line.dropFirst(6).utf8)) as? [String: Any],
              let type = event["type"] as? String else { return nil }
        if type == "response.failed" || type == "response.incomplete" || type == "error" { throw RealtimeServiceError.upstream }
        if type == "response.completed" { completed = true; return nil }
        guard type == "response.output_text.delta", let delta = event["delta"] as? String else { return nil }
        text += Array(delta.utf8)
        let before = sentences.count
        scan()
        return sentences.count > before ? sentences : nil
    }

    /// The whole correction, once the answer is complete.
    func finish() throws -> WritingCheck {
        guard completed else { throw RealtimeServiceError.upstream }
        let answer = try JSONDecoder().decode(ServerWritingCheck.self, from: Data(text))
        return answer.check
    }

    private mutating func scan() {
        guard !arrayDone else { return }
        if arrayStart == nil {
            guard let key = Self.find(Array("\"sentences\"".utf8), in: text),
                  let bracket = text[key...].firstIndex(of: UInt8(ascii: "[")) else { return }
            arrayStart = bracket
            position = bracket + 1
        }
        while position < text.count, !arrayDone {
            read(text[position])
            position += 1
        }
    }

    /// One character of the array: strings are skipped, and an item ends where its braces close.
    private mutating func read(_ byte: UInt8) {
        if inString {
            if escaped {
                escaped = false
            } else if byte == UInt8(ascii: "\\") {
                escaped = true
            } else if byte == UInt8(ascii: "\"") {
                inString = false
            }
            return
        }
        switch byte {
        case UInt8(ascii: "\""):
            inString = true
        case UInt8(ascii: "{"), UInt8(ascii: "["):
            if depth == 0 { objectStart = position }
            depth += 1
        case UInt8(ascii: "}"), UInt8(ascii: "]"):
            guard depth > 0 else { arrayDone = true; return }
            depth -= 1
            if depth == 0, let start = objectStart { add(text[start...position]) }
        default:
            break
        }
    }

    private mutating func add(_ bytes: ArraySlice<UInt8>) {
        guard let sentence = try? JSONDecoder().decode(ServerWritingCheck.Sentence.self, from: Data(bytes)) else { return }
        sentences.append(sentence.sentence(id: sentences.count))
    }

    private static func find(_ needle: [UInt8], in haystack: [UInt8]) -> Int? {
        guard haystack.count >= needle.count else { return nil }
        return (0...(haystack.count - needle.count)).first { haystack[$0..<($0 + needle.count)].elementsEqual(needle) }
    }
}

/// The correction as the server writes it.
struct ServerWritingCheck: Decodable {
    struct Sentence: Decodable {
        let original: String
        let kind: String
        let title: String
        let note: String
        let correction: String
        let english: String

        func sentence(id: Int) -> WritingSentence {
            let checked = SentenceFeedback(CheckedSentence(kind: kind, title: title, note: note, english: english,
                                                           correction: correction))
            return WritingSentence(id: id, original: original, feedback: checked.feedback, english: english)
        }
    }

    struct Point: Decodable {
        let covered: Bool
        let note: String
    }

    let sentences: [Sentence]
    let corrected: String
    let points: [Point]
    let summary: String

    var check: WritingCheck {
        WritingCheck(sentences: sentences.enumerated().map { $0.element.sentence(id: $0.offset) }, corrected: corrected,
                     points: points.map { .init(covered: $0.covered, note: $0.note) }, summary: summary)
    }
}
