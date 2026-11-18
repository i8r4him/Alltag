//
//  OrbReactionTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AVFoundation
import Testing
@testable import Alltag

@Suite("Orb reaction")
@MainActor
struct OrbReactionTests {
    @Test("Listening, the orb swells with the learner's voice")
    func listening() {
        let quiet = OrbReaction(state: .listening, voice: 0, time: 0)
        let loud = OrbReaction(state: .listening, voice: 1, time: 0)
        #expect(quiet.scale == 1 && quiet.glow == 0 && quiet.wobble == 0)
        #expect(loud.scale > 1.05)
        #expect(loud.glow > quiet.glow)
        #expect(OrbReaction.source(for: .listening) == .learner)
    }

    @Test("Speaking, the edge ripples with the companion's voice")
    func speaking() {
        let loud = OrbReaction(state: .speaking, voice: 1, time: 0)
        #expect(loud.wobble == 1)
        #expect(loud.wobble > OrbReaction(state: .listening, voice: 1, time: 0).wobble)
        #expect(OrbReaction.source(for: .speaking) == .companion)
    }

    @Test("Waiting and thinking breathe without following a voice", arguments: [VoiceOrbState.idle, .thinking])
    func breathing(state: VoiceOrbState) throws {
        #expect(OrbReaction.source(for: state) == nil)
        let scales = stride(from: 0.0, to: 4, by: 0.1).map { OrbReaction(state: state, voice: 0, time: $0).scale }
        #expect(try #require(scales.min()) < 1)
        #expect(try #require(scales.max()) > 1)
        #expect(scales.allSatisfy { abs($0 - 1) < 0.03 })
        #expect(OrbReaction(state: state, voice: 1, time: 0).wobble == 0)
    }

    @Test("A voice louder than full counts as full")
    func clamped() {
        #expect(OrbReaction(state: .speaking, voice: 5, time: 0) == OrbReaction(state: .speaking, voice: 1, time: 0))
    }

    @Test("The orb's voice rises quickly and falls slowly")
    func smoothing() {
        let voice = OrbVoice()
        let start = Date(timeIntervalSinceReferenceDate: 0)
        #expect(voice.advance(to: start, target: 1) == 0)
        let risen = voice.advance(to: start.addingTimeInterval(0.05), target: 1)
        #expect(risen > 0.6)
        let fallen = voice.advance(to: start.addingTimeInterval(0.1), target: 0)
        // The same 50 ms takes away less than half of what it added.
        #expect(fallen > risen / 2)
    }

    @Test("Each state has its own look in the eyes")
    func eyes() {
        let looks = VoiceOrbState.allCases.map(EyeLook.init(state:))
        #expect(Set(looks.map { "\($0.scale) \($0.openness) \($0.gaze)" }).count == looks.count)
        #expect(EyeLook(state: .idle) == EyeLook(state: .idle))
        #expect(EyeLook(state: .thinking).openness < 1)
        #expect(EyeLook(state: .listening).scale > 1)
    }
}

@Suite("Voice meter")
struct VoiceMeterTests {
    @Test("A reading holds for a moment, then fades")
    func fading() {
        let meter = VoiceMeter()
        meter.record(0.8, from: .learner, at: 10)
        #expect(meter.level(of: .learner, at: 10.05) == 0.8)
        #expect(meter.level(of: .learner, at: 10.3) < 0.8)
        #expect(meter.level(of: .learner, at: 11) < 0.01)
        #expect(meter.level(of: .companion, at: 10.05) == 0)
    }

    @Test("Readings are clamped to 0…1, and reset forgets them")
    func clampingAndReset() {
        let meter = VoiceMeter()
        meter.record(3, from: .companion, at: 1)
        #expect(meter.level(of: .companion, at: 1) == 1)
        meter.reset()
        #expect(meter.level(of: .companion, at: 1) == 0)
    }

    @Test("Silence is 0 and a clear voice close to 1")
    func levels() throws {
        #expect(VoiceMeter.level(rms: 0) == 0)
        #expect(VoiceMeter.level(rms: 0.001) == 0)
        #expect(VoiceMeter.level(rms: 0.1) > 0.8)
        #expect(VoiceMeter.level(rms: 1) == 1)

        let format = try #require(AVAudioFormat(standardFormatWithSampleRate: 16_000, channels: 1))
        let buffer = try #require(AVAudioPCMBuffer(pcmFormat: format, frameCapacity: 4))
        buffer.frameLength = 4
        let samples = try #require(buffer.floatChannelData?[0])
        for (frame, sample) in [Float(0.5), -0.5, 0.5, -0.5].enumerated() { samples[frame] = sample }
        #expect(VoiceMeter.rms(of: buffer) == 0.5)
    }
}
