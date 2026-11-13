//
//  ArticleRoundModel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import Foundation
import Observation
import SwiftData

/// One round of the der, die, das trainer, from asking the server for the
/// nouns to the summary: the screen only shows what is here.
@Observable
final class ArticleRoundModel {
    enum Phase: Equatable {
        /// The nouns for the learner's level are on their way.
        case loading
        /// They didn't arrive.
        case failed
        case playing
        case done
    }

    /// Where the words of the last rounds are kept, so a round brings new ones.
    static let recentKey = "articles.recent"

    let level: Level
    private(set) var phase: Phase = .loading
    private(set) var trainer: ArticleTrainer?
    /// Whether the last wrong answer could not be kept for Fix your mistakes.
    private(set) var saveFailed = false

    @ObservationIgnored private let articles: any ArticleService
    @ObservationIgnored private let defaults: UserDefaults
    @ObservationIgnored private var loadTask: Task<Void, Never>?

    init(services: AppServices, level: Level, defaults: UserDefaults = .standard) {
        self.articles = services.articles
        self.level = level
        self.defaults = defaults
    }

    var current: Noun? { trainer?.current }
    var picked: Article? { trainer?.picked }
    var hasPicked: Bool { trainer?.picked != nil }
    var isRight: Bool? { trainer?.isRight }
    /// How many nouns the round has, with the ones that came back.
    var total: Int { trainer?.queue.count ?? ArticleTrainer.roundSize }
    /// Which noun is on screen, 0-based.
    var index: Int { trainer?.index ?? 0 }
    var rightFirstTime: Int { trainer?.rightFirstTime ?? 0 }
    var asked: Int { trainer?.total ?? 0 }
    var missedCount: Int { trainer?.missed.count ?? 0 }

    /// Asks the server for the round's nouns. Called again by "Try again".
    func start() {
        guard phase != .playing else { return }
        phase = .loading
        trainer = nil
        saveFailed = false
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            do {
                let recent = defaults.stringArray(forKey: Self.recentKey) ?? []
                let answer = try await articles.request(word: nil, level: level, excluding: recent)
                guard !Task.isCancelled else { return }
                var generator = SystemRandomNumberGenerator()
                trainer = ArticleTrainer(nouns: answer.nouns, defaults: defaults, using: &generator)
                defaults.set(Array((recent + answer.nouns.map(\.word)).suffix(60)), forKey: Self.recentKey)
                phase = .playing
            } catch {
                if !Task.isCancelled { phase = .failed }
            }
        }
    }

    func stop() {
        loadTask?.cancel()
    }

    /// The learner's answer. A wrong one is kept for Fix your mistakes straight away.
    func pick(_ article: Article, in context: ModelContext) {
        guard let trainer, let noun = trainer.current, trainer.picked == nil else { return }
        trainer.pick(article)
        saveMistake(noun, picked: article, in: context)
    }

    /// Keeps the wrong answer again, after it couldn't be saved.
    func retrySave(in context: ModelContext) {
        guard let noun = current, let picked else { return }
        saveMistake(noun, picked: picked, in: context)
    }

    func next(in context: ModelContext) {
        guard let trainer, trainer.picked != nil else { return }
        trainer.next()
        saveFailed = false
        if trainer.isDone {
            trainer.recordPractice(in: context)
            phase = .done
        }
    }

    private func saveMistake(_ noun: Noun, picked: Article, in context: ModelContext) {
        do {
            try ArticleMemory.mistake(noun, picked: picked, in: context)
            saveFailed = false
        } catch {
            saveFailed = true
        }
    }
}
