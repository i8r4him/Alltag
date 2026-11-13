//
//  ArticleLookupCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftData
import SwiftUI

struct ArticleLookupCard: View {
    let level: Level
    @Environment(\.services) private var services
    @Environment(\.modelContext) private var context
    @State private var text = ""
    @State private var answer: ArticleAnswer?
    @State private var busy = false
    @State private var failed = false
    @State private var saved = Set<String>()
    @State private var task: Task<Void, Never>?

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            TextField("Type a noun or its meaning", text: $text)
                .font(.title3).submitLabel(.search).onSubmit(lookup)
                .padding(Spacing.card)
                .glassEffect(.regular, in: .capsule)
            Button("Find its article", systemImage: "magnifyingglass", action: lookup)
                .buttonStyle(.primary).disabled(busy || text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            if busy { ProgressView("Looking up the noun…") }
            if failed {
                Text("Couldn’t look up this word. Check your connection and cloud setting, then try again.")
                    .foregroundStyle(.secondary)
            }
            if let answer {
                if !answer.note.isEmpty { Text(verbatim: answer.note).foregroundStyle(.secondary) }
                ForEach(answer.nouns) { noun in
                    VStack(alignment: .leading, spacing: 12) {
                        ArticleNounDetail(noun: noun)
                        Button(saved.contains(noun.id) ? "Saved" : "Save to Memory", systemImage: "bookmark") { save(noun) }
                            .buttonStyle(.glass).disabled(saved.contains(noun.id))
                    }
                    .padding(Spacing.cardLarge)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero))
                }
            }
        }
        .onChange(of: text) { _, _ in task?.cancel(); answer = nil; failed = false; busy = false; saved = [] }
        .onDisappear { task?.cancel(); busy = false }
    }

    private func lookup() {
        let word = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !word.isEmpty, !busy else { return }
        busy = true
        failed = false
        task = Task {
            do {
                let result = try await services.articles.request(word: word, level: level, excluding: [])
                guard !Task.isCancelled else { return }
                answer = result
            } catch { if !Task.isCancelled { failed = true } }
            if !Task.isCancelled { busy = false }
        }
    }

    private func save(_ noun: Noun) {
        do {
            try ArticleMemory.save(noun, in: context)
            saved.insert(noun.id)
        } catch { failed = true }
    }
}

struct ArticleNounDetail: View {
    let noun: Noun
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(verbatim: "\(noun.article.rawValue) \(noun.word)").font(.title2.bold()).foregroundStyle(.accent)
            Text(verbatim: noun.meaning)
            if noun.hasPlural { Text("Plural: die \(noun.plural)").font(.subheadline).foregroundStyle(.secondary) }
            if !noun.explanation.isEmpty { Text(verbatim: noun.explanation).foregroundStyle(.secondary) }
            if !noun.example.isEmpty { Text(verbatim: noun.example).italic() }
        }
    }
}
