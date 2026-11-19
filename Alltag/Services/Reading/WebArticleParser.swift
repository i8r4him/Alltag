//
//  WebArticleParser.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import NaturalLanguage

/// An article from the web, as the reader shows it: its title and its paragraphs.
nonisolated struct WebArticle: Hashable, Sendable {
    let url: URL
    let title: String
    let paragraphs: [String]

    /// "tagesschau.de": where it comes from, without "www.".
    var site: String {
        let host = url.host() ?? url.absoluteString
        return host.hasPrefix("www.") ? String(host.dropFirst(4)) : host
    }

    var isGerman: Bool {
        NLLanguageRecognizer.dominantLanguage(for: paragraphs.prefix(6).joined(separator: " ")) == .german
    }
}

/// Finds the readable part of a web page: the title, and the paragraphs of the
/// article without menus, scripts, captions or the footer. Pure, so it can be tested.
nonisolated enum WebArticleParser {
    /// Paragraphs shorter than this are teasers, credits or buttons.
    static let minimumWords = 8
    /// Enough for a long article; the reader and the questions don't need more.
    static let maximumParagraphs = 40

    static func article(from html: String, url: URL) -> WebArticle {
        WebArticle(url: url, title: title(in: html) ?? url.host() ?? "", paragraphs: paragraphs(in: html))
    }

    static func title(in html: String) -> String? {
        let patterns = [
            #"<meta[^>]+property=["']og:title["'][^>]+content=["']([^"']+)["']"#,
            #"<meta[^>]+content=["']([^"']+)["'][^>]+property=["']og:title["']"#,
            #"<h1[^>]*>(.*?)</h1>"#,
            #"<title[^>]*>(.*?)</title>"#
        ]
        for pattern in patterns {
            if let match = firstMatch(of: pattern, in: html) {
                let title = plainText(match)
                if !title.isEmpty { return title }
            }
        }
        return nil
    }

    static func paragraphs(in html: String) -> [String] {
        var page = html
        // The article itself, when the page marks it.
        if let start = page.range(of: "<article", options: .caseInsensitive),
           let end = page.range(of: "</article>", options: [.caseInsensitive, .backwards]),
           start.lowerBound < end.lowerBound {
            page = String(page[start.lowerBound..<end.upperBound])
        }
        for tag in ["script", "style", "noscript", "nav", "footer", "aside", "figure", "form", "button"] {
            page = replacing(#"<\#(tag)\b[^>]*>.*?</\#(tag)>"#, in: page, with: " ")
        }
        var seen = Set<String>()
        var result: [String] = []
        for match in allMatches(of: #"<p\b[^>]*>(.*?)</p>"#, in: page) {
            let paragraph = plainText(match)
            let words = paragraph.split(whereSeparator: \.isWhitespace).count
            guard words >= minimumWords, seen.insert(paragraph).inserted else { continue }
            result.append(paragraph)
            if result.count == maximumParagraphs { break }
        }
        return result
    }

    /// Tags out, entities decoded, white space collapsed.
    static func plainText(_ html: String) -> String {
        let text = decodeEntities(replacing(#"<[^>]+>"#, in: html, with: " "))
        return text.split(whereSeparator: \.isWhitespace).joined(separator: " ")
            .replacingOccurrences(of: " ,", with: ",")
            .replacingOccurrences(of: " .", with: ".")
    }

    private static let entities: [String: String] = [
        "amp": "&", "lt": "<", "gt": ">", "quot": "\"", "apos": "'", "nbsp": " ", "shy": "",
        "ndash": "–", "mdash": "—", "hellip": "…", "euro": "€",
        "bdquo": "„", "ldquo": "“", "rdquo": "”", "sbquo": "‚", "lsquo": "‘", "rsquo": "’",
        "laquo": "«", "raquo": "»",
        "auml": "ä", "ouml": "ö", "uuml": "ü", "Auml": "Ä", "Ouml": "Ö", "Uuml": "Ü", "szlig": "ß",
        "eacute": "é", "egrave": "è", "agrave": "à"
    ]

    static func decodeEntities(_ text: String) -> String {
        guard text.contains("&") else { return text }
        let regex = try? NSRegularExpression(pattern: #"&(#x[0-9a-fA-F]+|#[0-9]+|[a-zA-Z]+);"#)
        let source = text as NSString
        var result = ""
        var last = 0
        for match in regex?.matches(in: text, range: NSRange(location: 0, length: source.length)) ?? [] {
            result += source.substring(with: NSRange(location: last, length: match.range.location - last))
            let name = source.substring(with: match.range(at: 1))
            result += decode(name) ?? source.substring(with: match.range)
            last = match.range.location + match.range.length
        }
        return result + source.substring(from: last)
    }

    private static func decode(_ name: String) -> String? {
        if name.hasPrefix("#x") || name.hasPrefix("#X") {
            return UInt32(name.dropFirst(2), radix: 16).flatMap(Unicode.Scalar.init).map { String(Character($0)) }
        }
        if name.hasPrefix("#") {
            return UInt32(name.dropFirst()).flatMap(Unicode.Scalar.init).map { String(Character($0)) }
        }
        return entities[name]
    }

    private static func firstMatch(of pattern: String, in text: String) -> String? {
        allMatches(of: pattern, in: text).first
    }

    /// The first group of every match, case-insensitive, across lines.
    private static func allMatches(of pattern: String, in text: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive, .dotMatchesLineSeparators])
        else { return [] }
        let source = text as NSString
        return regex.matches(in: text, range: NSRange(location: 0, length: source.length)).map {
            source.substring(with: $0.range(at: 1))
        }
    }

    private static func replacing(_ pattern: String, in text: String, with replacement: String) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive, .dotMatchesLineSeparators])
        else { return text }
        return regex.stringByReplacingMatches(in: text, range: NSRange(location: 0, length: (text as NSString).length),
                                              withTemplate: replacement)
    }
}
