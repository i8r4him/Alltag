//
//  ReaderModel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Observation
import SwiftData

/// The reader: one text, the word the learner tapped and what it means,
/// which words are saved, whether the text is being read aloud, and its
/// three questions.
///
/// Each word is translated once and kept while the reader is open, so tapping
/// it again doesn't ask the server again.
@Observable
final class ReaderModel {
    /// What is known about a tapped word.
    enum Lookup: Hashable {
        case loading
        case found(ReadingMeaning)
        /// Apple's translation needs the languages downloaded first.
        case needsDownload(source: Locale.Language, target: Locale.Language)
        case failed(CloudFailure)
    }

    let text: ReadingText
    let paragraphs: [ReadingParagraph]
    private(set) var selected: ReadingWord?
    /// By the word in lower case.
    private(set) var lookups: [String: Lookup] = [:]
    /// `ReadingMeaning.display` of the words in Memory.
    private(set) var saved = Set<String>()
    private(set) var isListening = false
    var notice: ToastMessage?
    let quiz: ReadingQuiz
    /// The questions are on screen.
    var showsQuestions = false

    @ObservationIgnored private var task: Task<Void, Never>?
    @ObservationIgnored private var pendingKey: String?
    /// The service the last word was looked up with, to ask again after a download.
    @ObservationIgnored private var translation: (any TranslationService)?

    init(text: ReadingText) {
        self.text = text
        paragraphs = ReadingWords.paragraphs(of: text.german)
        quiz = ReadingQuiz(questions: text.questions)
    }

    /// What is known about the selected word.
    var lookup: Lookup? {
        selected.map { lookups[Self.key($0.word)] ?? .loading }
    }

    /// The selected word's meaning, once it is there.
    var meaning: ReadingMeaning? {
        if case .found(let meaning) = lookup { meaning } else { nil }
    }

    func word(id: Int) -> ReadingWord? {
        for paragraph in paragraphs {
            if let word = paragraph.words.first(where: { $0.id == id }) { return word }
        }
        return nil
    }

    /// Shows the word and looks it up, or closes it when it is tapped again.
    func select(_ word: ReadingWord, with translation: any TranslationService) {
        guard word.isWord else { return }
        guard selected?.id != word.id else {
            close()
            return
        }
        selected = word
        lookUp(word.word, with: translation)
    }

    func close() {
        selected = nil
    }

    /// Asks again for the selected word, after a failure or a download.
    func retry(with translation: any TranslationService) {
        guard let selected else { return }
        lookups[Self.key(selected.word)] = nil
        lookUp(selected.word, with: translation)
    }

    /// The reader is back: finishes the look-up that leaving stopped.
    func resume(with translation: any TranslationService) {
        guard let selected else { return }
        lookUp(selected.word, with: translation)
    }

    /// Apple's translation has its languages now: asks again for the selected word.
    func languagesDownloaded() async {
        guard let translation else { return }
        retry(with: translation)
    }

    func downloadFailed() async {
        notice = ToastMessage(text: "The languages couldn't be downloaded. Try again later.",
                              systemImage: "exclamationmark.triangle")
    }

    private func lookUp(_ word: String, with translation: any TranslationService) {
        self.translation = translation
        let key = Self.key(word)
        guard lookups[key] == nil else { return }
        // Only the latest word is worth waiting for.
        if let pendingKey, pendingKey != key {
            task?.cancel()
            lookups[pendingKey] = nil
        }
        lookups[key] = .loading
        pendingKey = key
        task = Task { [weak self] in
            let lookup: Lookup
            do {
                if let result = try await translation.translate(word) {
                    lookup = .found(ReadingMeaning(tapped: word, result: result))
                } else {
                    lookup = .failed(.other)
                }
            } catch TranslationServiceError.needsDownload(let source, let target) {
                lookup = .needsDownload(source: source, target: target)
            } catch {
                lookup = .failed(CloudFailure(error))
            }
            guard let self, !Task.isCancelled else { return }
            lookups[key] = lookup
            if pendingKey == key { pendingKey = nil }
        }
    }

    // MARK: Memory

    func isSaved(_ meaning: ReadingMeaning) -> Bool {
        saved.contains(meaning.display)
    }

    /// Saves the selected word to Memory with its sentence, or takes it out again.
    func toggleSave(in context: ModelContext) {
        guard let selected, let meaning else { return }
        do {
            if isSaved(meaning) {
                try ReadingMemory.remove(meaning, in: context)
                saved.remove(meaning.display)
                notice = ToastMessage(text: "Removed from Memory", systemImage: "bookmark.slash.fill")
            } else {
                try ReadingMemory.save(meaning, sentence: selected.sentence, from: String(localized: text.title), in: context)
                saved.insert(meaning.display)
                notice = ToastMessage(text: "Saved to Memory")
            }
        } catch {
            notice = ToastMessage(text: "Couldn’t save it. Try again.", systemImage: "exclamationmark.triangle")
        }
    }

    /// Marks the selected word as saved when it is in Memory from earlier.
    func refreshSaved(in context: ModelContext) {
        guard let meaning, (try? ReadingMemory.isSaved(meaning, in: context)) == true else { return }
        saved.insert(meaning.display)
    }

    // MARK: Listening

    /// Reads the whole text aloud, or stops.
    func toggleListening(with voice: any VoiceService) async {
        guard !isListening else {
            voice.stop()
            isListening = false
            return
        }
        isListening = true
        await voice.speak(text.german, rate: .normal)
        isListening = false
    }

    func listen(to word: String, with voice: any VoiceService) async {
        isListening = false
        await voice.speak(word, rate: .normal)
    }

    /// The reader is leaving: stop reading aloud and the look-up on its way.
    func stop(_ voice: any VoiceService) {
        task?.cancel()
        if let pendingKey { lookups[pendingKey] = nil }
        pendingKey = nil
        voice.stop()
        isListening = false
    }

    // MARK: Questions

    /// The words of the sentence that holds the answer, lit after a wrong pick.
    var litWordIDs: Set<Int> {
        quiz.evidence.map { ReadingWords.wordIDs(of: $0, in: paragraphs) } ?? []
    }

    /// The line to scroll to when a sentence lights up.
    var litParagraphID: Int? {
        let lit = litWordIDs
        return paragraphs.first { paragraph in paragraph.words.contains { lit.contains($0.id) } }?.id
    }

    func showQuestions() {
        close()
        showsQuestions = true
    }

    /// The next question; after the last, a text with every answer right at
    /// the first try is kept as read.
    func nextQuestion(in context: ModelContext) {
        quiz.next()
        guard quiz.isPassed else { return }
        do {
            try ReadingProgress.markRead(text, in: context)
        } catch {
            notice = ToastMessage(text: "Couldn’t save it. Try again.", systemImage: "exclamationmark.triangle")
        }
    }

    /// Closes the questions; a finished round starts again next time.
    func hideQuestions() {
        showsQuestions = false
        if quiz.isFinished { quiz.restart() }
    }

    private static func key(_ word: String) -> String {
        word.lowercased()
    }
}
