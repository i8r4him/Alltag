//
//  VoiceMeter.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AVFoundation
import Synchronization

/// How loud the learner and the companion are right now, so the orb can show
/// who is talking. The audio services write to it from their audio threads;
/// the orb reads it once a frame.
///
/// A reading holds for a moment and then fades, so a meter that stops
/// being written (the microphone stopped, a word ended) falls back to quiet.
nonisolated final class VoiceMeter: Sendable {
    /// The one meter the app's audio writes to: only one conversation runs at a time.
    static let shared = VoiceMeter()

    enum Source: Int, Sendable {
        case learner
        case companion
    }

    private struct Reading {
        var level: Double = 0
        var time: TimeInterval = -.infinity
    }

    private let readings = Mutex<[Reading]>([Reading(), Reading()])

    /// How long a reading holds before it fades, and how fast it fades.
    static let hold: TimeInterval = 0.12
    static let fade: Double = 7

    init() {}

    /// Records `level` (0…1) for `source`.
    func record(_ level: Double, from source: Source, at time: TimeInterval = VoiceMeter.now) {
        let level = min(max(level, 0), 1)
        readings.withLock { $0[source.rawValue] = Reading(level: level, time: time) }
    }

    /// Records the loudness of `buffer` for `source`.
    func record(_ buffer: AVAudioPCMBuffer, from source: Source) {
        record(Self.level(rms: Self.rms(of: buffer)), from: source)
    }

    /// The level of `source` at `time`, faded since its last reading.
    func level(of source: Source, at time: TimeInterval = VoiceMeter.now) -> Double {
        let reading = readings.withLock { $0[source.rawValue] }
        let age = time - reading.time
        guard age > Self.hold else { return age >= 0 ? reading.level : 0 }
        return reading.level * exp(-(age - Self.hold) * Self.fade)
    }

    /// Forgets both readings.
    func reset() {
        readings.withLock { $0 = [Reading(), Reading()] }
    }

    static var now: TimeInterval { ProcessInfo.processInfo.systemUptime }

    // MARK: Measuring

    /// From a signal's RMS to 0…1: a quiet room is 0, a clear voice close to 1.
    static func level(rms: Float) -> Double {
        let decibels = 20 * log10(Double(max(rms, 1e-7)))
        return min(max((decibels + 52) / 36, 0), 1)
    }

    /// The RMS of a float or 16-bit buffer's first channel.
    static func rms(of buffer: AVAudioPCMBuffer) -> Float {
        let frames = Int(buffer.frameLength)
        guard frames > 0 else { return 0 }
        var sum: Float = 0
        if let samples = buffer.floatChannelData?[0] {
            for frame in 0..<frames { sum += samples[frame] * samples[frame] }
        } else if let samples = buffer.int16ChannelData?[0] {
            for frame in 0..<frames {
                let sample = Float(samples[frame]) / 32_768
                sum += sample * sample
            }
        } else {
            return 0
        }
        return (sum / Float(frames)).squareRoot()
    }
}
