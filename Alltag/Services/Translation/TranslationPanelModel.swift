//
//  TranslationPanelModel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import Foundation
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
