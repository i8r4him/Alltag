//
//  SystemVoiceService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AVFoundation

/// Speaks German with the system voice (`AVSpeechSynthesizer`, de-DE).
/// Real in phase 1.
@Observable
final class SystemVoiceService: NSObject, VoiceService {
    private(set) var isSpeaking = false
    var prefersSlowerSpeech = false
    @ObservationIgnored private let synthesizer = AVSpeechSynthesizer()
    @ObservationIgnored private var continuation: CheckedContinuation<Void, Never>?

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String, rate: SpeechRate) async {
        stop()
        isSpeaking = true
        await withCheckedContinuation { continuation in
            self.continuation = continuation
            synthesizer.speak(Self.utterance(for: text, rate: rate.adjusted(prefersSlower: prefersSlowerSpeech)))
        }
        isSpeaking = false
    }

    func stop() {
        guard synthesizer.isSpeaking || continuation != nil else { return }
        synthesizer.stopSpeaking(at: .immediate)
        finish()
    }

    /// The utterance for `text`: German voice, rate depending on `rate`.
    static func utterance(for text: String, rate: SpeechRate) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "de-DE")
        switch rate {
        case .normal: utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        case .slow: utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.7
        }
        return utterance
    }

    private func finish() {
        continuation?.resume()
        continuation = nil
    }
}

extension SystemVoiceService: AVSpeechSynthesizerDelegate {
    /// Each word is a pulse for the orb: the system voice has no level to measure.
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange,
                                       utterance: AVSpeechUtterance) {
        VoiceMeter.shared.record(.random(in: 0.65...0.95), from: .companion)
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in self.finish() }
    }

    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in self.finish() }
    }
}
