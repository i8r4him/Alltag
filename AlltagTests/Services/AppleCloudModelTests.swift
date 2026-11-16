//
//  AppleCloudModelTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import Foundation
import FoundationModels
import Testing
@testable import Alltag

/// Runs only on request, on a device or simulator where Apple's cloud model
/// answers: `TEST_RUNNER_ALLTAG_PCC=1 xcodebuild test -only-testing:AlltagTests/AppleCloudModelTests …`.
/// It reports what the model says about a set of German sentences, to compare
/// with OpenAI's answers by eye; it doesn't judge them. `xcodebuild` hides what
/// tests print, so add `TEST_RUNNER_ALLTAG_PCC_OUT=/path/to/file.txt` to get the report as a file.
/// Only in a build signed with the entitlement: without it a request stops the process.
private let runsCloudModelTests = ProcessInfo.processInfo.environment["ALLTAG_PCC"] == "1"
    && PrivateCloudLanguageModelClient.isEntitled

/// Prints `line` and, when asked for, appends it to the report file.
private func report(_ line: String) {
    print(line)
    guard let path = ProcessInfo.processInfo.environment["ALLTAG_PCC_OUT"] else { return }
    let url = URL(filePath: path)
    let old = (try? String(contentsOf: url, encoding: .utf8)) ?? ""
    try? (old + line + "\n").write(to: url, atomically: true, encoding: .utf8)
}

@Suite("Apple's cloud model")
@MainActor
struct AppleCloudModelTests {
    private static let instructions = """
        You are Alltag, a warm and precise German tutor. A learner SAID the sentence below out loud; \
        speech recognition wrote it down. Judge only that sentence, as spoken German. \
        Use "fix" for a real mistake in grammar, word order, case, gender, verb form, preposition or word choice; \
        "note" when it is correct but a native speaker would clearly say it differently; \
        "good" when it is correct and natural. Do not correct punctuation or capital letters. \
        Do not invent mistakes. Write the title and note in British English. Quote German with „…“.
        """

    /// Sentence, and whether it has a mistake.
    private static let sentences: [(String, Bool)] = [
        ("Am Wochenende ich gehe oft in den Park.", true),
        ("Ich wohne seit zwei Jahren in Berlin.", false),
        ("Ich habe gestern ins Kino gegangen mit mein Freund.", true),
        ("Meine Schwester hat mir besucht letzte Woche.", true),
        ("Ich mag kochen weil es ist entspannend.", true),
        ("Heute das Wetter ist schön.", true),
        ("Wir wollen zusammen einen Film sehen.", false),
        ("Mein Bruder er wohnt in Hamburg.", true),
        ("Ich möchte lernen Deutsch schneller.", true),
        ("Das war sehr interessant für mich.", false),
        ("Ich bin 25 Jahre alt und arbeite als Ingenieur.", false),
        ("Gestern ich habe gekocht Pasta für meine Familie.", true)
    ]

    @Test("What the model's state is", .enabled(if: runsCloudModelTests))
    func state() async throws {
        let model = PrivateCloudComputeLanguageModel()
        report("PCC availability: \(model.availability)")
        report("PCC context size: \(try await model.contextSize)")
        report("PCC quota limit reached: \(model.quotaUsage.isLimitReached), resets: \(String(describing: model.quotaUsage.resetDate))")
        report("PCC supports German: \(try await model.supportsLocale(Locale(identifier: "de_DE")))")
        report("PCC supports English: \(try await model.supportsLocale(Locale(identifier: "en_GB")))")
    }

    @Test("What it says about German sentences", .enabled(if: runsCloudModelTests))
    func germanSentences() async throws {
        let client = PrivateCloudLanguageModelClient()
        var right = 0
        for (sentence, hasMistake) in Self.sentences {
            let start = ContinuousClock.now
            do {
                let answer = try await client.generate(GeneratedFeedback.self, instructions: Self.instructions,
                                                       prompt: "The learner said: „\(sentence)“")
                let seconds = (ContinuousClock.now - start).formatted(.units(allowed: [.seconds], fractionalPart: .show(length: 1)))
                let found = "\(answer.kind)" == "fix"
                if found == hasMistake { right += 1 }
                let verdict = found == hasMistake ? "OK  " : "MISS"
                report("PCC [\(seconds)] \(verdict) \(answer.kind) | \(sentence) → \(answer.correction) | \(answer.title)")
            } catch {
                report("PCC FAILED | \(sentence) | \(error)")
            }
        }
        report("PCC judged \(right) of \(Self.sentences.count) as expected")
    }
}
