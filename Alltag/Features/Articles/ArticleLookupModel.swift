//
//  ArticleLookupModel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Observation
import SwiftData
import SwiftUI

/// A word the learner looked up, with what came back, so the history can
/// show it again without asking the server.
struct ArticleLookup: Codable, Identifiable, Hashable {
    let query: String
    let nouns: [Noun]
    let note: String
    let date: Date

    var id: String { query.lowercased() }
}

/// "Look up a word": the field, what came back, what was saved, and the
/// words looked up before. Owned by the Articles screen, so the toolbar's
/// history and the toast at the bottom of the screen share it.
@Observable
final class ArticleLookupModel {
    /// Where the history is kept. A few kilobytes, so not in the database.
    static let historyKey = "articles.lookups"
    static let historyLimit = 30

    var text = ""
    var notice: ToastMessage?
    /// The word the answer belongs to.
    private(set) var query = ""
    private(set) var answer: ArticleAnswer?
    private(set) var isLookingUp = false
    /// Why the last look-up failed, until the field changes or it is tried again.
    private(set) var failure: CloudFailure?
    private(set) var saved = Set<String>()
    private(set) var history: [ArticleLookup]

    @ObservationIgnored private let defaults: UserDefaults
    @ObservationIgnored private var task: Task<Void, Never>?

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        history = (defaults.data(forKey: Self.historyKey))
            .flatMap { try? JSONDecoder().decode([ArticleLookup].self, from: $0) } ?? []
    }

    /// No noun came back for the word.
    var foundNothing: Bool { answer?.nouns.isEmpty == true }

    /// The field changed: what was shown belongs to another word now.
    func textChanged() {
        guard text.trimmingCharacters(in: .whitespacesAndNewlines) != query else { return }
        task?.cancel()
        isLookingUp = false
        answer = nil
        failure = nil
        query = ""
        saved = []
    }

    func lookUp(level: Level, with articles: any ArticleService) {
        let word = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !word.isEmpty, !isLookingUp else { return }
        query = word
        answer = nil
        failure = nil
        isLookingUp = true
        task = Task { [weak self] in
            do {
                let result = try await articles.request(word: word, level: level, excluding: [])
                guard let self, !Task.isCancelled else { return }
                answer = result
                if !result.nouns.isEmpty {
                    remember(ArticleLookup(query: word, nouns: result.nouns, note: result.note, date: .now))
                }
            } catch {
                guard let self, !Task.isCancelled else { return }
                failure = CloudFailure(error)
            }
            self?.isLookingUp = false
        }
    }

    /// Shows a word from the history again, as it was.
    func show(_ lookup: ArticleLookup) {
        task?.cancel()
        isLookingUp = false
        failure = nil
        query = lookup.query
        text = lookup.query
        answer = ArticleAnswer(nouns: lookup.nouns, note: lookup.note)
        saved = []
        remember(ArticleLookup(query: lookup.query, nouns: lookup.nouns, note: lookup.note, date: .now))
    }

    /// Saves the noun to Memory, or takes it out again when it is already there.
    func toggleSave(_ noun: Noun, in context: ModelContext) {
        let isSaved = saved.contains(noun.id)
        do {
            if isSaved {
                try ArticleMemory.remove(noun, in: context)
                saved.remove(noun.id)
                notice = ToastMessage(text: "Removed from Memory", systemImage: "bookmark.slash.fill")
            } else {
                try ArticleMemory.save(noun, in: context)
                saved.insert(noun.id)
                notice = ToastMessage(text: "Saved to Memory")
            }
        } catch {
            notice = ToastMessage(text: "Couldn’t save it. Try again.", systemImage: "exclamationmark.triangle")
        }
    }

    /// Fills in which of the answer's nouns are in Memory already, from earlier.
    func refreshSaved(in context: ModelContext) {
        saved = Set((answer?.nouns ?? []).filter { (try? ArticleMemory.isSaved($0, in: context)) == true }.map(\.id))
    }

    func removeHistory(at offsets: IndexSet) {
        history.remove(atOffsets: offsets)
        storeHistory()
    }

    func clearHistory() {
        history = []
        storeHistory()
    }

    func stop() {
        task?.cancel()
    }

    /// Newest first, each word once.
    private func remember(_ lookup: ArticleLookup) {
        history.removeAll { $0.id == lookup.id }
        history.insert(lookup, at: 0)
        history = Array(history.prefix(Self.historyLimit))
        storeHistory()
    }

    private func storeHistory() {
        defaults.set(try? JSONEncoder().encode(history), forKey: Self.historyKey)
    }
}
