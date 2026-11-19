//
//  OrbReactionTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AVFoundation
import CoreGraphics
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

@Suite("Orb flight")
@MainActor
struct OrbFlightTests {
    private let step = 0.01

    private func poses(through end: Double, returning: Bool = false) -> [OrbFlightPose] {
        stride(from: 0.0, through: end, by: step).map {
            returning ? OrbFlightPose(returningAt: $0) : OrbFlightPose(at: $0)
        }
    }

    @Test("The flight starts at Today's orb and ends round, at its size, still, in its place")
    func endsInPlace() {
        #expect(OrbFlightPose(at: 0).progress == 0)
        let end = OrbFlightPose(at: OrbFlightPose.duration)
        #expect(end.progress == 1)
        #expect(abs(end.growth - 1) < 0.001 && abs(end.lift) < 0.001)
        #expect(abs(end.stretchX - 1) < 0.001 && abs(end.stretchY - 1) < 0.001)
        #expect(end.glow < 0.1)
        #expect(OrbFlightPose(at: 99) == end)
    }

    @Test("It crouches before it sets off, grows, and never turns back on the way")
    func setsOff() {
        let flight = poses(through: OrbFlightPose.duration)
        #expect(flight[0].stretchY < 1 && flight[5].stretchY < flight[0].stretchY)
        #expect(flight[0].growth == 1 && flight[15].growth > 1.1)
        let progress = flight.map(\.progress)
        #expect(zip(progress, progress.dropFirst()).allSatisfy { $0 <= $1 })
    }

    @Test("It lands at touchdown with a squash and a glow, then bounces once")
    func lands() {
        let flight = poses(through: OrbFlightPose.duration)
        let touchdown = OrbFlightPose.touchdown
        #expect(OrbFlightPose(at: touchdown).progress == 1)
        #expect(OrbFlightPose(at: touchdown + 0.06).stretchY < 0.85)
        #expect(flight.map(\.glow).max() ?? 0 > 0.5)
        #expect(poses(through: touchdown - 0.02).allSatisfy { $0.glow == 0 })
        #expect(flight.map(\.lift).min() ?? 0 < -10)
    }

    @Test("Its path rises a little before it falls, and ends at both centres")
    func curve() {
        let source = CGPoint(x: 200, y: 200)
        let place = CGPoint(x: 200, y: 700)
        #expect(OrbFlightPose.point(at: 0, from: source, to: place) == source)
        #expect(OrbFlightPose.point(at: 1, from: source, to: place) == place)
        let early = OrbFlightPose.point(at: 0.1, from: source, to: place)
        #expect(early.y < source.y && early.x > source.x)
    }

    @Test("Flying back, it goes from its place to Today's orb and settles round")
    func flightBack() {
        let back = poses(through: OrbFlightPose.returnDuration, returning: true)
        #expect(back[0].progress == 1)
        let end = OrbFlightPose(returningAt: OrbFlightPose.returnDuration)
        #expect(end.progress == 0 && abs(end.growth - 1) < 0.001)
        #expect(abs(end.stretchY - 1) < 0.001)
        let progress = back.map(\.progress)
        #expect(zip(progress, progress.dropFirst()).allSatisfy { $0 >= $1 })
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
