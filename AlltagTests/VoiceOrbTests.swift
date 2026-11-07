//
//  VoiceOrbTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Voice Orb motion")
@MainActor
struct VoiceOrbTests {
    @Test("Breathing goes from 1 to 1.04 and back every 4 seconds")
    func breathe() {
        #expect(abs(OrbMotion.breathe(time: 0) - 1) < 0.0001)
        #expect(abs(OrbMotion.breathe(time: 2) - 1.04) < 0.0001)
        #expect(abs(OrbMotion.breathe(time: 4) - 1) < 0.0001)
    }

    @Test("Talking hits the prototype's keyframes", arguments: [
        (0.0, 1.0), (0.275, 1.07), (0.55, 0.97), (0.825, 1.05), (1.1, 1.0)
    ])
    func talk(time: Double, expected: Double) {
        #expect(abs(OrbMotion.talk(time: time) - expected) < 0.0001)
    }

    @Test("A ring starts small and visible and ends large and invisible")
    func ring() {
        let start = OrbMotion.ring(time: 10, delay: 10)
        #expect(abs(start.scale - 1) < 0.0001)
        #expect(abs(start.opacity - 0.7) < 0.0001)

        let nearEnd = OrbMotion.ring(time: 11.599, delay: 10)
        #expect(nearEnd.scale > 1.44)
        #expect(nearEnd.opacity < 0.01)
    }

    @Test("The second ring is half a cycle behind the first")
    func ringDelay() {
        let first = OrbMotion.ring(time: 0.8, delay: 0)
        let second = OrbMotion.ring(time: 0.8, delay: 0.8)
        #expect(first.opacity < second.opacity)
        #expect(abs(second.opacity - 0.7) < 0.0001)
    }

    @Test("The spinner turns once per second")
    func spinner() {
        #expect(abs(OrbMotion.spinnerAngle(time: 0.25) - 90) < 0.0001)
        #expect(abs(OrbMotion.spinnerAngle(time: 1.5) - 180) < 0.0001)
    }
}
