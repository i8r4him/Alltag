//
//  SixtySecondsModel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 12.11.26.
//

import Foundation
import NaturalLanguage
import SwiftData

/// 60 seconds: a random topic, a minute of talking, then what was said with
/// the mistakes fixed. Everything runs on the iPhone.
@Observable
final class SixtySecondsModel {
    enum Phase: Equatable {
        /// The reel is choosing a topic.
        case picking
        /// The topic is chosen; waiting for the learner to start.
        case ready
        case talking
        /// The minute is over; the last sentences are being checked.
        case checking
        case done
    }

    /// One sentence the learner said, with what the companion thinks of it.
    struct Line: Identifiable, Equatable {
        let id: UUID
        var german: String
        var feedback: Feedback?
    }

    /// Lengths of things. Short in tests.
    struct Timing {
        var seconds = 60
        var tick: Duration = .seconds(1)

        static let instant = Timing(seconds: 3, tick: .zero)
    }

    let level: Level
    private(set) var topic: TalkTopic
    private(set) var phase: Phase = .picking
    private(set) var secondsLeft: Int
    /// What has been heard so far.
    private(set) var transcript = ""
    private(set) var lines: [Line] = []
    /// Why talking couldn't start.
    var notice: ToastMessage?

    @ObservationIgnored private let speech: any SpeechService
    @ObservationIgnored private let companion: any CompanionService
    @ObservationIgnored private let timing: Timing
    @ObservationIgnored private var reviewer: LineReviewer
    @ObservationIgnored private var listenTask: Task<Void, Never>?
    @ObservationIgnored private var timerTask: Task<Void, Never>?
    /// One id per sentence position, so a sentence that is heard again keeps its id.
    @ObservationIgnored private var sentenceIDs: [UUID] = []
    @ObservationIgnored private var startedAt: Date?
    @ObservationIgnored private var secondsSpoken = 0
    @ObservationIgnored private var hasSaved = false
    /// The saved copy's id; its recording is a file named after it.
    @ObservationIgnored private let recordID = UUID()

    init(services: AppServices, level: Level, timing: Timing = Timing(), topic: TalkTopic? = nil) {
        self.speech = services.speech
        self.companion = services.companion
        self.level = level
        self.timing = timing
        self.secondsLeft = timing.seconds
        var generator = SystemRandomNumberGenerator()
        let topic = topic ?? TalkTopics.random(for: level, using: &generator)
        self.topic = topic
        self.reviewer = LineReviewer(companion: services.companion, scenario: Self.scenario(for: topic, level: level))
    }

    /// Whether the companion can check the sentences (it needs Apple Intelligence).
    var canCheck: Bool { companion.canCheckSentences }
    var fixCount: Int { lines.filter { $0.feedback?.kind == .fix }.count }
    /// How far the minute has run, 0…1.
    var progress: Double { 1 - Double(secondsLeft) / Double(max(timing.seconds, 1)) }
    /// Topic titles for the reel to run through before it lands on `topic`.
    var reelTitles: [String] {
        TalkTopics.topics(for: level).filter { $0 != topic }.shuffled().prefix(9).map(\.title) + [topic.title]
    }

    // MARK: Actions

    /// The reel has landed.
    func topicChosen() {
        if phase == .picking { phase = .ready }
    }

    /// Another topic: the reel runs again.
    func pickAnother() {
        guard phase == .ready else { return }
        var generator = SystemRandomNumberGenerator()
        topic = TalkTopics.random(for: level, not: topic, using: &generator)
        reviewer = LineReviewer(companion: companion, scenario: Self.scenario(for: topic, level: level))
        phase = .picking
    }

    func start() {
        guard phase == .ready else { return }
        phase = .talking
        transcript = ""
        secondsLeft = timing.seconds
        startedAt = .now
        let stream = speech.listen(expected: Self.simulatedTalk, recordingTo: recordingURL)
        listenTask = Task { [weak self] in
            do {
                for try await text in stream {
                    self?.heard(text)
                }
                await self?.finished()
            } catch {
                self?.failed(error)
            }
        }
        let (seconds, tick) = (timing.seconds, timing.tick)
        timerTask = Task { [weak self] in
            for left in stride(from: seconds - 1, through: 0, by: -1) {
                try? await Task.sleep(for: tick)
                guard !Task.isCancelled else { return }
                self?.secondsLeft = left
            }
            self?.finish()
        }
    }

    /// Time is up, or the learner stopped early: the stream ends with the last words.
    func finish() {
        guard phase == .talking else { return }
        timerTask?.cancel()
        speech.stopListening()
    }

