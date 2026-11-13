//
//  ArticleGameCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftData
import SwiftUI

struct ArticleGameCard: View {
    let level: Level
    @Environment(\.services) private var services
    @Environment(\.modelContext) private var context
    @State private var trainer: ArticleTrainer?
    @State private var busy = false
    @State private var failed = false
    @State private var saveFailed = false
    @State private var task: Task<Void, Never>?

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let trainer, let noun = trainer.current {
                ProgressView(value: trainer.progress)
                if trainer.picked == nil {
                    Text(verbatim: noun.word).font(.largeTitle.bold())
                    Text(verbatim: noun.meaning).foregroundStyle(.secondary)
                } else {
                    ArticleNounDetail(noun: noun)
                    if trainer.isRight == false && !saveFailed {
                        Label("Added to Fix your mistakes", systemImage: "bookmark.fill")
                            .font(.subheadline).foregroundStyle(.mistake)
                    }
                }
                if saveFailed {
                    Button("Couldn’t save the mistake. Try again.") {
                        if let picked = trainer.picked { saveMistake(noun, picked: picked) }
                    }.buttonStyle(.glass)
                }
                HStack(spacing: 12) {
                    ForEach(Article.allCases) { article in
                        Button { pick(article, trainer: trainer, noun: noun) } label: {
                            Text(verbatim: article.rawValue).font(.title2.bold()).frame(maxWidth: .infinity, minHeight: 52)
                        }
                        .buttonStyle(.glass)
                        .tint(trainer.picked == nil ? Color.accent : article == noun.article ? .success : .mistake)
                        .disabled(trainer.picked != nil)
                    }
                }
                Button("Next") {
                    trainer.next()
                    if trainer.isDone { trainer.recordPractice(in: context) }
                }.buttonStyle(.primary).disabled(trainer.picked == nil || saveFailed)
            } else {
                Text(trainer == nil ? "Play with articles" : "Round complete")
                    .font(.title2.bold())
                if let trainer {
                    Text("\(trainer.rightFirstTime) of \(trainer.total) right first time")
                    Text("Your mistakes are ready to practise on Learn.").foregroundStyle(.secondary)
                } else {
                    Text("OpenAI picks a fresh round of nouns for your level. Wrong articles go straight to Fix your mistakes.")
                        .foregroundStyle(.secondary)
                }
                Button(trainer == nil ? "Start a round" : "Another round", systemImage: "play.fill", action: start)
                    .buttonStyle(.primary).disabled(busy)
            }
            if busy { ProgressView("Preparing nouns for your level…") }
            if failed {
                Text("Couldn’t prepare a round. Check your connection and cloud setting, then try again.").foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero))
        .onDisappear { task?.cancel(); busy = false }
    }

    private func start() {
        guard !busy else { return }
        busy = true
        failed = false
        task = Task {
            do {
                let recent = UserDefaults.standard.stringArray(forKey: "articles.recent") ?? []
                let answer = try await services.articles.request(word: nil, level: level, excluding: recent)
                guard !Task.isCancelled else { return }
                var generator = SystemRandomNumberGenerator()
                trainer = ArticleTrainer(nouns: answer.nouns, using: &generator)
                UserDefaults.standard.set(Array((recent + answer.nouns.map(\.word)).suffix(60)), forKey: "articles.recent")
            } catch { if !Task.isCancelled { failed = true } }
            if !Task.isCancelled { busy = false }
        }
    }

    private func saveMistake(_ noun: Noun, picked: Article) {
        do {
            try ArticleMemory.mistake(noun, picked: picked, in: context)
            saveFailed = false
        } catch { saveFailed = true }
    }

    private func pick(_ article: Article, trainer: ArticleTrainer, noun: Noun) {
        guard trainer.picked == nil else { return }
        trainer.pick(article)
        saveMistake(noun, picked: article)
    }
}
