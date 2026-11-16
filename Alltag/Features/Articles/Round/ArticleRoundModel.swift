//
//  ArticleRoundModel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import Foundation
import Observation
import SwiftData

/// One round of the der, die, das game, from asking the server for the nouns
/// to the score: a noun falls, the learner taps its article before it lands,
/// and each noun falls a little faster than the one before. The screen only
/// shows what is here; time is always passed in, so the rules can be tested
/// without a clock.
@Observable
final class ArticleRoundModel {
    enum Phase: Equatable {
        /// The nouns for the learner's level are on their way.
        case loading
        /// They didn't arrive.
        case failed
        /// The nouns are here; the first one waits for "Go".
        case ready
        case playing
        case done
    }

    /// Where the words of the last rounds are kept, so a round brings new ones.
    static let recentKey = "articles.recent"
    /// Where the best score is kept.
    static let bestKey = "articles.best"
    /// How long the first noun takes to fall, in seconds.
    static let firstFall: TimeInterval = 6
    /// How much faster each next noun falls.
    static let speedUp: TimeInterval = 0.35
    /// The fastest a noun ever falls.
    static let fastestFall: TimeInterval = 2.8
    /// Points for a right article, before the bonus for being quick.
    static let points = 10
    /// The most a quick answer adds on top.
    static let quickBonus = 10

    let level: Level
    private(set) var phase: Phase = .loading
    private(set) var trainer: ArticleTrainer?
    /// Whether the last wrong answer could not be kept for Fix your mistakes.
    private(set) var saveFailed = false
    private(set) var score = 0
    /// The best score before this round.
    private(set) var best = 0
    /// Where the noun was, 0 (top) … 1 (landed), when it was answered.
    private(set) var stoppedAt: Double?
    /// The points the last answer earned, to show beside it.
    private(set) var lastPoints = 0
    private(set) var isPaused = false
    /// How many wrong articles this round were kept for Fix your mistakes.
    private(set) var savedMistakes = 0

    /// When the noun on screen started falling, or went on after a pause.
    @ObservationIgnored private var fallStart: Date?
    /// How long it fell before the last pause.
    @ObservationIgnored private var fallenBefore: TimeInterval = 0
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
    var hasAnswered: Bool { trainer?.hasAnswered ?? false }
    var timedOut: Bool { trainer?.timedOut ?? false }
    var isRight: Bool? { trainer?.isRight }
    /// How many nouns the round has, with the ones that came back.
    var total: Int { trainer?.queue.count ?? ArticleTrainer.roundSize }
    /// Which noun is on screen, 0-based.
    var index: Int { trainer?.index ?? 0 }
    var rightFirstTime: Int { trainer?.rightFirstTime ?? 0 }
    var asked: Int { trainer?.total ?? 0 }
    var missedCount: Int { trainer?.missed.count ?? 0 }
    /// The nouns that went wrong this round, in the order they came.
    var missed: [Noun] { trainer?.missed ?? [] }
    /// Whether this round beat the best score before it.
    var isNewBest: Bool { phase == .done && score > best }
    /// Whether the noun on screen is falling right now.
    var isFalling: Bool { phase == .playing && !hasAnswered && !isPaused }

    /// How long the noun on screen takes to land: a little less for each noun before it.
    var fallDuration: TimeInterval {
        max(Self.fastestFall, Self.firstFall - Self.speedUp * Double(index))
    }

    /// Where the noun on screen is, 0 (top) … 1 (landed).
    func progress(at now: Date) -> Double {
        if let stoppedAt { return stoppedAt }
        return min(1, elapsed(at: now) / fallDuration)
    }

    /// How long until the noun on screen lands.
    func remaining(at now: Date) -> TimeInterval {
        max(0, fallDuration - elapsed(at: now))
    }

    private func elapsed(at now: Date) -> TimeInterval {
        guard let fallStart, !isPaused else { return fallenBefore }
        return fallenBefore + now.timeIntervalSince(fallStart)
    }

    /// Asks the server for the round's nouns. Called again by "Try again" and "Another round".
    func start() {
        guard phase != .playing else { return }
        phase = .loading
        trainer = nil
        saveFailed = false
        score = 0
        savedMistakes = 0
        best = defaults.integer(forKey: Self.bestKey)
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
                phase = .ready
            } catch {
                if !Task.isCancelled { phase = .failed }
            }
        }
    }

    func stop() {
        loadTask?.cancel()
    }

    /// "Go": the first noun starts falling.
    func begin(at now: Date) {
        guard phase == .ready else { return }
        phase = .playing
        startFalling(at: now)
    }

    /// The learner's answer. A wrong one is kept for Fix your mistakes straight away.
    func pick(_ article: Article, at now: Date, in context: ModelContext) {
        guard phase == .playing, !isPaused, let trainer, let noun = trainer.current, !trainer.hasAnswered else { return }
        let height = progress(at: now)
        stoppedAt = height
        trainer.pick(article)
        lastPoints = article == noun.article ? Self.points + Int((Double(Self.quickBonus) * (1 - height)).rounded()) : 0
        score += lastPoints
        guard article != noun.article else { return }
        savedMistakes += 1
        saveMistake(noun, picked: article, in: context)
    }

    /// The noun landed before an article was picked: it counts as wrong and
    /// comes back, but nothing was said wrongly, so Fix your mistakes doesn't keep it.
    func land() {
        guard phase == .playing, let trainer, !trainer.hasAnswered else { return }
        stoppedAt = 1
        lastPoints = 0
        trainer.timeOut()
    }

    /// The next noun starts falling, or the round ends.
    func next(at now: Date, in context: ModelContext) {
        guard phase == .playing, let trainer, trainer.hasAnswered else { return }
        trainer.next()
        saveFailed = false
        if trainer.isDone {
            trainer.recordPractice(in: context, now: now)
            if score > best { defaults.set(score, forKey: Self.bestKey) }
            phase = .done
        } else {
            startFalling(at: now)
        }
    }

    /// The app went to the background: the noun stops where it is.
    func pause(at now: Date) {
        guard !isPaused else { return }
        fallenBefore = elapsed(at: now)
        isPaused = true
    }

    func resume(at now: Date) {
        guard isPaused else { return }
        isPaused = false
        fallStart = now
    }

    private func startFalling(at now: Date) {
        fallStart = now
        fallenBefore = 0
        stoppedAt = nil
        lastPoints = 0
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