    /// Stops everything, e.g. when the screen is closed.
    func stop() {
        timerTask?.cancel()
        listenTask?.cancel()
        reviewer.cancel()
        if phase == .talking { speech.stopListening() }
        // A minute that was never finished leaves no recording behind.
        if !hasSaved { try? FileManager.default.removeItem(at: recordingURL) }
    }

    private var recordingURL: URL {
        SessionHistory.audioURL(named: SessionHistory.audioFileName(for: recordID))
    }

    func waitUntilDone() async {
        await listenTask?.value
    }

    /// Records the practice and saves the fixes to Memory, once.
    func save(in context: ModelContext, now: Date = .now) {
        guard phase == .done, !hasSaved, !lines.isEmpty else { return }
        hasSaved = true
        context.insert(PracticeSession(kind: .sixtySeconds, secondsSpoken: secondsSpoken, date: startedAt ?? now))
        let detail = String(localized: "60 seconds · \(topic.title)")
        let items = lines.compactMap { line in
            line.feedback.flatMap { MistakePractice.item(said: line.german, feedback: $0, sourceDetail: detail, at: now) }
        }
        MistakePractice.save(items, in: context)
        // The copy to reread and listen to, in Learn.
        let saved = lines.map { SessionLine(isLearner: true, german: $0.german, feedback: $0.feedback.map { .init($0) }) }
        let hasRecording = FileManager.default.fileExists(atPath: recordingURL.path)
        context.insert(SessionRecord(uuid: recordID, kind: .sixtySeconds, title: detail, secondsSpoken: secondsSpoken, lines: saved,
                                     audioFileName: hasRecording ? recordingURL.lastPathComponent : "", date: startedAt ?? now))
        try? context.save()
    }

    // MARK: Listening and checking

    private func heard(_ text: String) {
        transcript = text
        // Every sentence but the last is finished: check it while they talk on.
        let sentences = Self.sentences(in: text)
        for (index, sentence) in sentences.dropLast().enumerated() {
            reviewer.check(id: id(at: index), german: sentence, replyingTo: nil)
        }
    }

    private func finished() async {
        guard phase == .talking else { return }
        timerTask?.cancel()
        secondsSpoken = min(timing.seconds, max(0, Int(Date.now.timeIntervalSince(startedAt ?? .now).rounded())))
        let sentences = Self.sentences(in: transcript)
        lines = sentences.enumerated().map { Line(id: id(at: $0.offset), german: $0.element, feedback: nil) }
        guard !lines.isEmpty else {
            notice = ToastMessage(text: "I didn't hear anything. Try again.", systemImage: "mic.slash")
            phase = .ready
            secondsLeft = timing.seconds
            return
        }
        phase = .checking
        for line in lines { reviewer.check(id: line.id, german: line.german, replyingTo: nil) }
        await reviewer.wait()
        for index in lines.indices {
            if let checked = reviewer.results[lines[index].id], checked.german == lines[index].german {
                lines[index].feedback = checked.feedback
            }
        }
        phase = .done
    }

    private func failed(_ error: any Error) {
        timerTask?.cancel()
        phase = .ready
        secondsLeft = timing.seconds
        notice = switch error as? SpeechError {
        case .notAuthorized: ToastMessage(text: "Allow the microphone and speech recognition in Settings to talk.",
                                          systemImage: "mic.slash")
        default: ToastMessage(text: "Listening isn't available on this iPhone right now.", systemImage: "mic.slash")
        }
    }

    private func id(at index: Int) -> UUID {
        while sentenceIDs.count <= index { sentenceIDs.append(UUID()) }
        return sentenceIDs[index]
    }

    /// The transcript cut into sentences.
    static func sentences(in text: String) -> [String] {
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text
        tokenizer.setLanguage(.german)
        return tokenizer.tokens(for: text.startIndex..<text.endIndex)
            .map { text[$0].trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    /// What the companion is told when it checks a sentence.
    private static func scenario(for topic: TalkTopic, level: Level) -> Scenario {
        Scenario(id: .situation, title: "Talking freely for one minute about „\(topic.title)“", meta: "",
                 goal: "say as much as they can about the topic. Learner's level (CEFR): \(level.rawValue.uppercased())",
                 completion: "", savedPhrases: [], systemImage: "timer", script: [])
    }

    /// What the simulator "hears": it can't recognise speech.
    private static let simulatedTalk = """
        Ich wohne seit zwei Jahren in Berlin. Am Wochenende ich gehe oft in den Park. \
        Meine Schwester besucht mich nächste Woche. Wir wollen zusammen kochen und einen Film sehen.
        """
}
